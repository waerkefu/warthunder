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
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        String keyword = req.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            req.setAttribute("error", "请输入搜索关键词");
            req.getRequestDispatcher("searchResult.jsp").forward(req, resp);
            return;
        }
        
        try {
            user_service us = new user_service();
            ArrayList<PostModel> posts = us.searchPosts(keyword.trim());
            
            req.setAttribute("keyword", keyword.trim());
            req.setAttribute("posts", posts);
            req.setAttribute("resultCount", posts != null ? posts.size() : 0);
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "搜索失败，请稍后重试");
        }
        
        req.getRequestDispatcher("searchResult.jsp").forward(req, resp);
    }
}