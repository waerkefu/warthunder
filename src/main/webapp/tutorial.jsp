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
<%@ page import="model.TutorialArticleModel" %>
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

        .article-section {
            margin-bottom: 32px;
        }

        .article-thumbnail-placeholder {
            width: 120px;
            height: 80px;
            background-color: #252a32;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            flex-shrink: 0;
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
                <%
                    // 获取各分类的数量
                    user_service us = new user_service();
                    int mapsArticleCount = us.getTutorialArticleCountByCategory("maps");
                    int mapsVideoCount = us.getTutorialVideoCountByCategory("maps");
                    int vehiclesArticleCount = us.getTutorialArticleCountByCategory("vehicles");
                    int vehiclesVideoCount = us.getTutorialVideoCountByCategory("vehicles");
                    int weakspotsArticleCount = us.getTutorialArticleCountByCategory("weakspots");
                    int weakspotsVideoCount = us.getTutorialVideoCountByCategory("weakspots");
                    
                    int totalArticleCount = mapsArticleCount + vehiclesArticleCount + weakspotsArticleCount;
                    int totalVideoCount = mapsVideoCount + vehiclesVideoCount + weakspotsVideoCount;
                %>
                <div class="category-card" onclick="showCategory('all')">
                    <div class="category-icon">📚</div>
                    <h3 class="category-title">全部内容</h3>
                    <p class="category-desc">查看所有教程文章和视频</p>
                    <span class="category-count"><%= totalArticleCount %> 篇文章 · <%= totalVideoCount %> 个视频</span>
                </div>

                <div class="category-card" onclick="showCategory('maps')">
                    <div class="category-icon">🗺️</div>
                    <h3 class="category-title">地图解析</h3>
                    <p class="category-desc">深入了解各张地图的地形特点、战略要点和最佳战术路线</p>
                    <span class="category-count"><%= mapsArticleCount %> 篇文章 · <%= mapsVideoCount %> 个视频</span>
                </div>

                <div class="category-card" onclick="showCategory('vehicles')">
                    <div class="category-icon">⚔️</div>
                    <h3 class="category-title">载具测评</h3>
                    <p class="category-desc">详细评测各类坦克、飞机、舰船的性能特点和战斗表现</p>
                    <span class="category-count"><%= vehiclesArticleCount %> 篇文章 · <%= vehiclesVideoCount %> 个视频</span>
                </div>

                <div class="category-card" onclick="showCategory('weakspots')">
                    <div class="category-icon">🎯</div>
                    <h3 class="category-title">车辆弱点</h3>
                    <p class="category-desc">精准定位各系载具的装甲弱点，提升击穿效率</p>
                    <span class="category-count"><%= weakspotsArticleCount %> 篇文章 · <%= weakspotsVideoCount %> 个视频</span>
                </div>
            </div>

            <!-- 默认显示全部内容 -->
            <div id="all-section" class="section-content">
                <%
                    ArrayList<VideoModel> allVideos = null;
                    ArrayList<TutorialArticleModel> allArticles = null;
                    try {
                        allVideos = us.findAllVideos();
                        allArticles = us.findAllTutorialArticles();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                
                <!-- 视频区域 -->
                <% if (allVideos != null && !allVideos.isEmpty()) { %>
                <div class="video-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
                        <h2 class="section-title">🎬 视频教程</h2>
                        <a href="adminVideos.jsp" style="padding:8px 16px;background:#fb7299;color:#fff;border-radius:4px;text-decoration:none;font-size:14px;">发布视频</a>
                    </div>
                    <div class="video-grid">
                        <% for (VideoModel video : allVideos) { %>
                        <div class="video-compact" onclick="playVideo('<%= video.getBvid() %>')">
                            <div class="video-compact-thumb">
                                <img 
                                    src="<%= getThumbnailUrl(video) %>" 
                                    alt="视频缩略图"
                                    onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';">
                            </div>
                            <div class="video-compact-info">
                                <div class="video-compact-title">
                                    <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                                    <%= video.getTitle() %>
                                </div>
                                <div class="video-compact-meta"><%= formatViewCount(video.getViewCount()) %>播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- 文章区域 -->
                <% if (allArticles != null && !allArticles.isEmpty()) { %>
                <div class="article-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;">
                        <h2 class="section-title">📖 教程文章</h2>
                        <a href="publishTutorialArticle.jsp" style="padding:8px 16px;background:#00e0d0;color:#000;border-radius:4px;text-decoration:none;font-size:14px;">发布文章</a>
                    </div>
                    <div class="article-list">
                        <% for (TutorialArticleModel article : allArticles) { %>
                        <div class="article-card">
                            <% if (article.getImage1() != null) { %>
                            <img src="<%= article.getImage1() %>" class="article-thumbnail" alt="文章缩略图" onerror="this.style.display='none'">
                            <% } else { %>
                            <div class="article-thumbnail-placeholder"><%= article.getCategoryIcon() %></div>
                            <% } %>
                            <div class="article-content">
                                <a href="tutorialArticleDetail?id=<%= article.getId() %>" class="article-title"><%= article.getTitle() %></a>
                                <div class="article-meta">
                                    <span>👤 <%= article.getUsername() != null ? article.getUsername() : "未知" %></span>
                                    <span>👁️ <%= article.getViewCount() %></span>
                                    <span>📅 <%= article.getCreateTime() != null ? article.getCreateTime().substring(0, 10) : "" %></span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <% if ((allVideos == null || allVideos.isEmpty()) && (allArticles == null || allArticles.isEmpty())) { %>
                <div class="empty-state">
                    <p>暂无内容，快来发布第一篇教程吧！</p>
                </div>
                <% } %>
            </div>

            <!-- 地图解析区域 -->
            <div id="maps-section" class="section-content" style="display:none;">
                <h2 class="section-title">🗺️ 地图解析</h2>
                
                <%
                    ArrayList<VideoModel> mapsVideos = null;
                    ArrayList<TutorialArticleModel> mapsArticles = null;
                    try {
                        mapsVideos = us.findTutorialVideosByCategory("maps");
                        mapsArticles = us.findTutorialArticlesByCategory("maps");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                
                <!-- 视频区域 -->
                <% if (mapsVideos != null && !mapsVideos.isEmpty()) { %>
                <div class="video-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <h3 style="color:#00e0d0;">视频教程</h3>
                        <a href="adminVideos.jsp" style="padding:6px 12px;background:#fb7299;color:#fff;border-radius:4px;text-decoration:none;font-size:12px;">发布视频</a>
                    </div>
                    <div class="video-grid">
                        <% for (VideoModel video : mapsVideos) { %>
                        <div class="video-compact" onclick="playVideo('<%= video.getBvid() %>')">
                            <div class="video-compact-thumb">
                                <img 
                                    src="<%= getThumbnailUrl(video) %>" 
                                    alt="视频缩略图"
                                    onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';">
                            </div>
                            <div class="video-compact-info">
                                <div class="video-compact-title">
                                    <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                                    <%= video.getTitle() %>
                                </div>
                                <div class="video-compact-meta"><%= formatViewCount(video.getViewCount()) %>播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- 文章区域 -->
                <% if (mapsArticles != null && !mapsArticles.isEmpty()) { %>
                <div class="article-section">
                    <h3 style="color:#00e0d0;margin-bottom:16px;">教程文章</h3>
                    <div class="article-list">
                        <% for (TutorialArticleModel article : mapsArticles) { %>
                        <div class="article-card">
                            <% if (article.getImage1() != null) { %>
                            <img src="<%= article.getImage1() %>" class="article-thumbnail" alt="文章缩略图" onerror="this.style.display='none'">
                            <% } else { %>
                            <div class="article-thumbnail-placeholder">🗺️</div>
                            <% } %>
                            <div class="article-content">
                                <a href="tutorialArticleDetail?id=<%= article.getId() %>" class="article-title"><%= article.getTitle() %></a>
                                <div class="article-meta">
                                    <span>👤 <%= article.getUsername() != null ? article.getUsername() : "未知" %></span>
                                    <span>👁️ <%= article.getViewCount() %></span>
                                    <span>📅 <%= article.getCreateTime() != null ? article.getCreateTime().substring(0, 10) : "" %></span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <% if ((mapsVideos == null || mapsVideos.isEmpty()) && (mapsArticles == null || mapsArticles.isEmpty())) { %>
                <div class="empty-state">
                    <p>暂无内容，快来发布第一篇教程吧！</p>
                </div>
                <% } %>
            </div>

            <!-- 载具测评区域 -->
            <div id="vehicles-section" class="section-content" style="display:none;">
                <h2 class="section-title">⚔️ 载具测评</h2>
                
                <%
                    ArrayList<VideoModel> vehiclesVideos = null;
                    ArrayList<TutorialArticleModel> vehiclesArticles = null;
                    try {
                        vehiclesVideos = us.findTutorialVideosByCategory("vehicles");
                        vehiclesArticles = us.findTutorialArticlesByCategory("vehicles");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                
                <!-- 视频区域 -->
                <% if (vehiclesVideos != null && !vehiclesVideos.isEmpty()) { %>
                <div class="video-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <h3 style="color:#00e0d0;">视频教程</h3>
                        <a href="adminVideos.jsp" style="padding:6px 12px;background:#fb7299;color:#fff;border-radius:4px;text-decoration:none;font-size:12px;">发布视频</a>
                    </div>
                    <div class="video-grid">
                        <% for (VideoModel video : vehiclesVideos) { %>
                        <div class="video-compact" onclick="playVideo('<%= video.getBvid() %>')">
                            <div class="video-compact-thumb">
                                <img 
                                    src="<%= getThumbnailUrl(video) %>" 
                                    alt="视频缩略图"
                                    onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';">
                            </div>
                            <div class="video-compact-info">
                                <div class="video-compact-title">
                                    <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                                    <%= video.getTitle() %>
                                </div>
                                <div class="video-compact-meta"><%= formatViewCount(video.getViewCount()) %>播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- 文章区域 -->
                <% if (vehiclesArticles != null && !vehiclesArticles.isEmpty()) { %>
                <div class="article-section">
                    <h3 style="color:#00e0d0;margin-bottom:16px;">教程文章</h3>
                    <div class="article-list">
                        <% for (TutorialArticleModel article : vehiclesArticles) { %>
                        <div class="article-card">
                            <% if (article.getImage1() != null) { %>
                            <img src="<%= article.getImage1() %>" class="article-thumbnail" alt="文章缩略图" onerror="this.style.display='none'">
                            <% } else { %>
                            <div class="article-thumbnail-placeholder">⚔️</div>
                            <% } %>
                            <div class="article-content">
                                <a href="tutorialArticleDetail?id=<%= article.getId() %>" class="article-title"><%= article.getTitle() %></a>
                                <div class="article-meta">
                                    <span>👤 <%= article.getUsername() != null ? article.getUsername() : "未知" %></span>
                                    <span>👁️ <%= article.getViewCount() %></span>
                                    <span>📅 <%= article.getCreateTime() != null ? article.getCreateTime().substring(0, 10) : "" %></span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <% if ((vehiclesVideos == null || vehiclesVideos.isEmpty()) && (vehiclesArticles == null || vehiclesArticles.isEmpty())) { %>
                <div class="empty-state">
                    <p>暂无内容，快来发布第一篇教程吧！</p>
                </div>
                <% } %>
            </div>

            <!-- 车辆弱点区域 -->
            <div id="weakspots-section" class="section-content" style="display:none;">
                <h2 class="section-title">🎯 车辆弱点分析</h2>
                
                <%
                    ArrayList<VideoModel> weakspotsVideos = null;
                    ArrayList<TutorialArticleModel> weakspotsArticles = null;
                    try {
                        weakspotsVideos = us.findTutorialVideosByCategory("weakspots");
                        weakspotsArticles = us.findTutorialArticlesByCategory("weakspots");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                
                <!-- 视频区域 -->
                <% if (weakspotsVideos != null && !weakspotsVideos.isEmpty()) { %>
                <div class="video-section">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                        <h3 style="color:#00e0d0;">视频教程</h3>
                        <a href="adminVideos.jsp" style="padding:6px 12px;background:#fb7299;color:#fff;border-radius:4px;text-decoration:none;font-size:12px;">发布视频</a>
                    </div>
                    <div class="video-grid">
                        <% for (VideoModel video : weakspotsVideos) { %>
                        <div class="video-compact" onclick="playVideo('<%= video.getBvid() %>')">
                            <div class="video-compact-thumb">
                                <img 
                                    src="<%= getThumbnailUrl(video) %>" 
                                    alt="视频缩略图"
                                    onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';">
                            </div>
                            <div class="video-compact-info">
                                <div class="video-compact-title">
                                    <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                                    <%= video.getTitle() %>
                                </div>
                                <div class="video-compact-meta"><%= formatViewCount(video.getViewCount()) %>播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %></div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <!-- 文章区域 -->
                <% if (weakspotsArticles != null && !weakspotsArticles.isEmpty()) { %>
                <div class="article-section">
                    <h3 style="color:#00e0d0;margin-bottom:16px;">教程文章</h3>
                    <div class="article-list">
                        <% for (TutorialArticleModel article : weakspotsArticles) { %>
                        <div class="article-card">
                            <% if (article.getImage1() != null) { %>
                            <img src="<%= article.getImage1() %>" class="article-thumbnail" alt="文章缩略图" onerror="this.style.display='none'">
                            <% } else { %>
                            <div class="article-thumbnail-placeholder">🎯</div>
                            <% } %>
                            <div class="article-content">
                                <a href="tutorialArticleDetail?id=<%= article.getId() %>" class="article-title"><%= article.getTitle() %></a>
                                <div class="article-meta">
                                    <span>👤 <%= article.getUsername() != null ? article.getUsername() : "未知" %></span>
                                    <span>👁️ <%= article.getViewCount() %></span>
                                    <span>📅 <%= article.getCreateTime() != null ? article.getCreateTime().substring(0, 10) : "" %></span>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
                
                <% if ((weakspotsVideos == null || weakspotsVideos.isEmpty()) && (weakspotsArticles == null || weakspotsArticles.isEmpty())) { %>
                <div class="empty-state">
                    <p>暂无内容，快来发布第一篇教程吧！</p>
                </div>
                <% } %>
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
