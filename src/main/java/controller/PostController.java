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

/**
 * PostController - 帖子编辑控制器
 * 
 * 【功能说明】
 * 处理帖子的编辑和更新操作，包括：
 * - GET请求：显示编辑表单
 * - POST请求：处理帖子更新和图片上传
 * 
 * 【URL映射】
 * @WebServlet("/editPost") - 映射到 /editPost URL
 * 
 * 【MultipartConfig注解】
 * @MultipartConfig注解用于处理文件上传：
 * - fileSizeThreshold: 文件大小阈值（超过此大小则写入磁盘）
 * - maxFileSize: 单个文件最大大小（50MB）
 * - maxRequestSize: 整个请求最大大小（100MB）
 * 
 * 【权限控制】
 * 只有帖子的作者才能编辑自己的帖子
 * 
 * @author WarThunder Team
 */
@WebServlet("/editPost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 5,      // 5MB：超过5MB的文件写入磁盘
    maxFileSize = 1024 * 1024 * 50,           // 50MB：单个文件最大50MB
    maxRequestSize = 1024 * 1024 * 100        // 100MB：整个请求最大100MB
)
public class PostController extends HttpServlet {
    
    // 文件上传目录：相对于web应用根目录
    private static final String UPLOAD_DIR = "upload/post";
    
    /**
     * doGet - 显示编辑表单
     * 
     * 【功能说明】
     * 当用户要编辑帖子时，首先访问此方法显示编辑表单
     * 
     * 【处理流程】
     * 1. 检查用户是否登录
     * 2. 获取帖子ID参数
     * 3. 转发到编辑页面
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置字符编码，防止中文乱码
        req.setCharacterEncoding("UTF-8");
        // 设置响应内容类型和编码
        resp.setContentType("text/html;charset=UTF-8");
        
        // 1. 检查用户是否登录
        // 从Session中获取登录用户名
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            // 未登录，提示用户先登录
            resp.getWriter().println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        // 2. 获取帖子ID参数
        String articleId = req.getParameter("articleId");
        if (articleId != null && !articleId.isEmpty()) {
            // 将帖子ID传递给JSP页面
            req.setAttribute("articleId", articleId);
            // 转发到编辑页面
            req.getRequestDispatcher("editPost.jsp").forward(req, resp);
            return;
        }
        
        // 参数错误，返回个人中心
        resp.getWriter().println("<script>alert('参数错误！');location.href='profile';</script>");
    }
    
    /**
     * doPost - 处理帖子编辑提交
     * 
     * 【功能说明】
     * 处理编辑表单提交，更新帖子信息和图片
     * 
     * 【处理流程】
     * 1. 检查用户是否登录
     * 2. 验证参数（标题、内容不能为空）
     * 3. 检查用户是否有权限编辑
     * 4. 处理图片上传和删除
     * 5. 调用Service更新帖子
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置字符编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 创建输出对象，用于向页面写入内容
        PrintWriter out = resp.getWriter();
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        // 2. 获取表单参数
        String postId = req.getParameter("postId");       // 帖子ID
        String title = req.getParameter("title");       // 帖子标题
        String content = req.getParameter("content");   // 帖子内容
        
        // 3. 验证必填参数
        // 检查标题和内容是否为空
        if (postId == null || postId.isEmpty() || 
            title == null || title.trim().isEmpty() || 
            content == null || content.trim().isEmpty()) {
            out.println("<script>alert('标题和内容不能为空！');history.back();</script>");
            return;
        }
        
        try {
            // 4. 查询原帖子信息
            user_service us = new user_service();
            PostModel post = us.findPostById(Integer.parseInt(postId));
            
            // 检查帖子是否存在
            if (post == null || post.getId() == 0) {
                out.println("<script>alert('帖子不存在！');location.href='profile';</script>");
                return;
            }
            
            // 5. 检查编辑权限（只能编辑自己的帖子）
            if (!post.getUsername().equals(loginUser)) {
                out.println("<script>alert('您只能编辑自己的帖子！');location.href='profile';</script>");
                return;
            }
            
            // 6. 创建上传目录
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();  // 创建多层目录
            }
            
            // 7. 获取原有图片路径（保留未修改的图片）
            String image1 = post.getImage1();
            String image2 = post.getImage2();
            String image3 = post.getImage3();
            String image4 = post.getImage4();
            String image5 = post.getImage5();
            String image6 = post.getImage6();
            
            // 8. 处理删除的图片
            // 如果用户删除了某张图片，将其设置为null
            String deleteImages = req.getParameter("deleteImages");
            if (deleteImages != null && !deleteImages.isEmpty()) {
                String[] deleteArray = deleteImages.split(",");  // 分割删除的图片编号
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
            
            // 9. 处理新上传的图片
            // 调用uploadImage方法上传每张图片
            String newImage1 = uploadImage(req.getPart("image1"), uploadPath);
            String newImage2 = uploadImage(req.getPart("image2"), uploadPath);
            String newImage3 = uploadImage(req.getPart("image3"), uploadPath);
            String newImage4 = uploadImage(req.getPart("image4"), uploadPath);
            String newImage5 = uploadImage(req.getPart("image5"), uploadPath);
            String newImage6 = uploadImage(req.getPart("image6"), uploadPath);
            
            // 如果有新上传的图片，则替换旧的图片路径
            if (newImage1 != null) image1 = newImage1;
            if (newImage2 != null) image2 = newImage2;
            if (newImage3 != null) image3 = newImage3;
            if (newImage4 != null) image4 = newImage4;
            if (newImage5 != null) image5 = newImage5;
            if (newImage6 != null) image6 = newImage6;
            
            // 10. 更新帖子
            int result = us.updatePostWithImages(
                Integer.parseInt(postId), 
                title.trim(), 
                content.trim(), 
                image1, image2, image3, image4, image5, image6
            );
            
            // 11. 返回结果
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
    
    /**
     * uploadImage - 上传单张图片
     * 
     * 【功能说明】
     * 处理单个图片文件的上传
     * 
     * 【参数说明】
     * @param part 文件Part对象，包含上传的文件内容
     * @param uploadPath 服务器端保存文件的目录路径
     * @return 保存后的文件相对路径，如果未上传则返回null
     * 
     * 【处理流程】
     * 1. 检查文件是否为空
     * 2. 获取原始文件名
     * 3. 生成新的文件名（使用UUID避免重名）
     * 4. 保存文件到服务器
     * 5. 返回文件相对路径
     */
    private String uploadImage(Part part, String uploadPath) throws IOException {
        // 检查文件是否为空或大小为0
        if (part == null || part.getSize() == 0) {
            return null;
        }
        
        // 获取上传文件的原始文件名
        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }
        
        // 获取文件扩展名（如.jpg, .png）
        String extension = fileName.substring(fileName.lastIndexOf("."));
        
        // 生成新的文件名：UUID随机字符串 + 扩展名
        // UUID可以保证文件名在全球范围内几乎不会重复
        String newFileName = UUID.randomUUID().toString() + extension;
        
        // 拼接完整的文件保存路径
        String filePath = uploadPath + File.separator + newFileName;
        
        // 将文件写入磁盘
        part.write(filePath);
        
        // 返回文件的相对路径（相对于web应用根目录）
        // 这个路径将保存到数据库，用于前端显示图片
        return UPLOAD_DIR + "/" + newFileName;
    }
}
