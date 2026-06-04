package controller;

import model.PostModel;
import model.CommentModel;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * PostDetailController - 帖子详情控制器
 * 
 * 【功能说明】
 * 显示帖子的详细信息和评论列表
 * 
 * 【URL映射】
 * @WebServlet("/postDetail") - 映射到 /postDetail URL
 * 
 * 【处理流程】
 * 1. 获取帖子ID参数
 * 2. 查询帖子详情
 * 3. 查询帖子评论列表
 * 4. 转发到帖子详情页面
 * 
 * @author WarThunder Team
 */
@WebServlet("/postDetail")
public class PostDetailController extends HttpServlet {
    
    /**
     * doGet - 显示帖子详情
     * 
     * 【功能说明】
     * 根据帖子ID查询帖子详细信息和评论列表
     * 
     * 【参数】
     * articleId - 帖子ID
     * 
     * 【数据传递】
     * - post: 帖子详情（PostModel对象）
     * - comments: 评论列表（ArrayList<CommentModel>）
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 获取帖子ID参数
        String articleId = req.getParameter("articleId");
        
        // 检查参数是否有效
        if (articleId == null || articleId.isEmpty()) {
            resp.getWriter().println("<script>alert('参数错误！');location.href='index.jsp';</script>");
            return;
        }
        
        try {
            // 创建Service实例
            user_service us = new user_service();
            
            // 查询帖子详情
            PostModel post = us.findPostById(Integer.parseInt(articleId));
            
            // 查询评论列表
            ArrayList<CommentModel> comments = us.findCommentsByPostId(Integer.parseInt(articleId));
            
            // 检查帖子是否存在
            if (post == null || post.getId() == 0) {
                resp.getWriter().println("<script>alert('帖子不存在！');location.href='index.jsp';</script>");
                return;
            }
            
            // 将数据传递给JSP页面
            req.setAttribute("post", post);            // 帖子详情
            req.setAttribute("comments", comments);      // 评论列表
            
            // 转发到帖子详情页
            req.getRequestDispatcher("postDetail.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('数据库错误！');location.href='index.jsp';</script>");
        }
    }
}
