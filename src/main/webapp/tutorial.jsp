<%!
    public String formatViewCount(int count) {
        if (count >= 10000) {
            return String.format("%.1f万", count / 10000.0);
        }
        return String.valueOf(count);
    }

    public String getThumbnailUrl(model.VideoModel video) {
        String url = video.getThumbnailUrl();
        if (url != null && !url.isEmpty()) {
            return url;
        }
        // 根据分类返回不同的占位图
        String category = video.getCategory();
        if ("maps".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🗺️</text></svg>";
        } else if ("vehicles".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>⚔️</text></svg>";
        } else if ("weakspots".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🎯</text></svg>";
        }
        return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🎬</text></svg>";
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user_model" %>
<%@ page import="model.VideoModel" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教程中心 - War Thunder 社区</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", sans-serif;
        }

        body {
            background-color: #181b21;
            color: #e0e0e0;
            min-height: 100vh;
            display: flex;
        }

        .sidebar {
            width: 220px;
            background-color: #1e232a;
            border-right: 1px solid #2d333b;
            padding-top: 20px;
            flex-shrink: 0;
        }

        .sidebar-logo {
            padding: 0 24px 30px;
            text-align: center;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 24px;
            color: #b0b8c1;
            text-decoration: none;
            transition: all 0.2s;
        }

        .sidebar-menu li a:hover,
        .sidebar-menu li a.active {
            background-color: #2d333b;
            color: #00e0d0;
            border-left: 3px solid #00e0d0;
        }

        .sidebar-menu li:nth-child(1) a::before { content: "💬"; }
        .sidebar-menu li:nth-child(2) a::before { content: "📖"; }
        .sidebar-menu li:nth-child(3) a::before { content: "📊"; }
        .sidebar-menu li:nth-child(4) a::before { content: "🌐"; }
        .sidebar-menu li:nth-child(5) a::before { content: "👤"; }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .top-nav {
            background-color: #1e232a;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #2d333b;
        }

        .nav-title {
            font-size: 18px;
            font-weight: 600;
            color: #fff;
        }

        .nav-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .btn-secondary {
            padding: 8px 16px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .content-area {
            padding: 24px;
        }

        .page-header {
            margin-bottom: 24px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 8px;
        }

        .page-subtitle {
            color: #8892a5;
            font-size: 14px;
        }

        .category-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }

        .category-card {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .category-card:hover {
            transform: translateY(-4px);
            border-color: #00e0d0;
            box-shadow: 0 8px 24px rgba(0, 224, 208, 0.15);
        }

        .category-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }

        .category-title {
            font-size: 20px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 8px;
        }

        .category-desc {
            color: #8892a5;
            font-size: 14px;
            line-height: 1.5;
        }

        .category-count {
            display: inline-block;
            margin-top: 12px;
            padding: 4px 12px;
            background-color: #252a32;
            border-radius: 20px;
            font-size: 12px;
            color: #00e0d0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 1px solid #2d333b;
        }

        .article-list {
            display: grid;
            gap: 16px;
        }

        .article-card {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 16px;
            display: flex;
            gap: 16px;
            transition: background-color 0.2s;
        }

        .article-card:hover {
            background-color: #252a32;
        }

        .article-thumbnail {
            width: 120px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            flex-shrink: 0;
        }

        .article-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .article-title {
            color: #fff;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            margin-bottom: 8px;
        }

        .article-title:hover {
            color: #00e0d0;
        }

        .article-meta {
            display: flex;
            gap: 16px;
            font-size: 12px;
            color: #8892a5;
        }



        .empty-state {
            text-align: center;
            padding: 60px;
            color: #8892a5;
        }

        .login-user {
            color: #00e0d0;
            margin-right: 12px;
        }

        .btn-logout {
            padding: 8px 16px;
            background-color: #d9232e;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-login {
            padding: 8px 16px;
            background-color: #2196f3;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .video-card {
            background-color: #1e232a;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 24px;
        }

        .video-thumbnail {
            position: relative;
            width: 100%;
            height: 280px;
            overflow: hidden;
        }

        .video-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-play-btn {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 64px;
            height: 64px;
            background-color: rgba(0, 224, 208, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .video-play-btn:hover {
            transform: translate(-50%, -50%) scale(1.1);
            background-color: #00e0d0;
        }

        .video-play-btn::after {
            content: "▶";
            color: #000;
            font-size: 24px;
            margin-left: 4px;
        }

        .video-info {
            padding: 20px;
        }

        .video-title {
            font-size: 18px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 8px;
        }

        .video-desc {
            color: #8892a5;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .video-meta {
            display: flex;
            gap: 16px;
            font-size: 12px;
            color: #8892a5;
        }

        .video-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .video-player {
            width: 100%;
            background-color: #000;
            border-radius: 8px;
            overflow: hidden;
        }

        .video-player iframe {
            width: 100%;
            height: 480px;
            border: none;
            display: block;
        }

        .video-section {
            margin-bottom: 32px;
        }

        .video-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
        }

        .video-compact {
            background-color: #1e232a;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .video-compact:hover {
            transform: translateY(-4px);
        }

        .video-compact-thumb {
            width: 100%;
            height: 160px;
            position: relative;
            overflow: hidden;
        }

        .video-compact-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-compact-info {
            padding: 12px;
        }

        .video-compact-title {
            color: #fff;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 4px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .video-compact-meta {
            color: #8892a5;
            font-size: 12px;
        }

        .bilibili-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background-color: #fb7299;
            color: #fff;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo">
            <h2 style="color:#fff;">WAR THUNDER</h2>
        </div>
        <ul class="sidebar-menu">
            <li><a href="index.jsp">论坛</a></li>
            <li><a href="tutorial.jsp" class="active">教程</a></li>
            <li><a href="https://statshark.net" target="_blank">战绩查询</a></li>
            <li><a href="https://warthunder.com/" target="_blank">官网</a></li>
            <li><a href="profile">个人中心</a></li>
        </ul>
    </aside>

    <div class="main-content">
        <div class="top-nav">
            <div class="nav-title">教程中心</div>
            <div class="nav-actions">
                <%
                    String loginUser = (String) session.getAttribute("loginUser");
                    user_model currentUser = null;
                    boolean isAdminOrMod = false;
                    if (loginUser != null && !loginUser.isEmpty()) {
                        try {
                            user_service us = new user_service();
                            currentUser = us.findUserByUsername(loginUser);
                            isAdminOrMod = currentUser.isAdmin() || currentUser.isModerator();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    if (loginUser != null && !loginUser.isEmpty()) {
                %>
                <span class="login-user">欢迎, <%= loginUser %></span>
                <% if (isAdminOrMod) { %>
                <button class="btn-secondary" onclick="location.href='adminVideos.jsp'">管理视频</button>
                <% } %>
                <button class="btn-logout" onclick="location.href='Login.jsp'">退出登录</button>
                <%
                    } else {
                %>
                <button class="btn-login" onclick="location.href='Login.jsp'">登录</button>
                <%
                    }
                %>
            </div>
        </div>

        <div class="content-area">
            <div class="page-header">
                <h1 class="page-title">教程中心</h1>
                <p class="page-subtitle">掌握战争雷霆的制胜之道，从这里开始</p>
            </div>

            <div class="category-grid">
                <div class="category-card" onclick="showCategory('maps')">
                    <div class="category-icon">🗺️</div>
                    <h3 class="category-title">地图解析</h3>
                    <p class="category-desc">深入了解各张地图的地形特点、战略要点和最佳战术路线</p>
                    <span class="category-count">12 篇教程</span>
                </div>

                <div class="category-card" onclick="showCategory('vehicles')">
                    <div class="category-icon">⚔️</div>
                    <h3 class="category-title">载具测评</h3>
                    <p class="category-desc">详细评测各类坦克、飞机、舰船的性能特点和战斗表现</p>
                    <span class="category-count">28 篇教程</span>
                </div>

                <div class="category-card" onclick="showCategory('weakspots')">
                    <div class="category-icon">🎯</div>
                    <h3 class="category-title">车辆弱点</h3>
                    <p class="category-desc">精准定位各系载具的装甲弱点，提升击穿效率</p>
                    <span class="category-count">15 篇教程</span>
                </div>
            </div>

            <%
                ArrayList<VideoModel> allVideos = null;
                try {
                    user_service us = new user_service();
                    allVideos = us.findAllVideos();
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                if (allVideos != null && !allVideos.isEmpty()) {
                    VideoModel featuredVideo = allVideos.get(0);
            %>
            <div class="video-section">
                <h2 class="section-title">🎬 视频教程精选</h2>
                <div class="video-card">
                    <div class="video-thumbnail">
                        <img 
                            src="<%= getThumbnailUrl(featuredVideo) %>" 
                            alt="视频缩略图"
                            onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22/><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';"
                        >
                        <div class="video-play-btn" onclick="playVideo('<%= featuredVideo.getBvid() %>')"></div>
                    </div>
                    <div class="video-info">
                        <div class="video-title">
                            <span class="bilibili-badge">Bilibili</span>
                            <%= featuredVideo.getTitle() %>
                        </div>
                        <% if (featuredVideo.getDescription() != null && !featuredVideo.getDescription().isEmpty()) { %>
                        <p class="video-desc"><%= featuredVideo.getDescription() %></p>
                        <% } %>
                        <div class="video-meta">
                            <span>👁️ <%= formatViewCount(featuredVideo.getViewCount()) %></span>
                            <span>👍 <%= featuredVideo.getLikes() %></span>
                            <span>📅 <%= featuredVideo.getCreateTime() != null ? featuredVideo.getCreateTime().substring(0, 10) : "" %></span>
                            <span>👤 <%= featuredVideo.getAuthor() != null ? featuredVideo.getAuthor() : "未知" %></span>
                        </div>
                    </div>
                </div>

                <% if (allVideos.size() > 1) { %>
                <div class="video-grid">
                    <%
                        int count = 0;
                        for (int i = 1; i < allVideos.size() && count < 4; i++) {
                            VideoModel video = allVideos.get(i);
                            count++;
                    %>
                    <div class="video-compact" onclick="playVideo('<%= video.getBvid() %>')">
                        <div class="video-compact-thumb">
                            <img 
                                src="<%= getThumbnailUrl(video) %>" 
                                alt="视频缩略图"
                                onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22/><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';"
                            >
                        </div>
                        <div class="video-compact-info">
                            <div class="video-compact-title">
                                <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                                <%= video.getTitle() %>
                            </div>
                            <div class="video-compact-meta"><%= formatViewCount(video.getViewCount()) %>播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %></div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <% } %>
            </div>
            <%
                }
            %>

            <div id="maps-section" class="section-content">
                <h2 class="section-title">🗺️ 地图解析</h2>
                <div class="article-list">
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=war%20thunder%20map%20overview%20military%20battlefield&image_size=landscape_4_3" class="article-thumbnail" alt="地图缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">诺曼底登陆地图深度解析</a>
                            <div class="article-meta">
                                <span>作者: 战术大师</span>
                                <span>发布时间: 2026-05-20</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=desert%20military%20map%20tank%20battle&image_size=landscape_4_3" class="article-thumbnail" alt="地图缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">阿拉曼战役地图战术要点</a>
                            <div class="article-meta">
                                <span>作者: 沙漠之狐</span>
                                <span>发布时间: 2026-05-18</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=urban%20city%20battle%20map%20warfare&image_size=landscape_4_3" class="article-thumbnail" alt="地图缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">柏林战役城市巷战指南</a>
                            <div class="article-meta">
                                <span>作者: 城市猎人</span>
                                <span>发布时间: 2026-05-15</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="vehicles-section" class="section-content">
                <h2 class="section-title">⚔️ 载具测评</h2>
                <div class="article-list">
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=WWII%20tank%20heavy%20armor%20military&image_size=landscape_4_3" class="article-thumbnail" alt="载具缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">虎式坦克全面测评</a>
                            <div class="article-meta">
                                <span>作者: 重装甲师</span>
                                <span>发布时间: 2026-05-22</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=modern%20fighter%20jet%20aircraft%20military&image_size=landscape_4_3" class="article-thumbnail" alt="载具缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">F-16战斗机性能分析</a>
                            <div class="article-meta">
                                <span>作者: 王牌飞行员</span>
                                <span>发布时间: 2026-05-21</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=naval%20battleship%20warship%20military&image_size=landscape_4_3" class="article-thumbnail" alt="载具缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">俾斯麦号战列舰详解</a>
                            <div class="article-meta">
                                <span>作者: 海军上将</span>
                                <span>发布时间: 2026-05-19</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="weakspots-section" class="section-content">
                <h2 class="section-title">🎯 车辆弱点分析</h2>
                <div class="article-list">
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=tank%20armor%20weak%20points%20diagram&image_size=landscape_4_3" class="article-thumbnail" alt="弱点分析缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">苏联坦克弱点全解析</a>
                            <div class="article-meta">
                                <span>作者: 装甲专家</span>
                                <span>发布时间: 2026-05-23</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=american%20tank%20armor%20analysis&image_size=landscape_4_3" class="article-thumbnail" alt="弱点分析缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">美国坦克弱点指南</a>
                            <div class="article-meta">
                                <span>作者: 穿甲高手</span>
                                <span>发布时间: 2026-05-20</span>
                            </div>
                        </div>
                    </div>
                    <div class="article-card">
                        <img src="https://neeko-copilot.bytedance.net/api/text_to_image?prompt=german%20tank%20weak%20spots%20military&image_size=landscape_4_3" class="article-thumbnail" alt="弱点分析缩略图">
                        <div class="article-content">
                            <a href="#" class="article-title">德系坦克弱点详解</a>
                            <div class="article-meta">
                                <span>作者: 战术分析师</span>
                                <span>发布时间: 2026-05-17</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showCategory(category) {
            const sections = document.querySelectorAll('.section-content');
            sections.forEach(section => {
                section.style.display = 'none';
            });

            const activeSection = document.getElementById(category + '-section');
            if (activeSection) {
                activeSection.style.display = 'block';
            }
        }

        function playVideo(bvid) {
            // 方式1：直接跳转到Bilibili
            // window.open('https://www.bilibili.com/video/' + bvid, '_blank');
            
            // 方式2：弹出层播放视频（推荐）
            showVideoModal(bvid);
        }

        function showVideoModal(bvid) {
            // 创建模态框
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.9);
                z-index: 10000;
                display: flex;
                align-items: center;
                justify-content: center;
            `;

            modal.innerHTML = `
                <div style="position: relative; width: 90%; max-width: 1000px;">
                    <button onclick="this.parentElement.parentElement.remove()" style="
                        position: absolute;
                        top: -40px;
                        right: 0;
                        background: none;
                        border: none;
                        color: #fff;
                        font-size: 28px;
                        cursor: pointer;
                    ">×</button>
                    <iframe 
                        src="https://player.bilibili.com/player.html?bvid=${bvid}&page=1&high_quality=1&danmaku=0" 
                        width="100%" 
                        height="560" 
                        scrolling="no" 
                        border="0" 
                        frameborder="no" 
                        framespacing="0" 
                        allowfullscreen="true">
                    </iframe>
                </div>
            `;

            modal.onclick = function(e) {
                if (e.target === modal) modal.remove();
            };

            document.body.appendChild(modal);
        }
    </script>
</body>
</html>