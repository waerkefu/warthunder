package controller;

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

@WebServlet("/publishPost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class PublishPostController extends HttpServlet {

    private static final String UPLOAD_DIR = "upload/post";

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

        String title = req.getParameter("title");
        String content = req.getParameter("content");

        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('帖子标题不能为空！');history.back();</script>");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            out.println("<script>alert('帖子内容不能为空！');history.back();</script>");
            return;
        }

        if (title.length() > 100) {
            out.println("<script>alert('帖子标题不能超过100字！');history.back();</script>");
            return;
        }

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

            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);

            int result = us.insertPostWithImages(user.getUser_id(), title.trim(), content.trim(), image1, image2, image3, image4, image5, image6);

            if (result > 0) {
                out.println("<script>alert('帖子发布成功！');location.href='index.jsp';</script>");
            } else {
                out.println("<script>alert('帖子发布失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
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