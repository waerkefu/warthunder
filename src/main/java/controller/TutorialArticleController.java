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

/**
 * TutorialArticleController - 教程文章控制器
 * 
 * 【功能说明】
 * 处理教程文章的发布和管理
 * 
 * 【URL映射】
 * @WebServlet("/publishTutorialArticle") - 映射到 /publishTutorialArticle URL
 * 
 * 【功能】
 * - 发布教程文章
 * - 支持上传图片
 * - 支持选择分类（maps/vehicles/weakspots）
 * 
 * @author WarThunder Team
 */
@WebServlet("/publishTutorialArticle")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class TutorialArticleController extends HttpServlet {
    
    private static final String UPLOAD_DIR = "upload/tutorial";
    
    /**
     * doGet - 处理删除教程文章
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            String loginUser = (String) req.getSession().getAttribute("loginUser");
            if (loginUser == null) {
                out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
                return;
            }
            
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                user_service us = new user_service();
                int result = us.deleteTutorialArticle(id);
                
                if (result > 0) {
                    out.println("<script>alert('文章删除成功！');location.href='tutorial.jsp';</script>");
                } else {
                    out.println("<script>alert('文章删除失败！');history.back();</script>");
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                out.println("<script>alert('删除失败！');history.back();</script>");
            }
        }
    }
    
    /**
     * doPost - 处理发布教程文章
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        // 2. 获取表单参数
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String category = req.getParameter("category");
        
        // 3. 验证必填参数
        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('文章标题不能为空！');history.back();</script>");
            return;
        }
        if (content == null || content.trim().isEmpty()) {
            out.println("<script>alert('文章内容不能为空！');history.back();</script>");
            return;
        }
        if (category == null || category.isEmpty()) {
            out.println("<script>alert('请选择文章分类！');history.back();</script>");
            return;
        }
        
        try {
            // 4. 创建上传目录
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // 5. 获取用户信息
            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);
            
            // 6. 判断是添加还是编辑
            String action = req.getParameter("action");
            
            // 7. 获取原有文章数据（用于编辑时保留未更改的图片）
            TutorialArticleModel existingArticle = null;
            if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                existingArticle = us.findTutorialArticleById(id);
            }
            
            // 8. 处理图片上传（编辑时如果没有上传新图片则保留原图片）
            String image1 = uploadImage(req.getPart("image1"), uploadPath);
            String image2 = uploadImage(req.getPart("image2"), uploadPath);
            String image3 = uploadImage(req.getPart("image3"), uploadPath);
            String image4 = uploadImage(req.getPart("image4"), uploadPath);
            String image5 = uploadImage(req.getPart("image5"), uploadPath);
            String image6 = uploadImage(req.getPart("image6"), uploadPath);
            
            // 9. 编辑模式下，处理图片（保留未更改的图片，删除标记为删除的图片）
            if (existingArticle != null) {
                // 检查是否标记删除图片
                boolean deleteImage1 = "true".equals(req.getParameter("deleteImage1"));
                boolean deleteImage2 = "true".equals(req.getParameter("deleteImage2"));
                boolean deleteImage3 = "true".equals(req.getParameter("deleteImage3"));
                boolean deleteImage4 = "true".equals(req.getParameter("deleteImage4"));
                boolean deleteImage5 = "true".equals(req.getParameter("deleteImage5"));
                boolean deleteImage6 = "true".equals(req.getParameter("deleteImage6"));
                
                // 如果没有上传新图片且没有标记删除，则保留原图片
                if (image1 == null) image1 = deleteImage1 ? null : existingArticle.getImage1();
                if (image2 == null) image2 = deleteImage2 ? null : existingArticle.getImage2();
                if (image3 == null) image3 = deleteImage3 ? null : existingArticle.getImage3();
                if (image4 == null) image4 = deleteImage4 ? null : existingArticle.getImage4();
                if (image5 == null) image5 = deleteImage5 ? null : existingArticle.getImage5();
                if (image6 == null) image6 = deleteImage6 ? null : existingArticle.getImage6();
            }
            
            // 10. 创建文章对象
            TutorialArticleModel article = new TutorialArticleModel();
            article.setTitle(title.trim());
            article.setContent(content.trim());
            article.setCategory(category);
            article.setUserId(user.getUser_id());
            article.setUsername(user.getUser_name());
            article.setImage1(image1);
            article.setImage2(image2);
            article.setImage3(image3);
            article.setImage4(image4);
            article.setImage5(image5);
            article.setImage6(image6);
            
            // 11. 保存文章
            int result;
            if ("update".equals(action)) {
                // 编辑文章
                article.setId(existingArticle.getId());
                result = us.updateTutorialArticle(article);
            } else {
                // 添加文章
                result = us.addTutorialArticle(article);
            }
            
            // 9. 返回结果
            if (result > 0) {
                if ("update".equals(action)) {
                    out.println("<script>alert('文章更新成功！');location.href='tutorial.jsp';</script>");
                } else {
                    out.println("<script>alert('文章发布成功！');location.href='tutorial.jsp';</script>");
                }
            } else {
                if ("update".equals(action)) {
                    out.println("<script>alert('文章更新失败！');history.back();</script>");
                } else {
                    out.println("<script>alert('文章发布失败！');history.back();</script>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
    
    /**
     * uploadImage - 上传单张图片
     */
    private String uploadImage(Part part, String uploadPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
        
        // 获取扩展名
        String extension = fileName.substring(fileName.lastIndexOf("."));
        
        // 生成新文件名
        String newFileName = UUID.randomUUID().toString() + extension;
        
        // 保存文件
        String filePath = uploadPath + File.separator + newFileName;
        part.write(filePath);
        
        // 返回相对路径
        return UPLOAD_DIR + "/" + newFileName;
    }
}
