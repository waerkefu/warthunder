package controller;

import model.PostModel;
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
 * DeletePostController - 删除帖子控制器
 * 
 * 【功能说明】
 * 处理帖子的删除操作，包含权限检查
 * 
 * 【URL映射】
 * @WebServlet("/deletePost") - 映射到 /deletePost URL
 * 
 * 【权限控制】
 * - 普通用户：只能删除自己的帖子
 * - 小管理（版主）：可以删除普通用户的帖子，不能删除管理员和其他版主的帖子
 * - 管理员：可以删除所有帖子
 * 
 * @author WarThunder Team
 */
@WebServlet("/deletePost")
public class DeletePostController extends HttpServlet {
    
    /**
     * doGet - 处理删除帖子
     * 
     * 【功能说明】
     * 删除指定ID的帖子，包含权限验证
     * 
     * 【参数】
     * articleId - 要删除的帖子ID
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
        
        // 2. 获取帖子ID
        String articleId = req.getParameter("articleId");
        if (articleId == null || articleId.isEmpty()) {
            out.println("<script>alert('参数错误！');location.href='index.jsp';</script>");
            return;
        }
        
        try {
            // 3. 查询帖子信息
            user_service us = new user_service();
            PostModel post = us.findPostById(Integer.parseInt(articleId));
            
            // 4. 检查帖子是否存在
            if (post == null || post.getId() == 0) {
                out.println("<script>alert('帖子不存在！');location.href='index.jsp';</script>");
                return;
            }
            
            // 5. 获取当前用户和帖子作者信息
            user_model currentUser = us.findUserByUsername(loginUser);
            user_model postAuthor = us.findUserByUsername(post.getUsername());
            
            // 6. 权限检查
            boolean isAdmin = currentUser.isAdmin();
            boolean isModerator = currentUser.isModerator();
            boolean isPostAuthorAdmin = postAuthor.isAdmin();
            boolean isPostAuthorModerator = postAuthor.isModerator();
            boolean isOwner = post.getUsername().equals(loginUser);
            
            // 7. 执行权限判断
            if (!isAdmin && !isOwner) {
                // 非管理员且非作者
                if (isModerator) {
                    // 小管理检查
                    if (isPostAuthorAdmin || isPostAuthorModerator) {
                        out.println("<script>alert('小管理不能删除管理员或其他小管理的帖子！');location.href='index.jsp';</script>");
                        return;
                    }
                } else {
                    out.println("<script>alert('您只能删除自己的帖子！');location.href='index.jsp';</script>");
                    return;
                }
            }
            
            // 8. 执行删除
            int result = us.deletePost(Integer.parseInt(articleId));
            
            // 9. 返回结果
            if (result > 0) {
                out.println("<script>alert('帖子删除成功！');location.href='index.jsp';</script>");
            } else {
                out.println("<script>alert('帖子删除失败！');location.href='index.jsp';</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库错误！');location.href='index.jsp';</script>");
        }
    }
}
