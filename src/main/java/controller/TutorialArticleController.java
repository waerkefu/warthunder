package controller;

import model.TutorialArticleModel;
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

@WebServlet("/tutorialArticle")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class TutorialArticleController extends HttpServlet {

    private static final String UPLOAD_DIR = "upload/tutorial";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        String loginUser = (String) req.getSession().getAttribute("loginUser");

        try {
            user_service us = new user_service();

            if ("add".equals(action)) {
                handleAddArticle(req, resp, us, loginUser);
            } else if ("update".equals(action)) {
                handleUpdateArticle(req, resp, us, loginUser);
            } else if ("delete".equals(action)) {
                handleDeleteArticle(req, resp, us, loginUser);
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

    private void handleAddArticle(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        user_model currentUser = us.findUserByUsername(loginUser);

        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String category = req.getParameter("category");

        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('标题不能为空！');history.back();</script>");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            out.println("<script>alert('内容不能为空！');history.back();</script>");
            return;
        }

        // 处理图片上传
        String image1 = null, image2 = null, image3 = null, image4 = null, image5 = null, image6 = null;
        try {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            image1 = uploadImage(req.getPart("image1"), uploadPath);
            image2 = uploadImage(req.getPart("image2"), uploadPath);
            image3 = uploadImage(req.getPart("image3"), uploadPath);
            image4 = uploadImage(req.getPart("image4"), uploadPath);
            image5 = uploadImage(req.getPart("image5"), uploadPath);
            image6 = uploadImage(req.getPart("image6"), uploadPath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        TutorialArticleModel article = new TutorialArticleModel();
        article.setTitle(title.trim());
        article.setContent(content.trim());
        article.setCategory(category != null ? category : "maps");
        article.setUserId(currentUser.getUser_id());
        article.setUsername(loginUser);
        article.setImage1(image1);
        article.setImage2(image2);
        article.setImage3(image3);
        article.setImage4(image4);
        article.setImage5(image5);
        article.setImage6(image6);

        int result = us.addTutorialArticle(article);

        if (result > 0) {
            out.println("<script>alert('文章发布成功！');location.href='tutorial.jsp';</script>");
        } else {
            out.println("<script>alert('发布失败！');history.back();</script>");
        }
    }

    private void handleUpdateArticle(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<script>alert('文章ID不能为空！');history.back();</script>");
            return;
        }

        int id = Integer.parseInt(idStr);
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String category = req.getParameter("category");

        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('标题不能为空！');history.back();</script>");
            return;
        }

        // 获取现有文章信息
        TutorialArticleModel existingArticle = us.findTutorialArticleById(id);
        if (existingArticle == null) {
            out.println("<script>alert('文章不存在！');history.back();</script>");
            return;
        }

        // 权限检查
        user_model currentUser = us.findUserByUsername(loginUser);
        if (!currentUser.isAdmin() && !currentUser.isModerator() && existingArticle.getUserId() != currentUser.getUser_id()) {
            out.println("<script>alert('权限不足！');history.back();</script>");
            return;
        }

        // 处理图片上传
        String image1 = existingArticle.getImage1();
        String image2 = existingArticle.getImage2();
        String image3 = existingArticle.getImage3();
        String image4 = existingArticle.getImage4();
        String image5 = existingArticle.getImage5();
        String image6 = existingArticle.getImage6();

        try {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String newImage1 = uploadImage(req.getPart("image1"), uploadPath);
            String newImage2 = uploadImage(req.getPart("image2"), uploadPath);
            String newImage3 = uploadImage(req.getPart("image3"), uploadPath);
            String newImage4 = uploadImage(req.getPart("image4"), uploadPath);
            String newImage5 = uploadImage(req.getPart("image5"), uploadPath);
            String newImage6 = uploadImage(req.getPart("image6"), uploadPath);

            if (newImage1 != null) image1 = newImage1;
            if (newImage2 != null) image2 = newImage2;
            if (newImage3 != null) image3 = newImage3;
            if (newImage4 != null) image4 = newImage4;
            if (newImage5 != null) image5 = newImage5;
            if (newImage6 != null) image6 = newImage6;
        } catch (Exception e) {
            e.printStackTrace();
        }

        TutorialArticleModel article = new TutorialArticleModel();
        article.setId(id);
        article.setTitle(title.trim());
        article.setContent(content != null ? content.trim() : "");
        article.setCategory(category != null ? category : "maps");
        article.setImage1(image1);
        article.setImage2(image2);
        article.setImage3(image3);
        article.setImage4(image4);
        article.setImage5(image5);
        article.setImage6(image6);

        int result = us.updateTutorialArticle(article);

        if (result > 0) {
            out.println("<script>alert('文章更新成功！');location.href='tutorialArticleDetail?id=" + id + "';</script>");
        } else {
            out.println("<script>alert('更新失败！');history.back();</script>");
        }
    }

    private void handleDeleteArticle(HttpServletRequest req, HttpServletResponse resp, user_service us, String loginUser) throws SQLException, IOException {
        PrintWriter out = resp.getWriter();

        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<script>alert('文章ID不能为空！');history.back();</script>");
            return;
        }

        int id = Integer.parseInt(idStr);
        TutorialArticleModel article = us.findTutorialArticleById(id);

        if (article == null) {
            out.println("<script>alert('文章不存在！');history.back();</script>");
            return;
        }

        // 权限检查
        user_model currentUser = us.findUserByUsername(loginUser);
        if (!currentUser.isAdmin() && !currentUser.isModerator() && article.getUserId() != currentUser.getUser_id()) {
            out.println("<script>alert('权限不足！');history.back();</script>");
            return;
        }

        int result = us.deleteTutorialArticle(id);

        if (result > 0) {
            out.println("<script>alert('文章删除成功！');location.href='tutorial.jsp';</script>");
        } else {
            out.println("<script>alert('删除失败！');history.back();</script>");
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
}