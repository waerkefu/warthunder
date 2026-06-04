package controller;

import model.PostModel;
import model.user_model;
import model.VideoModel;
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
import java.util.ArrayList;
import java.util.UUID;

/**
 * AdminController - 管理员控制器
 * 
 * 【功能说明】
 * 处理管理员后台的所有操作，包括：
 * - 用户管理（查看、删除、修改角色）
 * - 帖子管理（查看、删除、封禁/解禁）
 * - 评论管理（删除）
 * - 视频管理（添加、编辑、删除）
 * 
 * 【URL映射】
 * @WebServlet("/admin") - 映射到 /admin URL
 * 
 * 【动作参数】
 * - action=listUsers: 用户列表
 * - action=deleteUser: 删除用户
 * - action=updateUserRole: 更新用户角色
 * - action=listPosts: 帖子列表
 * - action=banPost: 封禁帖子
 * - action=unbanPost: 解禁帖子
 * - action=deleteComment: 删除评论
 * - action=listVideos: 视频列表
 * - action=addVideo: 添加视频
 * - action=editVideo: 编辑视频
 * - action=deleteVideo: 删除视频
 * 
 * 【权限控制】
 * 只有管理员（role=0）才能访问此控制器
 * 
 * 【前端页面说明】
 * - adminUsers.jsp: 用户管理页面，使用history.back()返回上一页
 * - adminVideos.jsp: 视频管理页面，使用history.back()返回上一页
 * - 这样的设计让用户从任意页面进入管理页面后，都能方便地返回上一页
 */
@WebServlet("/admin")
@MultipartConfig(maxFileSize = 1024 * 1024 * 20)
public class AdminController extends HttpServlet {
    
    private static final String VIDEO_UPLOAD_DIR = "upload/video";
    
