package controller;
import model.user_model;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

@WebServlet("/Login")
public class user_controller extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        user_service us = new user_service();
        user_model usm = null;
        try {
            usm = us.find_user_name_password(email,password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        if (usm.getUser_id() != 0){
            String user_name = usm.getUser_name();
            req.setAttribute("username",user_name);
            req.getSession().setAttribute("loginUser", user_name);
            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }else {
            req.getRequestDispatcher("Login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
