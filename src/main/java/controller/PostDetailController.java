package controller;

import model.PostModel;
import model.CommentModel;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/postDetail")
public class PostDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String articleId = req.getParameter("articleId");
        if (articleId == null || articleId.isEmpty()) {
            resp.getWriter().println("<script>alert('参数错误！');location.href='index.jsp';</script>");
            return;
        }

        try {
            user_service us = new user_service();
            PostModel post = us.findPostById(Integer.parseInt(articleId));
            ArrayList<CommentModel> comments = us.findCommentsByPostId(Integer.parseInt(articleId));

            if (post == null || post.getId() == 0) {
                resp.getWriter().println("<script>alert('帖子不存在！');location.href='index.jsp';</script>");
                return;
            }

            req.setAttribute("post", post);
            req.setAttribute("comments", comments);
            req.getRequestDispatcher("postDetail.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('数据库错误！');location.href='index.jsp';</script>");
        }
    }
}