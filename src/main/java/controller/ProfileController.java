package controller;

import model.ArticleModel;
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

@WebServlet("/profile")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "view";
        }

        user_service us = new user_service();

        switch (action) {
            case "view":
                showProfile(req, resp, loginUser, us);
                break;
            case "edit":
                showEditForm(req, resp, loginUser, us);
                break;
            case "update":
                updateProfile(req, resp, loginUser, us);
                break;
            case "changePassword":
                showChangePasswordForm(req, resp, loginUser);
                break;
            case "updatePassword":
                updatePassword(req, resp, loginUser, us);
                break;
            case "uploadAvatar":
                uploadAvatar(req, resp, loginUser, us);
                break;
            default:
                showProfile(req, resp, loginUser, us);
                break;
        }
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        try {
            user_model user = us.findUserByUsername(loginUser);
            ArrayList<PostModel> posts = us.findPostsByUserId(user.getUser_id());
            int postCount = us.getUserPostCount(user.getUser_id());

            req.setAttribute("user", user);
            req.setAttribute("posts", posts);
            req.setAttribute("postCount", postCount);
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        try {
            user_model user = us.findUserByUsername(loginUser);
            req.setAttribute("user", user);
            req.getRequestDispatcher("editProfile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        String newUsername = req.getParameter("username");
        String newEmail = req.getParameter("email");

        if (newUsername == null || newUsername.trim().isEmpty() || newEmail == null || newEmail.trim().isEmpty()) {
            out.println("<script>alert('用户名和邮箱不能为空！');history.back();</script>");
            return;
        }

        try {
            user_model user = us.findUserByUsername(loginUser);
            int result = us.updateUserInfo(user.getUser_id(), newUsername, newEmail);

            if (result > 0) {
                req.getSession().setAttribute("loginUser", newUsername);
                out.println("<script>alert('资料更新成功！');location.href='profile';</script>");
            } else {
                out.println("<script>alert('资料更新失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void showChangePasswordForm(HttpServletRequest req, HttpServletResponse resp, String loginUser) throws ServletException, IOException {
        req.setAttribute("loginUser", loginUser);
        req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
    }

    private void updatePassword(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        PrintWriter out = resp.getWriter();
        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            out.println("<script>alert('密码不能为空！');history.back();</script>");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            out.println("<script>alert('两次输入的密码不一致！');history.back();</script>");
            return;
        }

        if (newPassword.length() < 6) {
            out.println("<script>alert('密码长度至少为6位！');history.back();</script>");
            return;
        }

        try {
            user_model user = us.findUserByUsername(loginUser);
            if (!user.getUser_password().equals(oldPassword)) {
                out.println("<script>alert('旧密码不正确！');history.back();</script>");
                return;
            }

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

    private void uploadAvatar(HttpServletRequest req, HttpServletResponse resp, String loginUser, user_service us) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            Part part = req.getPart("avatar");
            if (part == null || part.getSize() == 0) {
                out.println("{\"success\":false,\"message\":\"请选择要上传的图片\"}");
                return;
            }

            String fileName = part.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            if (!extension.toLowerCase().matches("\\.(jpg|jpeg|png|gif)")) {
                out.println("{\"success\":false,\"message\":\"只支持JPG、PNG、GIF格式的图片\"}");
                return;
            }

            String uploadPath = getServletContext().getRealPath("/") + "upload/avatar";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String newFileName = UUID.randomUUID().toString() + extension;
            String filePath = uploadPath + File.separator + newFileName;
            part.write(filePath);

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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}