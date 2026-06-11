<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user_model" %>
<%@ page import="model.PostModel" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - War Thunder 社区</title>
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
        }

        .navbar {
            background-color: #1e232a;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #2d333b;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-logo h2 {
            color: #fff;
            font-size: 20px;
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .navbar-user span {
            color: #00e0d0;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }

        .btn-logout {
            background-color: #d9232e;
            color: #fff;
        }

        .btn-primary {
            background-color: #00e0d0;
            color: #000;
        }

        .btn-secondary {
            background-color: #3a4252;
            color: #fff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 24px;
        }

        .profile-card {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 24px;
        }

        .avatar-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 16px;
        }

        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #00e0d0, #00c2b3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            object-fit: cover;
        }

        .username {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 8px;
        }

        .email {
            color: #8892a5;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        .role-admin {
            background-color: #d9232e;
            color: #fff;
        }

        .role-moderator {
            background-color: #2196f3;
            color: #fff;
        }

        .role-user {
            background-color: #3a4252;
            color: #00e0d0;
        }

        .stats-section {
            display: flex;
            justify-content: space-around;
            padding: 16px 0;
            border-top: 1px solid #2d333b;
            border-bottom: 1px solid #2d333b;
            margin-bottom: 24px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #00e0d0;
        }

        .stat-label {
            font-size: 12px;
            color: #8892a5;
            margin-top: 4px;
        }

        .menu-section {
            list-style: none;
        }

        .menu-item {
            margin-bottom: 8px;
        }

        .menu-item a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            color: #b0b8c1;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.2s;
        }

        .menu-item a:hover,
        .menu-item a.active {
            background-color: #2d333b;
            color: #00e0d0;
        }

        .content-area {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .content-title {
            font-size: 20px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid #2d333b;
        }

        .post-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .post-card {
            background-color: #252a32;
            border-radius: 6px;
            padding: 16px;
            transition: transform 0.2s;
        }

        .post-card:hover {
            transform: translateX(4px);
        }

        .post-title {
            font-size: 16px;
            font-weight: 500;
            color: #fff;
            text-decoration: none;
            margin-bottom: 8px;
            display: block;
        }

        .post-title:hover {
            color: #00e0d0;
        }

        .post-content {
            color: #b0b8c1;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .post-meta {
            display: flex;
            gap: 16px;
            font-size: 12px;
            color: #8892a5;
        }

        .post-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .btn-edit {
            background-color: #3a4252;
            color: #fff;
            padding: 4px 12px;
            font-size: 12px;
        }

        .btn-delete {
            background-color: #d9232e;
            color: #fff;
            padding: 4px 12px;
            font-size: 12px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #8892a5;
        }

        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-logo">
        <h2>War Thunder 社区</h2>
    </div>
    <div class="navbar-user">
        <span>欢迎, <%= session.getAttribute("loginUser") %></span>
        <button class="btn btn-secondary" onclick="location.href='index.jsp'">返回首页</button>
        <button class="btn btn-logout" onclick="location.href='Login.jsp'">退出登录</button>
    </div>
</nav>

<div class="container">
    <aside class="profile-card">
        <div class="avatar-section">
            <div class="avatar-container">
                <%
                    user_model user = (user_model) request.getAttribute("user");
                    if (user != null && user.hasAvatar()) {
                %>
                <img src="<%= user.getAvatar() %>" class="avatar" alt="头像">
                <%
                    } else {
                %>
                <div class="avatar">
                    <%= user != null && user.getUser_name() != null && !user.getUser_name().isEmpty() ? user.getUser_name().charAt(0) : "?" %>
                </div>
                <%
                    }
                %>
            </div>
            <div class="username">
                <%= user != null ? user.getUser_name() : "未知用户" %>
            </div>
            <div class="email">
                <%= user != null ? user.getEmail() : "" %>
            </div>
            <% if (user != null) { %>
            <span class="role-badge <%= user.isAdmin() ? "role-admin" : (user.isModerator() ? "role-moderator" : "role-user") %>">
                <%= user.isAdmin() ? "管理员" : (user.isModerator() ? "小管理" : "普通用户") %>
            </span>
            <% } %>
        </div>

        <div class="stats-section">
            <div class="stat-item">
                <div class="stat-value"><%= request.getAttribute("postCount") %></div>
                <div class="stat-label">帖子</div>
            </div>
        </div>

        <ul class="menu-section">
            <li class="menu-item"><a href="profile?action=view" class="active">🏠 我的主页</a></li>
            <li class="menu-item"><a href="profile?action=edit">✏️ 编辑资料</a></li>
            <li class="menu-item"><a href="profile?action=changePassword">🔒 修改密码</a></li>
            <li class="menu-item"><a href="index.jsp">📝 发布帖子</a></li>
            <% if (user != null && (user.isAdmin() || user.isModerator())) { %>
            <li class="menu-item"><a href="review">✅ 内容审核</a></li>
            <% } %>
        </ul>
    </aside>

    <main class="content-area">
        <h2 class="content-title">我的帖子</h2>
        <div class="post-list">
            <%
                ArrayList<PostModel> posts = (ArrayList<PostModel>) request.getAttribute("posts");
                if (posts != null && !posts.isEmpty()) {
                    for (PostModel post : posts) {
            %>
            <div class="post-card">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                    <a href="postDetail?articleId=<%= post.getId() %>" class="post-title"><%= post.getTitle() %></a>
                    <% if (post.getReviewStatus() == 0) { %>
                    <span style="background-color: #ff9800; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 12px;">待审核</span>
                    <% } else if (post.getReviewStatus() == 2) { %>
                    <span style="background-color: #d9232e; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 12px;">不通过</span>
                    <% } else { %>
                    <span style="background-color: #4caf50; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 12px;">已通过</span>
                    <% } %>
                </div>
                <div class="post-content"><%= post.getContent() %></div>
                <div class="post-meta">
                    <span>发布于: <%= post.getCreate_time() %></span>
                    <% if (post.getReviewStatus() == 2 && post.getReviewMessage() != null && !post.getReviewMessage().isEmpty()) { %>
                    <span style="display: block; color: #d9232e; margin-top: 4px;">驳回原因: <%= post.getReviewMessage() %></span>
                    <% } %>
                </div>
                <div class="post-actions">
                    <button class="btn btn-edit" onclick="editPost(<%= post.getId() %>)">编辑</button>
                    <button class="btn btn-delete" onclick="deletePost(<%= post.getId() %>)">删除</button>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">
                <p>暂无帖子，快去发布第一篇吧！</p>
                <button class="btn btn-primary" style="margin-top: 16px;" onclick="location.href='index.jsp'">发布帖子</button>
            </div>
            <%
                }
            %>
        </div>
    </main>
</div>

<script>
    function editPost(postId) {
        location.href = "editPost?articleId=" + postId;
    }

    function deletePost(postId) {
        if (confirm("确定要删除这篇帖子吗？")) {
            location.href = "deletePost?articleId=" + postId;
        }
    }
</script>
</body>
</html>