    /**
     * doGet - 处理管理员请求
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }
        
        try {
            // 2. 验证管理员权限
            user_service us = new user_service();
            user_model currentUser = us.findUserByUsername(loginUser);
            if (!currentUser.isAdmin()) {
                // 非管理员，显示错误
                resp.getWriter().println("<script>alert('您没有权限访问管理员后台！');location.href='index.jsp';</script>");
                return;
            }
            
            // 3. 获取action参数
            String action = req.getParameter("action");
            if (action == null) {
                action = "dashboard";  // 默认显示仪表盘
            }
            
            // 4. 根据action执行不同的操作
            switch (action) {
                case "listUsers":
                    listUsers(req, resp, us);  // 用户列表
                    break;
                case "promote":
                    promoteUser(req, resp, us);  // 设为小管理
                    break;
                case "demote":
                    demoteUser(req, resp, us);  // 撤销小管理
                    break;
                case "listPosts":
                    listPosts(req, resp, us);  // 帖子列表
                    break;
                case "searchPosts":
                    searchPosts(req, resp, us);  // 搜索帖子
                    break;
                case "listVideos":
                    listVideos(req, resp, us);  // 视频列表
                    break;
                case "deleteVideo":
                    deleteVideo(req, resp, us);  // 删除视频
                    break;
                case "deleteUser":
                    deleteUser(req, resp, us);  // 删除用户
                    break;
                case "ban":
                    banPost(req, resp, us);  // 封禁帖子
                    break;
                case "unban":
                    unbanPost(req, resp, us);  // 解禁帖子
                    break;
                default:
                    showDashboard(req, resp, us, currentUser);  // 默认显示仪表盘
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('系统错误！');location.href='index.jsp';</script>");
        }
    }
    
    /**
     * doPost - 处理POST请求
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        try {
            // 2. 验证管理员权限
            user_service us = new user_service();
            user_model currentUser = us.findUserByUsername(loginUser);
            if (!currentUser.isAdmin()) {
                out.println("<script>alert('您没有权限执行此操作！');location.href='index.jsp';</script>");
                return;
            }
            
            // 3. 获取action参数
            String action = req.getParameter("action");
            
            // 4. 根据action执行不同的操作
            switch (action) {
                case "searchUsers":
                    searchUsers(req, resp, us);  // 搜索用户
                    break;
                case "deleteUser":
                    deleteUser(req, resp, us);  // 删除用户
                    break;
                case "updateUserRole":
                    updateUserRole(req, resp, us);  // 更新用户角色
                    break;
                case "banPost":
                    banPost(req, resp, us);  // 封禁帖子
                    break;
                case "unbanPost":
                    unbanPost(req, resp, us);  // 解禁帖子
                    break;
                case "deletePost":
                    deletePost(req, resp, us);  // 删除帖子
                    break;
                case "searchPosts":
                    searchPosts(req, resp, us);  // 搜索帖子
                    break;
                case "deleteComment":
                    deleteComment(req, resp, us);  // 删除评论
                    break;
                case "addVideo":
                    addVideo(req, resp, us, loginUser);  // 添加视频
                    break;
                case "editVideo":
                    editVideo(req, resp, us);  // 编辑视频
                    break;
                case "deleteVideo":
                    deleteVideo(req, resp, us);  // 删除视频
                    break;
                default:
                    resp.sendRedirect("admin");
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('系统错误！');location.href='index.jsp';</script>");
        }
    }
    
    /**
     * showDashboard - 显示管理员仪表盘
     * 
     * 【功能说明】
     * 获取系统统计数据并传递给仪表盘页面显示
     * 包括：用户总数、帖子数、视频数、评论数、管理员数、封禁帖子数
     */
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, user_service us, user_model user) throws ServletException, IOException, SQLException {
        // 获取统计数据
        ArrayList<user_model> users = us.findAllUsers();
        ArrayList<PostModel> posts = us.findAllPostsForAdmin();
        ArrayList<VideoModel> videos = us.findAllVideos();
        
        // 获取更多统计数据
        int commentCount = us.getTotalCommentCount();
        int adminCount = us.getAdminUserCount();
        int bannedPostCount = us.getBannedPostCount();
        int activePostCount = posts.size() - bannedPostCount;
        
        // 传递给JSP
        req.setAttribute("userCount", users.size());
        req.setAttribute("postCount", posts.size());
        req.setAttribute("activePostCount", activePostCount);
        req.setAttribute("bannedPostCount", bannedPostCount);
        req.setAttribute("videoCount", videos.size());
        req.setAttribute("commentCount", commentCount);
        req.setAttribute("adminCount", adminCount);
        req.setAttribute("currentUser", user);
        
        req.getRequestDispatcher("admin.jsp").forward(req, resp);
    }
    
    /**
     * listUsers - 用户列表
     */
    private void listUsers(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        ArrayList<user_model> users = us.findAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("adminUsers.jsp").forward(req, resp);
    }
    
    /**
     * searchUsers - 搜索用户
     */
    private void searchUsers(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        String keyword = req.getParameter("keyword");
        ArrayList<user_model> users = us.searchUsers(keyword);
        req.setAttribute("users", users);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("adminUsers.jsp").forward(req, resp);
    }
    
    /**
     * deleteUser - 删除用户
     */
    private void deleteUser(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int userId = Integer.parseInt(req.getParameter("userId"));
        
        int result = us.deleteUser(userId);
        if (result > 0) {
            out.println("<script>alert('用户删除成功！');location.href='admin?action=listUsers';</script>");
        } else {
            out.println("<script>alert('用户删除失败！');history.back();</script>");
        }
    }
    
    /**
     * updateUserRole - 更新用户角色
     */
    private void updateUserRole(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int userId = Integer.parseInt(req.getParameter("userId"));
        int role = Integer.parseInt(req.getParameter("role"));
        
        int result = us.updateUserRole(userId, role);
        if (result > 0) {
            out.println("<script>alert('角色更新成功！');location.href='admin?action=listUsers';</script>");
        } else {
            out.println("<script>alert('角色更新失败！');history.back();</script>");
        }
    }
    
    /**
     * promoteUser - 设为小管理
     */
    private void promoteUser(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int userId = Integer.parseInt(req.getParameter("userId"));
        
        int result = us.updateUserRole(userId, 1);  // 1 = 小管理
        if (result > 0) {
            out.println("<script>alert('设为小管理成功！');location.href='admin?action=listUsers';</script>");
        } else {
            out.println("<script>alert('设为小管理失败！');history.back();</script>");
        }
    }
    
    /**
     * demoteUser - 撤销小管理
     */
    private void demoteUser(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int userId = Integer.parseInt(req.getParameter("userId"));
        
        int result = us.updateUserRole(userId, 2);  // 2 = 普通用户
        if (result > 0) {
            out.println("<script>alert('撤销小管理成功！');location.href='admin?action=listUsers';</script>");
        } else {
            out.println("<script>alert('撤销小管理失败！');history.back();</script>");
        }
    }
    
    /**
     * listPosts - 帖子列表
     */
    private void listPosts(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        ArrayList<PostModel> posts = us.findAllPostsForAdmin();
        req.setAttribute("posts", posts);
        req.getRequestDispatcher("adminPosts.jsp").forward(req, resp);
    }
    
    /**
     * deleteComment - 删除评论
     */
    private void deleteComment(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int commentId = Integer.parseInt(req.getParameter("commentId"));
        
        int result = us.deleteComment(commentId);
        if (result > 0) {
            out.println("<script>alert('评论删除成功！');location.href='admin?action=listPosts';</script>");
        } else {
            out.println("<script>alert('评论删除失败！');history.back();</script>");
        }
    }
    
    /**
     * banPost - 封禁帖子（支持 AJAX 请求）
     */
    private void banPost(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        int postId = Integer.parseInt(req.getParameter("postId"));
        
        int result = us.banPost(postId);
        if (result > 0) {
            out.print("{\"success\":true,\"message\":\"帖子封禁成功\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"帖子封禁失败\"}");
        }
    }
    
    /**
     * unbanPost - 解禁帖子（支持 AJAX 请求）
     */
    private void unbanPost(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        int postId = Integer.parseInt(req.getParameter("postId"));
        
        int result = us.unbanPost(postId);
        if (result > 0) {
            out.print("{\"success\":true,\"message\":\"帖子解禁成功\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"帖子解禁失败\"}");
        }
    }
    
    /**
     * deletePost - 删除帖子
     */
    private void deletePost(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int postId = Integer.parseInt(req.getParameter("postId"));
        
        int result = us.deletePost(postId);
        if (result > 0) {
            out.println("<script>alert('帖子删除成功！');location.href='admin?action=listPosts';</script>");
        } else {
            out.println("<script>alert('帖子删除失败！');history.back();</script>");
        }
    }
    
    /**
     * searchPosts - 搜索帖子
     */
    private void searchPosts(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        String keyword = req.getParameter("keyword");
        ArrayList<PostModel> posts = us.searchPosts(keyword);
        req.setAttribute("posts", posts);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("adminPosts.jsp").forward(req, resp);
    }
    
    /**
     * listVideos - 视频列表
     */
    private void listVideos(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        ArrayList<VideoModel> videos = us.findAllVideos();
        req.setAttribute("videos", videos);
        req.getRequestDispatcher("adminVideos.jsp").forward(req, resp);
    }
    
    /**
     * addVideo - 添加视频
     */
    private void addVideo(HttpServletRequest req, HttpServletResponse resp, user_service us, String author) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        
        String bvid = req.getParameter("bvid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        
        // 处理缩略图上传
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
        
        VideoModel video = new VideoModel();
        video.setBvid(bvid);
        video.setTitle(title);
        video.setDescription(description);
        video.setCategory(category);
        video.setThumbnailUrl(thumbnailUrl);
        video.setAuthor(author);
        
        int result = us.addVideo(video);
        if (result > 0) {
            out.println("<script>alert('视频添加成功！');location.href='admin?action=listVideos';</script>");
        } else {
            out.println("<script>alert('视频添加失败！');history.back();</script>");
        }
    }
    
    /**
     * editVideo - 编辑视频
     */
    private void editVideo(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        
        int id = Integer.parseInt(req.getParameter("id"));
        String bvid = req.getParameter("bvid");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String keepThumbnail = req.getParameter("keepThumbnail");
        
        // 获取现有视频信息（用于保留原缩略图）
        VideoModel existingVideo = us.findVideoById(id);
        
        // 处理缩略图上传
        String thumbnailUrl = existingVideo.getThumbnailUrl();
        if (!"true".equals(keepThumbnail)) {
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
        }
        
        VideoModel video = new VideoModel();
        video.setId(id);
        video.setBvid(bvid);
        video.setTitle(title);
        video.setDescription(description);
        video.setCategory(category);
        video.setThumbnailUrl(thumbnailUrl);
        video.setAuthor(req.getParameter("author"));
        
        int result = us.updateVideo(video);
        if (result > 0) {
            out.println("<script>alert('视频更新成功！');location.href='admin?action=listVideos';</script>");
        } else {
            out.println("<script>alert('视频更新失败！');history.back();</script>");
        }
    }
    
    /**
     * deleteVideo - 删除视频
     */
    private void deleteVideo(HttpServletRequest req, HttpServletResponse resp, user_service us) throws ServletException, IOException, SQLException {
        PrintWriter out = resp.getWriter();
        int id = Integer.parseInt(req.getParameter("id"));
        
        int result = us.deleteVideo(id);
        if (result > 0) {
            out.println("<script>alert('视频删除成功！');location.href='admin?action=listVideos';</script>");
        } else {
            out.println("<script>alert('视频删除失败！');history.back();</script>");
        }
    }
}
