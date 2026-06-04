package controller;

import model.PostModel;
import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.UUID;

/**
 * ProfileController - 个人中心控制器
 * 
 * 【功能说明】
 * 处理用户个人中心的所有操作，包括：
 * - 查看个人资料
 * - 编辑个人资料
 * - 修改密码
 * - 上传头像
 * 
 * 【URL映射】
 * @WebServlet("/profile") - 映射到 /profile URL
 * 
 * 【动作参数】
 * - action=view: 查看个人资料
 * - action=edit: 显示编辑表单
 * - action=update: 更新个人资料
 * - action=changePassword: 显示修改密码表单
 * - action=updatePassword: 执行修改密码
 * - action=uploadAvatar: 上传头像
 * 
 * @author WarThunder Team
 */
@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class ProfileController extends HttpServlet {
    
    /**
     * doGet - 处理个人中心请求
     * 
     * 【功能说明】
     * 根据action参数执行不同的操作
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        // 2. 获取action参数
        String action = req.getParameter("action");
        if (action == null) {
            action = "view";  // 默认动作为查看
        }
        
        // 3. 创建Service实例
        user_service us = new user_service();
        
        // 4. 根据action执行不同的操作
        switch (action) {
            case "view":
                showProfile(req, resp, loginUser, us);  // 显示个人资料
                break;
            case "edit":
                showEditForm(req, resp, loginUser, us);  // 显示编辑表单
                break;
            case "update":
                updateProfile(req, resp, loginUser, us);  // 更新资料
                break;
            case "changePassword":
                showChangePasswordForm(req, resp, loginUser);  // 显示修改密码表单
                break;
            case "updatePassword":
                updatePassword(req, resp, loginUser, us);  // 修改密码
                break;
            case "uploadAvatar":
                uploadAvatar(req, resp, loginUser, us);  // 上传头像
                break;
            default:
                showProfile(req, resp, loginUser, us);  // 默认显示个人资料
                break;
        }
    }
    
    /**
     * showProfile - 显示个人资料
     */
    private void showProfile(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        try {
            // 查询用户信息
            user_model user = us.findUserByUsername(loginUser);
            
            // 查询用户的帖子列表
            ArrayList<PostModel> posts = us.findPostsByUserId(user.getUser_id());
            
            // 统计发帖数量
            int postCount = us.getUserPostCount(user.getUser_id());
            
            // 传递数据给JSP
            req.setAttribute("user", user);
            req.setAttribute("posts", posts);
            req.setAttribute("postCount", postCount);
            
            // 转发到个人中心页面
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * showEditForm - 显示编辑表单
     */
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        try {
            user_model user = us.findUserByUsername(loginUser);
            req.setAttribute("user", user);
            req.getRequestDispatcher("editProfile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * updateProfile - 更新个人资料
     */
    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        String newUsername = req.getParameter("username");
        String newEmail = req.getParameter("email");
        
        // 验证参数
        if (newUsername == null || newUsername.trim().isEmpty() || newEmail == null || newEmail.trim().isEmpty()) {
            out.println("<script>alert('用户名和邮箱不能为空！');history.back();</script>");
            return;
        }
        
        try {
            user_model user = us.findUserByUsername(loginUser);
            int result = us.updateUserInfo(user.getUser_id(), newUsername, newEmail);
            
            if (result > 0) {
                // 更新Session中的用户名
                req.getSession().setAttribute("loginUser", newUsername);
                out.println("<script>alert('资料更新成功！');location.href='profile';</script>");
            } else {
                out.println("<script>alert('资料更新失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * showChangePasswordForm - 显示修改密码表单
     */
    private void showChangePasswordForm(HttpServletRequest req, HttpServletResponse resp, String loginUser) throws ServletException, IOException {
        req.setAttribute("loginUser", loginUser);
        req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
    }
    
    /**
     * updatePassword - 修改密码
     */
    private void updatePassword(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        
        // 验证参数
        if (oldPassword == null || oldPassword.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            out.println("<script>alert('密码不能为空！');history.back();</script>");
            return;
        }
        
        // 验证新密码和确认密码是否一致
        if (!newPassword.equals(confirmPassword)) {
            out.println("<script>alert('两次输入的密码不一致！');history.back();</script>");
            return;
        }
        
        // 验证密码长度
        if (newPassword.length() < 6) {
            out.println("<script>alert('密码长度至少为6位！');history.back();</script>");
            return;
        }
        
        try {
            user_model user = us.findUserByUsername(loginUser);
            
            // 验证旧密码是否正确
            if (!user.getUser_password().equals(oldPassword)) {
                out.println("<script>alert('旧密码不正确！');history.back();</script>");
                return;
            }
            
            // 更新密码
            int result = us.changePassword(user.getUser_id(), newPassword);
            if (result > 0) {
                out.println("<script>alert('密码修改成功！');location.href='profile';</script>");
            } else {
                out.println("<script>alert('密码修改失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * uploadAvatar - 上传头像
     */
    private void uploadAvatar(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        try {
            // 获取上传的文件
            Part part = req.getPart("avatar");
            if (part == null || part.getSize() == 0) {
                out.println("{\"success\":false,\"message\":\"请选择要上传的图片\"}");
                return;
            }
            
            // 获取文件名
            String fileName = part.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            
            // 验证文件格式
            if (!extension.toLowerCase().matches("\\.(jpg|jpeg|png|gif)")) {
                out.println("{\"success\":false,\"message\":\"只支持JPG、PNG、GIF格式的图片\"}");
                return;
            }
            
            // 创建上传目录
            String uploadPath = getServletContext().getRealPath("/") + "upload/avatar";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // 生成新文件名
            String newFileName = UUID.randomUUID().toString() + extension;
            String filePath = uploadPath + File.separator + newFileName;
            
            // 保存文件
            part.write(filePath);
            
            // 保存头像路径到数据库
            String avatarUrl = "upload/avatar/" + newFileName;
            user_model user = us.findUserByUsername(loginUser);
            int result = us.updateAvatar(user.getUser_id(), avatarUrl);
            
            if (result > 0) {
                out.println("{\"success\":true,\"message\":\"头像上传成功\"}");
            } else {
                out.println("{\"success\":false,\"message\":\"头像保存失败\"}");
            }
        } catch (SQLException e) {
            out.println("{\"success\":false,\"message\":\"数据库错误\"}");
            e.printStackTrace();
        }
    }
    
    /**
     * doPost - 处理POST请求
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
