package controller;

import model.PostModel;
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

@WebServlet("/editPost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class PostController extends HttpServlet {

    private static final String UPLOAD_DIR = "upload/post";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.getWriter().println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String articleId = req.getParameter("articleId");
        if (articleId != null && !articleId.isEmpty()) {
            req.setAttribute("articleId", articleId);
            req.getRequestDispatcher("editPost.jsp").forward(req, resp);
            return;
        }

        resp.getWriter().println("<script>alert('参数错误！');location.href='profile';</script>");
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

        String postId = req.getParameter("postId");
        String title = req.getParameter("title");
        String content = req.getParameter("content");

        if (postId == null || postId.isEmpty() || title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            out.println("<script>alert('标题和内容不能为空！');history.back();</script>");
            return;
        }

        try {
            user_service us = new user_service();
            PostModel post = us.findPostById(Integer.parseInt(postId));

            if (post == null || post.getId() == 0) {
                out.println("<script>alert('帖子不存在！');location.href='profile';</script>");
                return;
            }

            if (!post.getUsername().equals(loginUser)) {
                out.println("<script>alert('您只能编辑自己的帖子！');location.href='profile';</script>");
                return;
            }

            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String image1 = post.getImage1();
            String image2 = post.getImage2();
            String image3 = post.getImage3();
            String image4 = post.getImage4();
            String image5 = post.getImage5();
            String image6 = post.getImage6();

            String deleteImages = req.getParameter("deleteImages");
            if (deleteImages != null && !deleteImages.isEmpty()) {
                String[] deleteArray = deleteImages.split(",");
                for (String idx : deleteArray) {
                    switch (idx) {
                        case "1": image1 = null; break;
                        case "2": image2 = null; break;
                        case "3": image3 = null; break;
                        case "4": image4 = null; break;
                        case "5": image5 = null; break;
                        case "6": image6 = null; break;
                    }
                }
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

            int result = us.updatePostWithImages(Integer.parseInt(postId), title.trim(), content.trim(), image1, image2, image3, image4, image5, image6);

            if (result > 0) {
                out.println("<script>alert('帖子编辑成功！');location.href='profile';</script>");
            } else {
                out.println("<script>alert('帖子编辑失败！');history.back();</script>");
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