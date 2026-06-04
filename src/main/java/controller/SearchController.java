package controller;

import model.PostModel;
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
 * SearchController - 搜索控制器
 * 
 * 【功能说明】
 * 处理论坛帖子的搜索功能
 * 
 * 【URL映射】
 * @WebServlet("/search") - 映射到 /search URL
 * 
 * 【搜索方式】
 * - 支持在帖子标题和内容中搜索关键字
 * - 使用SQL的LIKE语句实现模糊匹配
 * 
 * 【参数】
 * - keyword: 搜索关键字（必填）
 * 
 * @author WarThunder Team
 */
@WebServlet("/search")
public class SearchController extends HttpServlet {
    
    /**
     * doGet - 处理搜索请求
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 获取搜索关键字
        String keyword = req.getParameter("keyword");
        
        // 验证搜索关键字
        if (keyword == null || keyword.trim().isEmpty()) {
            resp.getWriter().println("<script>alert('请输入搜索关键字！');history.back();</script>");
            return;
        }
        
        try {
            // 调用Service层执行搜索
            user_service us = new user_service();
            ArrayList<PostModel> results = us.searchPosts(keyword.trim());
            
            // 将搜索结果传递给JSP
            req.setAttribute("keyword", keyword.trim());
            req.setAttribute("results", results);
            req.setAttribute("resultCount", results.size());
            
            // 转发到搜索结果页面
            req.getRequestDispatcher("searchResult.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('搜索失败！');history.back();</script>");
        }
    }
}
