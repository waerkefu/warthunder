package controller;

import model.TutorialArticleModel;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * TutorialArticleDetailController - 教程文章详情控制器
 * 
 * 【功能说明】
 * 处理教程文章的详情页显示
 * 
 * 【URL映射】
 * @WebServlet("/tutorialArticleDetail") - 映射到 /tutorialArticleDetail URL
 * 
 * 【功能】
 * - 显示文章详情
 * - 增加文章阅读量
 * 
 * @author WarThunder Team
 */
@WebServlet("/tutorialArticleDetail")
public class TutorialArticleDetailController extends HttpServlet {
    
    /**
     * doGet - 显示文章详情
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 获取文章ID
        String articleId = req.getParameter("id");
        
        // 验证参数
        if (articleId == null || articleId.isEmpty()) {
            resp.getWriter().println("<script>alert('参数错误！');history.back();</script>");
            return;
        }
        
        try {
            // 创建Service实例
            user_service us = new user_service();
            
            // 查询文章详情
            TutorialArticleModel article = us.findTutorialArticleById(Integer.parseInt(articleId));
            
            // 检查文章是否存在
            if (article == null) {
                resp.getWriter().println("<script>alert('文章不存在！');history.back();</script>");
                return;
            }
            
            // 增加阅读量
            us.incrementTutorialArticleViewCount(Integer.parseInt(articleId));
            
            // 将文章信息传递给前端
            req.setAttribute("article", article);
            
            // 转发到文章详情页
            req.getRequestDispatcher("tutorialArticleDetail.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}
