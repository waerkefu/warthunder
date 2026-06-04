package controller;

import model.VideoModel;
import service.user_service;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

/**
 * VideoController - 视频教程控制器
 * 
 * 【功能说明】
 * 处理视频教程的播放功能
 * 
 * 【URL映射】
 * @WebServlet("/watchVideo") - 映射到 /watchVideo URL
 * 
 * 【功能】
 * - 增加视频播放量
 * - 传递视频信息给前端播放
 * 
 * @author WarThunder Team
 */
@WebServlet("/watchVideo")
public class VideoController extends HttpServlet {
    
    /**
     * doGet - 处理视频播放请求
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置编码
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        
        // 获取视频ID
        String videoId = req.getParameter("id");
        
        // 验证参数
        if (videoId == null || videoId.isEmpty()) {
            resp.getWriter().println("<script>alert('参数错误！');history.back();</script>");
            return;
        }
        
        try {
            // 创建Service实例
            user_service us = new user_service();
            
            // 查询视频信息
            VideoModel video = us.findVideoById(Integer.parseInt(videoId));
            
            // 检查视频是否存在
            if (video == null) {
                resp.getWriter().println("<script>alert('视频不存在！');history.back();</script>");
                return;
            }
            
            // 增加播放量
            // 每次有人观看视频，播放量+1
            us.incrementViewCount(Integer.parseInt(videoId));
            
            // 将视频信息传递给前端
            req.setAttribute("video", video);
            
            // 转发到视频播放页面
            req.getRequestDispatcher("videoPlayer.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().println("<script>alert('数据库错误！');history.back();</script>");
        }
    }
}
