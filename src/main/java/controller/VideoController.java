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

@WebServlet("/video")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class VideoController extends HttpServlet {

    private static final String UPLOAD_DIR = "upload/video";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        String loginUser = (String) req.getSession().getAttribute("loginUser");

        try {
            user_service us = new user_service();

            if ("add".equals(action)) {
                handleAddVideo(req, resp, us, loginUser);
            } else if ("update".equals(action)) {
                handleUpdateVideo(req, resp, us, loginUser);
            } else if ("delete".equals(action)) {
                handleDeleteVideo(req, resp, us, loginUser);
            } else {
                resp.sendRedirect("tutorial.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            PrintWriter out = resp.getWriter();
            out.println("<script>alert('操作失败，请稍后重试');history.back();</script>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    private void handleAddVideo(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        user_model currentUser = us.findUserByUsername(loginUser);
        if (!currentUser.isAdmin() && !currentUser.isModerator()) {
            out.println("<script>alert('权限不足！');history.back();</script>");
            return;
        }

        String bvid = req.getParameter("bvid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String author = req.getParameter("author");

        if (bvid == null || bvid.trim().isEmpty() || title == null || title.trim().isEmpty()) {
            out.println("<script>alert('BV号和标题不能为空！');history.back();</script>");
            return;
        }

        // 处理图片上传
        String thumbnailUrl = null;
        try {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            thumbnailUrl = uploadImage(req.getPart("thumbnail"), uploadPath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        VideoModel video = new VideoModel();
        video.setBvid(bvid.trim());
        video.setTitle(title.trim());
        video.setDescription(description != null ? description.trim() : "");
        video.setThumbnailUrl(thumbnailUrl);
        video.setCategory(category != null ? category : "maps");
        video.setAuthor(author != null ? author.trim() : loginUser);

        int result = us.addVideo(video);

        if (result > 0) {
            out.println("<script>alert('视频添加成功！');location.href='adminVideos.jsp';</script>");
        } else {
            out.println("<script>alert('添加失败！');history.back();</script>");
        }
    }

    private void handleUpdateVideo(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        user_model currentUser = us.findUserByUsername(loginUser);
        if (!currentUser.isAdmin() && !currentUser.isModerator()) {
            out.println("<script>alert('权限不足！');history.back();</script>");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<script>alert('视频ID不能为空！');history.back();</script>");
            return;
        }

        int id = Integer.parseInt(idStr);
        String bvid = req.getParameter("bvid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String author = req.getParameter("author");
        String keepThumbnail = req.getParameter("keepThumbnail");

        if (bvid == null || bvid.trim().isEmpty() || title == null || title.trim().isEmpty()) {
            out.println("<script>alert('BV号和标题不能为空！');history.back();</script>");
            return;
        }

        // 获取现有视频信息
        VideoModel existingVideo = us.findVideoById(id);
        String thumbnailUrl = null;

        // 处理图片上传
        try {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            thumbnailUrl = uploadImage(req.getPart("thumbnail"), uploadPath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 如果没有上传新图片，且选择保留旧图片，则使用现有图片
        if (thumbnailUrl == null && "true".equals(keepThumbnail) && existingVideo != null) {
            thumbnailUrl = existingVideo.getThumbnailUrl();
        }

        VideoModel video = new VideoModel();
        video.setId(id);
        video.setBvid(bvid.trim());
        video.setTitle(title.trim());
        video.setDescription(description != null ? description.trim() : "");
        video.setThumbnailUrl(thumbnailUrl);
        video.setCategory(category != null ? category : "maps");
        video.setAuthor(author != null ? author.trim() : loginUser);

        int result = us.updateVideo(video);

        if (result > 0) {
            out.println("<script>alert('视频更新成功！');location.href='adminVideos.jsp';</script>");
        } else {
            out.println("<script>alert('更新失败！');history.back();</script>");
        }
    }

    private String uploadImage(Part part, String uploadPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        String extension = fileName.substring(fileName.lastIndexOf("."));
        String newFileName = UUID.randomUUID().toString() + extension;
        String filePath = uploadPath + File.separator + newFileName;

        part.write(filePath);
        return UPLOAD_DIR + "/" + newFileName;
    }

    private void handleDeleteVideo(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        user_model currentUser = us.findUserByUsername(loginUser);
        if (!currentUser.isAdmin() && !currentUser.isModerator()) {
            out.println("<script>alert('权限不足！');history.back();</script>");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<script>alert('视频ID不能为空！');history.back();</script>");
            return;
        }

        int id = Integer.parseInt(idStr);
        int result = us.deleteVideo(id);

        if (result > 0) {
            out.println("<script>alert('视频删除成功！');location.href='adminVideos.jsp';</script>");
        } else {
            out.println("<script>alert('删除失败！');history.back();</script>");
        }
    }
}