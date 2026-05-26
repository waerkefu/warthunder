package controller;

import model.CommentModel;
import model.PostModel;
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

@WebServlet("/deleteComment")
public class DeleteCommentController extends HttpServlet {

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

        String commentId = req.getParameter("commentId");
        String postId = req.getParameter("postId");

        if (commentId == null || commentId.isEmpty()) {
            out.println("<script>alert('参数错误！');history.back();</script>");
            return;
        }

        try {
            user_service us = new user_service();
            CommentModel comment = us.findCommentsByPostId(Integer.parseInt(postId)).stream()
                    .filter(c -> c.getId() == Integer.parseInt(commentId))
                    .findFirst()
                    .orElse(null);

            if (comment == null) {
                out.println("<script>alert('评论不存在！');history.back();</script>");
                return;
            }

            user_model currentUser = us.findUserByUsername(loginUser);
            boolean isAdmin = currentUser.isAdmin();
            boolean isOwner = loginUser.equals(comment.getUsername());

            PostModel post = us.findPostById(Integer.parseInt(postId));
            boolean isPostOwner = loginUser.equals(post.getUsername());

            if (!isAdmin && !isOwner && !isPostOwner) {
                out.println("<script>alert('您只能删除自己的评论！');history.back();</script>");
                return;
            }

            int result = us.deleteComment(Integer.parseInt(commentId));

            if (result > 0) {
                String redirectUrl = postId != null ? "postDetail?articleId=" + postId : "index.jsp";
                out.println("<script>alert('评论已删除！');location.href='" + redirectUrl + "';</script>");
            } else {
                out.println("<script>alert('删除失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}