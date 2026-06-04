package controller;

import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * register_controller - 用户注册控制器
 * 
 * 【功能说明】
 * 处理用户注册请求，将新用户信息保存到数据库
 * 
 * 【URL映射】
 * @WebServlet("/register") - 映射到 /register URL
 * 
 * 【请求流程】
 * 1. 用户在register.jsp填写注册信息（用户名、密码、邮箱）
 * 2. 表单提交POST请求到 /register
 * 3. Controller接收参数并调用Service层
 * 4. Service调用DAO将数据保存到数据库
 * 5. 根据结果转发到登录页面或显示错误信息
 * 
 * 【参数说明】
 * - username: 用户名
 * - password: 密码
 * - email: 邮箱
 * 
 * @author WarThunder Team
 */
@WebServlet("/register")
public class register_controller extends HttpServlet {
    
    /**
     * doPost - 处理用户注册请求
     * 
     * 【处理流程】
     * 1. 设置请求编码（防止中文乱码）
     * 2. 获取表单参数（用户名、密码、邮箱）
     * 3. 调用Service层插入用户数据
     * 4. 根据插入结果决定页面跳转
     */
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 设置请求编码为UTF-8，防止中文乱码
        // 如果不设置，用户输入的中文会变成乱码
        req.setCharacterEncoding("utf-8");
        
        // 2. 获取表单参数
        // req.getParameter() 获取HTML表单中 name="xxx" 的值
        String username = req.getParameter("username");   // 用户名
        String password = req.getParameter("password");   // 密码
        String email = req.getParameter("email");         // 邮箱
        
        // 3. 创建Service实例
        user_service us = new user_service();
        
        // 4. 检查邮箱是否已被注册
        try {
            model.user_model existingUser = us.findUserByEmail(email);
            if (existingUser != null && existingUser.getUser_id() != 0) {
                // 邮箱已被注册
                req.setAttribute("error", "该邮箱已被注册");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 5. 调用用户注册方法
        // insertuser方法会向数据库插入新用户记录
        // 返回值：成功插入的记录数（通常为1）
        int i = us.insertuser(username, password, email);

        // 6. 根据插入结果决定页面跳转
        if(i > 0) {
            // 注册成功
            // 转发到登录页面，让用户登录
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
        } else {
            // 注册失败
            req.setAttribute("error", "注册失败，请重试");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
    
    /**
     * doGet - 处理GET请求
     * 
     * 【说明】
     * 如果用户直接通过URL访问 /register，则调用doPost处理
     * 通常用户注册都是通过表单POST提交，这里是安全措施
     */
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 将GET请求委托给doPost处理
        doPost(req, resp);
    }
}
