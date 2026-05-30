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

@WebServlet("/tutorialArticleDetail")
public class TutorialArticleDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect("tutorial.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            user_service us = new user_service();
            
            TutorialArticleModel article = us.findTutorialArticleById(id);
            if (article == null) {
                resp.sendRedirect("tutorial.jsp");
                return;
            }

            // 增加浏览次数
            us.incrementTutorialArticleViewCount(id);

            req.setAttribute("article", article);
            req.getRequestDispatcher("tutorialArticleDetail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect("tutorial.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("tutorial.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}