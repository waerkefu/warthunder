package controller;

import model.PostModel;
import model.TutorialArticleModel;
import model.VideoModel;
import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/review")
public class ReviewController extends HttpServlet {

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
            user_model currentUser = us.findUserByUsername(loginUser);

            if (!currentUser.isAdmin() && !currentUser.isModerator()) {
                out.println("<script>alert('您没有审核权限！');location.href='profile';</script>");
                return;
            }

            String action = req.getParameter("action");
            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    showReviewList(req, resp, us, currentUser);
                    break;
                case "passPost":
                    reviewPost(req, resp, us, 1);
                    break;
                case "rejectPost":
                    reviewPost(req, resp, us, 2);
                    break;
                case "passArticle":
                    reviewArticle(req, resp, us, 1);
                    break;
                case "rejectArticle":
                    reviewArticle(req, resp, us, 2);
                    break;
                case "passVideo":
                    reviewVideo(req, resp, us, 1);
                    break;
                case "rejectVideo":
                    reviewVideo(req, resp, us, 2);
                    break;
                default:
                    showReviewList(req, resp, us, currentUser);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('系统错误！');location.href='profile';</script>");
        }
    }

    private void showReviewList(HttpServletRequest req, HttpServletResponse resp, user_service us, user_model currentUser) throws ServletException, IOException, SQLException {
        ArrayList<PostModel> pendingPosts = us.findPendingPosts();
        ArrayList<TutorialArticleModel> pendingArticles = us.findPendingTutorialArticles();
        ArrayList<VideoModel> pendingVideos = us.findPendingVideos();

        if (!currentUser.isAdmin()) {
            pendingVideos.clear();
        }

        req.setAttribute("pendingPosts", pendingPosts);
        req.setAttribute("pendingArticles", pendingArticles);
        req.setAttribute("pendingVideos", pendingVideos);
        req.setAttribute("isAdmin", currentUser.isAdmin());

        req.getRequestDispatcher("review.jsp").forward(req, resp);
    }

    private void reviewPost(HttpServletRequest req, HttpServletResponse resp, user_service us, int status) throws IOException, SQLException {
        PrintWriter out = resp.getWriter();
        String postId = req.getParameter("id");
        String message = req.getParameter("message");

        if (postId == null || postId.isEmpty()) {
            out.println("<script>alert('参数错误！');history.back();</script>");
            return;
        }

        int result = us.reviewPost(Integer.parseInt(postId), status, message);
        if (result > 0) {
            String msg = status == 1 ? "帖子审核通过！" : "帖子审核不通过！";
            out.println("<script>alert('" + msg + "');location.href='review';</script>");
        } else {
            out.println("<script>alert('审核失败！');history.back();</script>");
        }
    }

    private void reviewArticle(HttpServletRequest req, HttpServletResponse resp, user_service us, int status) throws IOException, SQLException {
        PrintWriter out = resp.getWriter();
        String articleId = req.getParameter("id");
        String message = req.getParameter("message");

        if (articleId == null || articleId.isEmpty()) {
            out.println("<script>alert('参数错误！');history.back();</script>");
            return;
        }

        int result = us.reviewTutorialArticle(Integer.parseInt(articleId), status, message);
        if (result > 0) {
            String msg = status == 1 ? "文章审核通过！" : "文章审核不通过！";
            out.println("<script>alert('" + msg + "');location.href='review';</script>");
        } else {
            out.println("<script>alert('审核失败！');history.back();</script>");
        }
    }

    private void reviewVideo(HttpServletRequest req, HttpServletResponse resp, user_service us, int status) throws IOException, SQLException {
        PrintWriter out = resp.getWriter();
        String videoId = req.getParameter("id");
        String message = req.getParameter("message");

        if (videoId == null || videoId.isEmpty()) {
            out.println("<script>alert('参数错误！');history.back();</script>");
            return;
        }

        int result = us.reviewVideo(Integer.parseInt(videoId), status, message);
        if (result > 0) {
            String msg = status == 1 ? "视频审核通过！" : "视频审核不通过！";
            out.println("<script>alert('" + msg + "');location.href='review';</script>");
        } else {
            out.println("<script>alert('审核失败！');history.back();</script>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}