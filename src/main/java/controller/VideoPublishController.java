package controller;

import model.VideoModel;
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
import java.util.UUID;

@WebServlet("/publishVideo")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20)
public class VideoPublishController extends HttpServlet {

    private static final String VIDEO_UPLOAD_DIR = "upload/video";

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

        req.getRequestDispatcher("publishVideo.jsp").forward(req, resp);
    }

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

        String bvid = req.getParameter("bvid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String author = req.getParameter("author");

        if (bvid == null || bvid.trim().isEmpty()) {
            out.println("<script>alert('BV号不能为空！');history.back();</script>");
            return;
        }
        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('视频标题不能为空！');history.back();</script>");
            return;
        }

        String thumbnailUrl = null;
        Part thumbnailPart = req.getPart("thumbnail");
        if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + VIDEO_UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String fileName = thumbnailPart.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + extension;
            String filePath = uploadPath + File.separator + newFileName;
            thumbnailPart.write(filePath);
            thumbnailUrl = VIDEO_UPLOAD_DIR + "/" + newFileName;
        }

        try {
            user_service us = new user_service();
            user_model currentUser = us.findUserByUsername(loginUser);

            VideoModel video = new VideoModel();
            video.setBvid(bvid);
            video.setTitle(title);
            video.setDescription(description);
            video.setCategory(category != null ? category : "maps");
            video.setThumbnailUrl(thumbnailUrl);
            video.setAuthor(author != null && !author.isEmpty() ? author : loginUser);

            video.setReviewStatus(currentUser.isAdmin() ? 1 : 0);

            int result = us.addVideo(video);
            if (result > 0) {
                if (currentUser.isAdmin()) {
                    out.println("<script>alert('视频发布成功！');location.href='tutorial.jsp';</script>");
                } else {
                    out.println("<script>alert('视频已提交，等待管理员审核！');location.href='tutorial.jsp';</script>");
                }
            } else {
                out.println("<script>alert('视频发布失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('系统错误！');history.back();</script>");
        }
    }
}