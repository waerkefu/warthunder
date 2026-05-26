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
import java.sql.SQLException;

@WebServlet("/addComment")
public class CommentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String postId = req.getParameter("postId");
        String content = req.getParameter("content");
        String parentId = req.getParameter("parentId");

        if (postId == null || postId.isEmpty() || content == null || content.trim().isEmpty()) {
            out.println("<script>alert('评论内容不能为空！');history.back();</script>");
            return;
        }

        if (content.length() > 500) {
            out.println("<script>alert('评论内容不能超过500字！');history.back();</script>");
            return;
        }

        try {
            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);
            
            int result;
            if (parentId != null && !parentId.isEmpty() && Integer.parseInt(parentId) > 0) {
                result = us.insertReplyComment(Integer.parseInt(postId), user.getUser_id(), content.trim(), Integer.parseInt(parentId));
            } else {
                result = us.insertComment(Integer.parseInt(postId), user.getUser_id(), content.trim());
            }

            if (result > 0) {
                out.println("<script>location.href='postDetail?articleId=" + postId + "';</script>");
            } else {
                out.println("<script>alert('评论发表失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}