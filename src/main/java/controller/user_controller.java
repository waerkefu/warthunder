package controller;

import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

/**
 * user_controller - 用户控制器（Controller）
 * 
 * 【职责说明】
 * 这是项目的控制器层，负责处理用户HTTP请求并返回响应。
 * Controller是Web应用的入口点，接收用户的请求并调用Service处理业务逻辑。
 * 
 * 【架构位置】
 * 用户请求 → Controller → Service → DAO → 数据库
 * 
 * 【使用技术】
 * - @WebServlet: Servlet 3.0注解配置路由
 * - HttpServlet: 处理HTTP请求的基础类
 * - doGet/doPost: 处理GET/POST请求
 * 
 * 【请求流程】
 * 1. 用户发送HTTP请求（如登录表单提交）
 * 2. Servlet容器根据URL映射到对应的Controller
 * 3. Controller的doPost/doGet方法被调用
 * 4. Controller获取请求参数
 * 5. Controller调用Service层处理业务逻辑
 * 6. Controller将结果转发到JSP页面或重定向
 * 
 * 【注解说明】
 * @WebServlet("/Login"): 将URL "/Login" 映射到这个Servlet
 * 当用户访问 "/Login" 时，会调用这个Servlet
 * 
 * @author WarThunder Team
 */
@WebServlet("/Login")
public class user_controller extends HttpServlet {
    
    /**
     * doPost - 处理POST请求（用户登录表单提交）
     * 
     * 【请求来源】
     * Login.jsp页面中的登录表单，表单的action="/Login"，method="post"
     * 
     * 【处理流程】
     * 1. 设置请求编码为UTF-8（防止中文乱码）
     * 2. 获取表单参数（email和password）
     * 3. 调用Service层验证用户
     * 4. 根据验证结果决定跳转页面
     * 
     * @param req HttpServletRequest对象，包含用户请求信息
     * @param resp HttpServletResponse对象，用于返回响应
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 设置请求编码为UTF-8，防止中文乱码
        // 这一步非常重要，否则用户输入的中文会变成乱码
        req.setCharacterEncoding("UTF-8");
        
        // 2. 获取表单参数
        // req.getParameter("email") 获取HTML表单中 name="email" 的值
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        // 3. 调用Service层进行用户验证
        // 创建Service实例
        user_service us = new user_service();
        
        // 创建用户模型对象，用于接收查询结果
        user_model usm = null;
        
        // 调用登录验证方法
        // 这个方法会查询数据库，验证邮箱和密码是否匹配
        try {
            usm = us.find_user_name_password(email, password);
        } catch (SQLException e) {
            // 如果数据库操作失败，抛出运行时异常
            // 在生产环境中，这里应该记录日志而不是直接抛出异常
            throw new RuntimeException(e);
        }
        
        // 4. 根据验证结果决定页面跳转
        
        // 判断用户是否存在（user_id != 0 表示用户存在）
        if (usm.getUser_id() != 0) {
            // 登录成功
            
            // 将用户名保存到请求属性中，可以在JSP中使用
            String user_name = usm.getUser_name();
            req.setAttribute("username", user_name);
            
            // 将用户名保存到Session中，实现会话跟踪
            // Session可以跨多个页面访问用户信息
            req.getSession().setAttribute("loginUser", user_name);
            
            // 将请求转发到index.jsp页面
            // forward: 服务器内部跳转，URL不变，用户看不到跳转过程
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        } else {
            // 登录失败
            
            // 将请求转发回登录页面
            // 用户可以看到URL变化（从/Login回到/Login.jsp），但实际是转发
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
        }
    }
    
    /**
     * doGet - 处理GET请求
     * 
     * 【说明】
     * 当用户直接通过URL访问/Login时（如点击链接），会发送GET请求
     * 这里我们将GET请求委托给doPost处理
     * 
     * 【实际应用】
     * - 用户直接访问 /Login URL
     * - 登录页面刷新
     * - 从其他页面跳转到登录页面
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 将GET请求委托给doPost处理
        // 这样无论是GET还是POST请求，都走同一个处理逻辑
        doPost(req, resp);
    }
}
