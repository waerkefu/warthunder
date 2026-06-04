<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>帖子管理 - War Thunder 社区</title>
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
            width: 250px;
            background-color: #1e232a;
            padding: 24px;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            border-right: 1px solid #2d333b;
        }

        .sidebar-logo {
            font-size: 20px;
            font-weight: bold;
            color: #00e0d0;
            margin-bottom: 32px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .sidebar-nav {
            list-style: none;
        }

        .sidebar-nav li {
            margin-bottom: 4px;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #b0b8c1;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background-color: #252a32;
            color: #00e0d0;
        }

        .sidebar-nav a i {
            margin-right: 10px;
            font-size: 16px;
        }

        .sidebar-divider {
            height: 1px;
            background-color: #2d333b;
            margin: 16px 0;
        }

        .sidebar-footer {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #2d333b;
        }

        .sidebar-footer p {
            color: #6b7280;
            font-size: 12px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 32px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .header-left h1 {
            color: #fff;
            font-size: 24px;
        }

        .header-left p {
            color: #8892a5;
            font-size: 14px;
            margin-top: 4px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 16px;
            background-color: #1e232a;
            border-radius: 8px;
        }

        .user-info span {
            color: #b0b8c1;
            font-size: 14px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #3a4252;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }

        .btn-logout {
            padding: 8px 16px;
            background-color: #d9232e;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn-logout:hover {
            background-color: #c11f29;
        }

        .btn-back {
            padding: 8px 16px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .btn-back:hover {
            background-color: #4a5568;
        }

        .search-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 24px;
        }

        .search-bar input {
            flex: 1;
            padding: 10px 16px;
            background-color: #1e232a;
            border: 1px solid #2d333b;
            border-radius: 6px;
            color: #fff;
            font-size: 14px;
        }

        .search-bar input:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .btn-search {
            padding: 10px 24px;
            background-color: #00e0d0;
            color: #181b21;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-search:hover {
            background-color: #00b8a3;
        }

        .posts-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #1e232a;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #2d333b;
        }

        .posts-table th,
        .posts-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #2d333b;
        }

        .posts-table th {
            background-color: #252a32;
            color: #8892a5;
            font-weight: 500;
            font-size: 14px;
        }

        .posts-table tr:hover {
            background-color: #252a32;
        }

        .posts-table .title {
            color: #fff;
            font-size: 14px;
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            cursor: pointer;
            transition: color 0.3s;
        }

        .posts-table .title:hover {
            color: #00e0d0;
        }

        .posts-table .author {
            color: #8892a5;
            font-size: 13px;
        }

        .posts-table .date {
            color: #6b7280;
            font-size: 12px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-active {
            background-color: #4caf50;
            color: #fff;
        }

        .status-banned {
            background-color: #d9232e;
            color: #fff;
        }

        .actions {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
        }

        .btn-ban {
            background-color: #d9232e;
            color: #fff;
        }

        .btn-ban:hover {
            background-color: #c11f29;
        }

        .btn-unban {
            background-color: #4caf50;
            color: #fff;
        }

        .btn-unban:hover {
            background-color: #388e3c;
        }

        .btn-delete {
            background-color: #6b7280;
            color: #fff;
        }

        .btn-delete:hover {
            background-color: #4b5563;
        }

        .empty-state {
            text-align: center;
            padding: 48px;
            color: #6b7280;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            display: block;
        }

        .filter-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
        }

        .filter-tab {
            padding: 8px 16px;
            background-color: #1e232a;
            border: 1px solid #2d333b;
            border-radius: 4px;
            color: #8892a5;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .filter-tab.active,
        .filter-tab:hover {
            background-color: #00e0d0;
            color: #181b21;
            border-color: #00e0d0;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: relative;
            }

            .main-content {
                margin-left: 0;
            }

            .posts-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span>⚔️</span>
            <span>WT Admin</span>
        </div>
        
        <ul class="sidebar-nav">
            <li><a href="admin"><i>📊</i>仪表盘</a></li>
            <li><a href="admin?action=listUsers"><i>👥</i>用户管理</a></li>
            <li><a href="admin?action=listPosts" class="active"><i>📝</i>帖子管理</a></li>
            <li><a href="admin?action=listVideos"><i>🎬</i>视频管理</a></li>
        </ul>

        <div class="sidebar-divider"></div>

        <ul class="sidebar-nav">
            <li><a href="tutorial.jsp"><i>📚</i>教程中心</a></li>
            <li><a href="index.jsp"><i>🏠</i>返回首页</a></li>
        </ul>

        <div class="sidebar-footer">
            <p>War Thunder 社区管理系统</p>
            <p style="margin-top: 4px;">v1.0</p>
        </div>
    </aside>

    <main class="main-content">
        <div class="header">
            <div class="header-left">
                <h1>📝 帖子管理</h1>
                <p>管理和审核社区帖子内容</p>
            </div>
            <div class="header-right">
                <button class="btn-back" onclick="location.href='admin'">返回仪表盘</button>
                <div class="user-info">
                    <div class="user-avatar">👤</div>
                    <span><%= ((user_model)request.getSession().getAttribute("currentUser")) != null ? 
                        ((user_model)request.getSession().getAttribute("currentUser")).getUser_name() : "" %></span>
                </div>
                <button class="btn-logout" onclick="location.href='Login.jsp'">退出登录</button>
            </div>
        </div>

        <div class="filter-tabs">
            <button class="filter-tab active" onclick="filterPosts('all')">全部</button>
            <button class="filter-tab" onclick="filterPosts('active')">正常</button>
            <button class="filter-tab" onclick="filterPosts('banned')">已封禁</button>
        </div>

        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="搜索帖子标题或作者..." value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
            <button class="btn-search" onclick="searchPosts()">搜索</button>
        </div>

        <table class="posts-table">
            <thead>
                <tr>
                    <th>标题</th>
                    <th>作者</th>
                    <th>状态</th>
                    <th>创建时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        user_service us = new user_service();
                        ArrayList<PostModel> posts = (ArrayList<PostModel>) request.getAttribute("posts");
                        if (posts == null) {
                            posts = us.findAllPostsForAdmin();
                        }
                        if (posts != null && !posts.isEmpty()) {
                            for (PostModel post : posts) {
                %>
                <tr data-status="<%= post.getStatus() %>">
                    <td class="title" onclick="viewPost(<%= post.getId() %>)">
                        <%= post.getTitle() %>
                    </td>
                    <td class="author"><%= post.getUsername() %></td>
                    <td>
                        <span class="status-badge <%= post.getStatus() == 1 ? "status-active" : "status-banned" %>">
                            <%= post.getStatus() == 1 ? "正常" : "已封禁" %>
                        </span>
                    </td>
                    <td class="date"><%= post.getCreate_time() != null && post.getCreate_time().length() >= 10 ? post.getCreate_time().substring(0, 10) : "" %></td>
                    <td>
                        <div class="actions">
                            <% if (post.getStatus() == 1) { %>
                                <button class="btn-action btn-ban" onclick="banPost(<%= post.getId() %>)">封禁</button>
                            <% } else { %>
                                <button class="btn-action btn-unban" onclick="unbanPost(<%= post.getId() %>)">解禁</button>
                            <% } %>
                            <button class="btn-action btn-delete" onclick="deletePost(<%= post.getId() %>)">删除</button>
                        </div>
                    </td>
                </tr>
                <%
                            }
                        } else {
                %>
                <tr>
                    <td colspan="6">
                        <div class="empty-state">
                            <i>📭</i>
                            <p>暂无帖子</p>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                %>
                <tr>
                    <td colspan="6">
                        <div class="empty-state">
                            <i>❌</i>
                            <p>加载失败</p>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </main>

    <script>
        function viewPost(postId) {
            window.open('postDetail?articleId=' + postId, '_blank');
        }

        function banPost(postId) {
            if (confirm('确定要封禁这篇帖子吗？')) {
                fetch('admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=banPost&postId=' + postId
                }).then(function() {
                    location.reload();
                });
            }
        }

        function unbanPost(postId) {
            if (confirm('确定要解禁这篇帖子吗？')) {
                fetch('admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=unbanPost&postId=' + postId
                }).then(function() {
                    location.reload();
                });
            }
        }

        function deletePost(postId) {
            if (confirm('确定要删除这篇帖子吗？此操作不可恢复！')) {
                fetch('admin', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=deletePost&postId=' + postId
                }).then(function() {
                    location.reload();
                });
            }
        }

        function searchPosts() {
            var keyword = document.getElementById('searchInput').value.trim();
            if (keyword) {
                location.href = 'admin?action=searchPosts&keyword=' + encodeURIComponent(keyword);
            } else {
                location.href = 'admin?action=listPosts';
            }
        }

        function filterPosts(status) {
            var rows = document.querySelectorAll('.posts-table tbody tr');
            rows.forEach(function(row) {
                var rowStatus = row.getAttribute('data-status');
                if (status === 'all') {
                    row.style.display = '';
                } else if (status === 'active' && rowStatus === '1') {
                    row.style.display = '';
                } else if (status === 'banned' && rowStatus === '0') {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.querySelectorAll('.filter-tab').forEach(function(tab) {
                tab.classList.remove('active');
            });
            event.target.classList.add('active');
        }
    </script>
</body>
</html>