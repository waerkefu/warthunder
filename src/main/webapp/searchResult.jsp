<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>搜索结果 - War Thunder 社区</title>
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

        .search-bar {
            flex: 1;
            max-width: 500px;
            display: flex;
            gap: 8px;
        }

        .search-input {
            flex: 1;
            padding: 10px 16px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
        }

        .search-input:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .btn-search {
            padding: 10px 20px;
            background-color: #00e0d0;
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-search:hover {
            background-color: #00c2b3;
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

        .search-header {
            margin-bottom: 24px;
        }

        .search-title {
            font-size: 20px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 8px;
        }

        .search-count {
            color: #8892a5;
            font-size: 14px;
        }

        .search-keyword {
            color: #00e0d0;
        }

        .post-list {
            background-color: #1e232a;
            border-radius: 8px;
            overflow: hidden;
        }

        .post-item {
            padding: 16px;
            border-bottom: 1px solid #2d333b;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .post-item:last-child {
            border-bottom: none;
        }

        .post-title {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
        }

        .post-title:hover {
            color: #00e0d0;
        }

        .post-preview {
            color: #8892a5;
            font-size: 14px;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .post-images-preview {
            display: flex;
            gap: 8px;
            max-width: 100%;
        }

        .preview-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }

        .post-meta {
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

        .error-message {
            color: #d9232e;
            padding: 12px;
            background-color: rgba(217, 35, 46, 0.1);
            border-radius: 4px;
            margin-bottom: 24px;
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
            <li><a href="tutorial.jsp">教程</a></li>
            <li><a href="https://statshark.net" target="_blank">战绩查询</a></li>
            <li><a href="https://warthunder.com/" target="_blank">官网</a></li>
            <li><a href="profile">个人中心</a></li>
        </ul>
    </aside>

    <div class="main-content">
        <div class="top-nav">
            <div class="search-bar">
                <form action="search" method="get">
                    <input type="text" class="search-input" name="keyword" placeholder="搜索帖子..." value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                    <button type="submit" class="btn-search">搜索</button>
                </form>
            </div>
            <div class="nav-actions">
                <button class="btn-secondary" onclick="location.href='index.jsp'">返回首页</button>
            </div>
        </div>

        <div class="content-area">
            <% if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <div class="search-header">
                <h2 class="search-title">搜索结果</h2>
                <p class="search-count">找到 <span class="search-keyword"><%= request.getAttribute("resultCount") %></span> 条关于 "<span class="search-keyword"><%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %></span>" 的结果</p>
            </div>

            <div class="post-list">
                <%
                    ArrayList<PostModel> posts = (ArrayList<PostModel>) request.getAttribute("posts");
                    if (posts != null && !posts.isEmpty()) {
                        for (PostModel post : posts) {
                %>
                <div class="post-item">
                    <a href="postDetail?articleId=<%= post.getId() %>" class="post-title"><%= post.getTitle() %></a>
                    <p class="post-preview"><%= post.getContent() != null && post.getContent().length() > 150 ? post.getContent().substring(0, 150) + "..." : (post.getContent() != null ? post.getContent() : "") %></p>
                    <% if (post.getImage1() != null || post.getImage2() != null || post.getImage3() != null) { %>
                    <div class="post-images-preview">
                        <% if (post.getImage1() != null) { %><img src="<%= post.getImage1() %>" class="preview-image" alt="图片1"><% } %>
                        <% if (post.getImage2() != null) { %><img src="<%= post.getImage2() %>" class="preview-image" alt="图片2"><% } %>
                        <% if (post.getImage3() != null) { %><img src="<%= post.getImage3() %>" class="preview-image" alt="图片3"><% } %>
                    </div>
                    <% } %>
                    <div class="post-meta">
                        <span>作者: <%= post.getUsername() %></span>
                        <span>发布时间: <%= post.getCreate_time() != null ? post.getCreate_time().substring(0, 10) : "" %></span>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state">
                    <p>没有找到相关帖子</p>
                    <p style="margin-top: 8px;">试试其他关键词吧</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>