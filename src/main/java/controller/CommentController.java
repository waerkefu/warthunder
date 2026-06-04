package controller;

import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * CommentController - 评论控制器
 * 
 * 【功能说明】
 * 处理帖子的评论功能，包括：
 * - 添加评论
 * - 回复评论
 * 
 * 【URL映射】
 * @WebServlet("/addComment") - 映射到 /addComment URL
 * 
 * 【评论功能】
 * - 支持直接评论帖子（parent_id = 0）
 * - 支持回复评论（parent_id = 被回复的评论ID）
 * 
 * 【数据验证】
 * - 评论内容不能为空
 * - 评论内容长度限制（最多500字）
 * 
 * @author WarThunder Team
 */
@WebServlet("/addComment")
public class CommentController extends HttpServlet {
    
    /**
     * doPost - 处理评论提交
     * 
     * 【功能说明】
     * 处理用户提交的评论或回复
     * 
     * 【处理流程】
     * 1. 检查用户是否登录
     * 2. 获取评论参数（帖子ID、内容、回复ID）
     * 3. 验证评论内容（不能为空、不超过500字）
     * 4. 判断是评论还是回复
     * 5. 调用Service保存评论
     * 6. 返回结果
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码
        req.setCharacterEncoding("UTF-8");
        // 设置响应内容类型
        resp.setContentType("text/html;charset=UTF-8");
        
        // 创建输出对象
        PrintWriter out = resp.getWriter();
        
        // 1. 检查用户是否登录
        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            // 未登录，提示先登录
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }
        
        // 2. 获取评论参数
        String postId = req.getParameter("postId");      // 帖子ID
        String content = req.getParameter("content");   // 评论内容
        String parentId = req.getParameter("parentId"); // 父评论ID（用于回复功能）
        
        // 3. 验证评论内容
        // 检查必填项
        if (postId == null || postId.isEmpty() || content == null || content.trim().isEmpty()) {
            out.println("<script>alert('评论内容不能为空！');history.back();</script>");
            return;
        }
        
        // 检查内容长度
        if (content.length() > 500) {
            out.println("<script>alert('评论内容不能超过500字！');history.back();</script>");
            return;
        }
        
        try {
            // 4. 创建Service实例
            user_service us = new user_service();
            
            // 获取评论者的用户ID
            user_model user = us.findUserByUsername(loginUser);
            
            // 5. 判断是评论还是回复
            int result;
            if (parentId != null && !parentId.isEmpty() && Integer.parseInt(parentId) > 0) {
                // 有parentId，表示是回复评论
                result = us.insertReplyComment(
                    Integer.parseInt(postId),      // 帖子ID
                    user.getUser_id(),              // 评论者ID
                    content.trim(),                // 评论内容
                    Integer.parseInt(parentId)     // 父评论ID
                );
            } else {
                // 没有parentId，表示是直接评论帖子
                result = us.insertComment(
                    Integer.parseInt(postId),      // 帖子ID
                    user.getUser_id(),              // 评论者ID
                    content.trim()                 // 评论内容
                );
            }
            
            // 6. 返回结果
            if (result > 0) {
                // 评论成功，跳转到帖子详情页
                // 使用location.href跳转会发起新的GET请求，重新加载页面
                out.println("<script>location.href='postDetail?articleId=" + postId + "';</script>");
            } else {
                out.println("<script>alert('评论发表失败！');history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}
