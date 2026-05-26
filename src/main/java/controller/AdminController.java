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

@WebServlet("/admin")
public class AdminController extends HttpServlet {

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

        try {
            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);
            
            if (!user.isAdmin()) {
                out.println("<script>alert('权限不足！');history.back();</script>");
                return;
            }

            String action = req.getParameter("action");
            String postId = req.getParameter("postId");
            String commentId = req.getParameter("commentId");

            if ("ban".equals(action) && postId != null) {
                int result = us.banPost(Integer.parseInt(postId));
                if (result > 0) {
                    out.println("<script>alert('帖子已封禁！');location.href='index.jsp';</script>");
                } else {
                    out.println("<script>alert('封禁失败！');history.back();</script>");
                }
            } else if ("unban".equals(action) && postId != null) {
                int result = us.unbanPost(Integer.parseInt(postId));
                if (result > 0) {
                    out.println("<script>alert('帖子已解封！');location.href='index.jsp';</script>");
                } else {
                    out.println("<script>alert('解封失败！');history.back();</script>");
                }
            } else if ("deleteComment".equals(action) && commentId != null) {
                int result = us.deleteComment(Integer.parseInt(commentId));
                String postIdParam = req.getParameter("postId");
                if (result > 0) {
                    if (postIdParam != null) {
                        out.println("<script>alert('评论已删除！');location.href='postDetail?articleId=" + postIdParam + "';</script>");
                    } else {
                        out.println("<script>alert('评论已删除！');history.back();</script>");
                    }
                } else {
                    out.println("<script>alert('删除失败！');history.back();</script>");
                }
            } else {
                out.println("<script>alert('无效操作！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}