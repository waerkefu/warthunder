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

/**
 * PublishPostController - 发布帖子控制器
 * 
 * 【功能说明】
 * 处理新帖子的发布，包括标题、内容和图片上传
 * 
 * 【URL映射】
 * @WebServlet("/publishPost") - 映射到 /publishPost URL
 * 
 * 【MultipartConfig注解】
 * 配置文件上传参数，支持最多100MB的请求，单个文件最大50MB
 * 
 * 【处理流程】
 * 1. 检查用户是否登录
 * 2. 验证标题和内容
 * 3. 处理图片上传（最多6张）
 * 4. 保存帖子到数据库
 * 
 * @author WarThunder Team
 */
@WebServlet("/publishPost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,      // 5MB阈值
    maxFileSize = 1024 * 1024 * 50,           // 单文件最大50MB
    maxRequestSize = 1024 * 1024 * 100        // 请求最大100MB
)
public class PublishPostController extends HttpServlet {
    
    // 图片上传目录
    private static final String UPLOAD_DIR = "upload/post";
    
    /**
     * doPost - 处理发布帖子
     * 
     * 【功能说明】
     * 接收用户发布的帖子信息，包括标题、内容和图片
     * 
     * 【参数】
     * - title: 帖子标题（必填，最多100字）
     * - content: 帖子内容（必填）
     * - image1-6: 最多6张图片（可选）
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
        
        // 3. 验证标题
        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('帖子标题不能为空！');history.back();</script>");
            return;
        }
        
        // 4. 验证内容
        if (content == null || content.trim().isEmpty()) {
            out.println("<script>alert('帖子内容不能为空！');history.back();</script>");
            return;
        }
        
        // 5. 验证标题长度
        if (title.length() > 100) {
            out.println("<script>alert('帖子标题不能超过100字！');history.back();</script>");
            return;
        }
        
        // 6. 初始化图片路径
        String image1 = null, image2 = null, image3 = null;
        String image4 = null, image5 = null, image6 = null;
        
        try {
            // 7. 创建上传目录
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // 8. 处理图片上传
            image1 = uploadImage(req.getPart("image1"), uploadPath);
            image2 = uploadImage(req.getPart("image2"), uploadPath);
            image3 = uploadImage(req.getPart("image3"), uploadPath);
            image4 = uploadImage(req.getPart("image4"), uploadPath);
            image5 = uploadImage(req.getPart("image5"), uploadPath);
            image6 = uploadImage(req.getPart("image6"), uploadPath);
            
            // 9. 获取用户信息
            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);
            
            // 10. 保存帖子
            int result = us.insertPostWithImages(
                user.getUser_id(),      // 用户ID
                title.trim(),          // 标题
                content.trim(),        // 内容
                image1, image2, image3, image4, image5, image6  // 图片
            );
            
            // 11. 返回结果
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
    
    /**
     * uploadImage - 上传单张图片
     * 
     * 【功能】处理单个图片文件的上传，使用UUID生成唯一文件名
     */
    private String uploadImage(Part part, String uploadPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
        
        // 获取文件扩展名
        String extension = fileName.substring(fileName.lastIndexOf("."));
        
        // 生成新文件名（UUID保证唯一性）
        String newFileName = UUID.randomUUID().toString() + extension;
        
        // 保存文件
        String filePath = uploadPath + File.separator + newFileName;
        part.write(filePath);
        
        // 返回相对路径
        return UPLOAD_DIR + "/" + newFileName;
    }
}
