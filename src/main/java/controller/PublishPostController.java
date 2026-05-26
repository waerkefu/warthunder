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

@WebServlet("/publishPost")
public class PublishPostController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String loginUser = (String) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            out.println("<script>alert('请先登录！');location.href='Login.jsp';</script>");
            return;
        }

        String title = req.getParameter("title");
        String content = req.getParameter("content");

        if (title == null || title.trim().isEmpty()) {
            out.println("<script>alert('帖子标题不能为空！');history.back();</script>");
            return;
        }

        if (content == null || content.trim().isEmpty()) {
            out.println("<script>alert('帖子内容不能为空！');history.back();</script>");
            return;
        }

        if (title.length() > 100) {
            out.println("<script>alert('帖子标题不能超过100字！');history.back();</script>");
            return;
        }

        try {
            user_service us = new user_service();
            user_model user = us.findUserByUsername(loginUser);
            
            int result = us.insertPost(user.getUser_id(), title.trim(), content.trim());

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
}