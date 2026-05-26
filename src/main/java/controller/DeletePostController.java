package controller;

import model.PostModel;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/deletePost")
public class DeletePostController extends HttpServlet {

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

        String articleId = req.getParameter("articleId");
        if (articleId == null || articleId.isEmpty()) {
            out.println("<script>alert('参数错误！');location.href='profile';</script>");
            return;
        }

        try {
            user_service us = new user_service();
            PostModel post = us.findPostById(Integer.parseInt(articleId));

            if (post == null || post.getId() == 0) {
                out.println("<script>alert('帖子不存在！');location.href='profile';</script>");
                return;
            }

            if (!post.getUsername().equals(loginUser)) {
                out.println("<script>alert('您只能删除自己的帖子！');location.href='profile';</script>");
                return;
            }

            int result = us.deletePost(Integer.parseInt(articleId));

            if (result > 0) {
                out.println("<script>alert('帖子删除成功！');location.href='profile';</script>");
            } else {
                out.println("<script>alert('帖子删除失败！');location.href='profile';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');location.href='profile';</script>");
        }
    }
}