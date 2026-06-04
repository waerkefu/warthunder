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
    <title>War Thunder 社区</title>
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
            display: flex;
            min-height: 100vh;
        }

        /* 左侧导航栏 */
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

        .sidebar-logo img {
            height: 40px;
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

        .sidebar-menu li a::before {
            /* 用文字模拟图标，可替换为真实图标 */
            font-size: 18px;
            width: 24px;
            text-align: center;
        }

        .sidebar-menu li:nth-child(1) a::before { content: "💬"; }
        .sidebar-menu li:nth-child(2) a::before { content: "📖"; }
        .sidebar-menu li:nth-child(3) a::before { content: "📊"; }
        .sidebar-menu li:nth-child(4) a::before { content: "🌐"; }
        /* 个人中心图标 */
        .sidebar-menu li:nth-child(5) a::before { content: "👤"; }

        /* 主内容区 */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* 顶部导航 */
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
            margin-right: 24px;
        }

        .search-bar {
            flex: 1;
            max-width: 500px;
            display: flex;
            gap: 8px;
            margin-right: 24px;
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

        .top-nav .nav-actions {
            display: flex;
            gap: 16px;
            align-items: center;
        }

        .btn-login {
            padding: 8px 16px;
            background-color: #2196f3;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-game {
            padding: 8px 16px;
            background-color: #a72c2c;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-logout {
            padding: 8px 16px;
            background-color: #d9232e;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-publish {
            padding: 8px 16px;
            background-color: #00e0d0;
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-publish:hover {
            background-color: #00c2b3;
        }

        

        .publish-form {
            background-color: #1e232a;
            padding: 24px;
            margin-bottom: 24px;
            border-radius: 8px;
            display: none;
        }

        .publish-form.active {
            display: block;
        }

        .publish-form h3 {
            color: #fff;
            margin-bottom: 16px;
            font-size: 18px;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            color: #b0b8c1;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 12px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
            font-family: inherit;
        }

        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .image-upload-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 12px;
            margin-top: 12px;
        }

        .image-upload-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100px;
            border: 2px dashed #3a4252;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .image-upload-box:hover {
            border-color: #00e0d0;
            background-color: rgba(0, 224, 208, 0.05);
        }

        .image-upload-box input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .upload-icon {
            font-size: 24px;
            margin-bottom: 4px;
        }

        .image-upload-box span {
            font-size: 12px;
            color: #8892a5;
        }

        .image-upload-box.has-image {
            border-style: solid;
            border-color: #00e0d0;
        }

        .image-preview {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn-submit {
            padding: 10px 20px;
            background-color: #00e0d0;
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-cancel {
            padding: 10px 20px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .post-item.banned {
            opacity: 0.6;
        }

        .admin-menu-container {
            position: absolute;
            top: 50%;
            left: 8px;
            transform: translateY(-50%);
            z-index: 10;
        }

        .admin-menu-btn {
            width: 24px;
            height: 24px;
            background-color: transparent;
            border: none;
            color: #8892a5;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .admin-menu-btn:hover {
            background-color: #3a4252;
            color: #fff;
        }

        .admin-menu {
            position: absolute;
            top: 28px;
            left: 0;
            background-color: #252a32;
            border-radius: 4px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            min-width: 100px;
            display: none;
            border: 1px solid #3a4252;
        }

        .admin-menu.active {
            display: block;
        }

        .admin-menu a {
            display: block;
            padding: 8px 12px;
            color: #b0b8c1;
            text-decoration: none;
            font-size: 13px;
            transition: background-color 0.2s;
        }

        .admin-menu a:hover {
            background-color: #3a4252;
            color: #00e0d0;
        }

        .admin-menu a:last-child {
            color: #d9232e;
        }

        .admin-menu a:last-child:hover {
            color: #fff;
            background-color: #d9232e;
        }

        .btn-logout:hover {
            background-color: #c11f29;
        }

        /* 内容区域 */
        .content-area {
            padding: 24px;
        }

        /* 帖子列表样式（和你现有项目风格统一） */
        .post-list {
            background-color: #1e232a;
            border-radius: 8px;
            overflow: hidden;
        }

        .post-header {
            display: grid;
            grid-template-columns: 1fr 100px 60px 120px;
            padding: 12px 16px;
            background-color: #252a32;
            font-size: 14px;
            color: #8892a5;
        }

        .post-item {
            display: grid;
            grid-template-columns: 1fr 100px 60px 120px;
            padding: 16px 16px 16px 40px;
            border-bottom: 1px solid #2d333b;
            align-items: center;
            position: relative;
        }

        .post-title {
            color: #fff;
            text-decoration: none;
        }

        .post-title:hover {
            color: #00e0d0;
        }

        .post-meta {
            color: #8892a5;
            font-size: 14px;
            text-align: center;
        }

        .post-content-area {
            grid-column: 1;
        }

        .post-preview {
            color: #8892a5;
            font-size: 14px;
            margin-top: 8px;
            line-height: 1.5;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .post-images-preview {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            max-width: 100%;
        }

        .preview-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .preview-image:hover {
            transform: scale(1.05);
        }

        .post-meta-area {
            grid-column: 2 / span 3;
            display: flex;
            gap: 24px;
            align-items: center;
            justify-content: center;
        }

        .post-meta-author {
            color: #8892a5;
            font-size: 14px;
        }

        .post-meta-replies {
            color: #8892a5;
            font-size: 14px;
        }

        .post-meta-time {
            color: #8892a5;
            font-size: 14px;
        }

        .lightbox-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.9);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }

        .lightbox-overlay.active {
            display: flex;
        }

        .lightbox-content {
            max-width: 90%;
            max-height: 90%;
            object-fit: contain;
        }
    </style>
</head>
<body>
<!-- 左侧导航栏 -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <h2 style="color:#fff;">WAR THUNDER</h2>
    </div>
    <ul class="sidebar-menu">
        <li><a href="index.jsp" class="active">论坛</a></li>
        <li><a href="tutorial.jsp">教程</a></li>
        <li><a href="https://statshark.net" target="_blank">战绩查询</a></li>
        <li><a href="https://warthunder.com/" target="_blank">官网</a></li>
        <!-- 👇 这里就是新增的 个人中心 按钮 -->
        <li><a href="profile">个人中心</a></li>
    </ul>
</aside>

<!-- 主内容区 -->
<div class="main-content">
    <!-- 顶部导航 -->
    <div class="top-nav">
        <div class="nav-title">中文论坛</div>
        <div class="search-bar">
            <form action="search" method="get">
                <input type="text" class="search-input" name="keyword" placeholder="搜索帖子...">
                <button type="submit" class="btn-search">搜索</button>
            </form>
        </div>
        <div class="nav-actions">
            <%
                String loginUser = (String) session.getAttribute("loginUser");
                if (loginUser != null && !loginUser.isEmpty()) {
                    boolean isAdmin = false;
                    try {
                        user_service us = new user_service();
                        user_model user = us.findUserByUsername(loginUser);
                        isAdmin = user.isAdmin();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
            %>
            <span style="color: #00e0d0; margin-right: 12px;">欢迎, <%= loginUser %></span>
            <button class="btn-publish" onclick="togglePublishForm()">发布帖子</button>
            <% if (isAdmin) { %>
            <a href="admin" class="btn-publish" style="background-color: #4a9eff;">仪表盘</a>
            <a href="adminUsers.jsp" class="btn-publish" style="background-color: #d9232e;">用户管理</a>
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

    <!-- 发布帖子表单 -->
    <div class="publish-form" id="publishForm">
        <h3>发布新帖子</h3>
        <form action="publishPost" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="postTitle">帖子标题</label>
                <input type="text" id="postTitle" name="title" placeholder="请输入帖子标题" required>
            </div>
            <div class="form-group">
                <label for="postContent">帖子内容</label>
                <textarea id="postContent" name="content" placeholder="请输入帖子内容" required></textarea>
            </div>
            <div class="form-group">
                <label>上传图片（最多6张）</label>
                <div class="image-upload-container">
                    <label class="image-upload-box">
                        <input type="file" name="image1" accept="image/*" onchange="previewImage(this, 1)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片1</span>
                    </label>
                    <label class="image-upload-box">
                        <input type="file" name="image2" accept="image/*" onchange="previewImage(this, 2)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片2</span>
                    </label>
                    <label class="image-upload-box">
                        <input type="file" name="image3" accept="image/*" onchange="previewImage(this, 3)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片3</span>
                    </label>
                    <label class="image-upload-box">
                        <input type="file" name="image4" accept="image/*" onchange="previewImage(this, 4)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片4</span>
                    </label>
                    <label class="image-upload-box">
                        <input type="file" name="image5" accept="image/*" onchange="previewImage(this, 5)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片5</span>
                    </label>
                    <label class="image-upload-box">
                        <input type="file" name="image6" accept="image/*" onchange="previewImage(this, 6)">
                        <div class="upload-icon">📷</div>
                        <span>选择图片6</span>
                    </label>
                </div>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="togglePublishForm()">取消</button>
                <button type="submit" class="btn-submit">发布</button>
            </div>
        </form>
    </div>

    <!-- 帖子列表 -->
    <div class="content-area">
        <div class="post-list">
            <div class="post-header">
                <span>主题</span>
                <span>作者</span>
                <span>回复</span>
                <span>发布时间</span>
            </div>
            <%
                boolean isAdmin = false;
                boolean isModerator = false;
                String loginUsername = (String) session.getAttribute("loginUser");
                if (loginUsername != null) {
                    try {
                        user_service us = new user_service();
                        user_model user = us.findUserByUsername(loginUsername);
                        isAdmin = user.isAdmin();
                        isModerator = user.isModerator();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                
                ArrayList<PostModel> posts = null;
                try {
                    user_service us = new user_service();
                    posts = isAdmin ? us.findAllPostsForAdmin() : us.findAllPosts();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                
                if (posts != null && !posts.isEmpty()) {
                    for (PostModel post : posts) {
                        boolean isBanned = post.getStatus() == 0;
            %>
            <div class="post-item <%= isBanned ? "banned" : "" %>">
                <% if (isAdmin || isModerator) { %>
                <div class="admin-menu-container">
                    <button type="button" class="admin-menu-btn" data-menu-id="menu-<%= post.getId() %>">⋮</button>
                    <div class="admin-menu" id="menu-<%= post.getId() %>">
                        <% if (isAdmin) { %>
                            <% if (isBanned) { %>
                            <a href="javascript:void(0);" onclick="adminAction('确定要解封这篇帖子吗？', 'admin?action=unban&postId=<%= post.getId() %>', <%= post.getId() %>, true)">解封</a>
                            <% } else { %>
                            <a href="javascript:void(0);" onclick="adminAction('确定要封禁这篇帖子吗？封禁后普通用户将无法看到', 'admin?action=ban&postId=<%= post.getId() %>', <%= post.getId() %>, false)">封禁</a>
                            <% } %>
                        <% } %>
                        <a href="javascript:void(0);" onclick="confirmAction('确定要删除这篇帖子吗？此操作不可恢复', 'deletePost?articleId=<%= post.getId() %>')">删除</a>
                    </div>
                </div>
                <% } %>
                <div class="post-content-area">
                    <a href="postDetail?articleId=<%= post.getId() %>" class="post-title">
                        <%= isBanned ? "[已封禁] " : "" %><%= post.getTitle() %>
                    </a>
                    <p class="post-preview"><%= post.getContent() != null && post.getContent().length() > 100 ? post.getContent().substring(0, 100) + "..." : (post.getContent() != null ? post.getContent() : "") %></p>
                    <% if (post.getImage1() != null || post.getImage2() != null || post.getImage3() != null) { %>
                    <div class="post-images-preview">
                        <% if (post.getImage1() != null) { %><img src="<%= post.getImage1() %>" class="preview-image" alt="图片1" onclick="openLightbox('<%= post.getImage1() %>')"><% } %>
                        <% if (post.getImage2() != null) { %><img src="<%= post.getImage2() %>" class="preview-image" alt="图片2" onclick="openLightbox('<%= post.getImage2() %>')"><% } %>
                        <% if (post.getImage3() != null) { %><img src="<%= post.getImage3() %>" class="preview-image" alt="图片3" onclick="openLightbox('<%= post.getImage3() %>')"><% } %>
                    </div>
                    <% } %>
                </div>
                <div class="post-meta-area">
                    <span class="post-meta-author"><%= post.getUsername() %></span>
                    <span class="post-meta-replies">0 回复</span>
                    <span class="post-meta-time"><%= post.getCreate_time() != null ? post.getCreate_time().substring(0, 10) : "" %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="post-item" style="grid-column: span 4; text-align: center; color: #8892a5;">
                暂无帖子，快来发布第一篇吧！
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

    <div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightbox()">
        <img src="" id="lightboxContent" class="lightbox-content" onclick="event.stopPropagation()">
    </div>
<script>
    function togglePublishForm() {
        var form = document.getElementById('publishForm');
        form.classList.toggle('active');
    }

    function openLightbox(imageUrl) {
        var overlay = document.getElementById('lightboxOverlay');
        var content = document.getElementById('lightboxContent');
        content.src = imageUrl;
        overlay.classList.add('active');
    }

    function closeLightbox() {
        var overlay = document.getElementById('lightboxOverlay');
        overlay.classList.remove('active');
    }

    function confirmAction(message, url) {
        if (confirm(message)) {
            location.href = url;
        }
    }

    function adminAction(message, url, postId, isBanned) {
        if (confirm(message)) {
            fetch(url)
                .then(response => response.json ? response.json() : response.text())
                .then(data => {
                    alert(isBanned ? '帖子已解封！' : '帖子已封禁！');
                    // 更新UI，不刷新页面
                    const menu = document.getElementById('menu-' + postId);
                    const postTitle = document.querySelector(`a[href="postDetail?articleId=${postId}"]`);
                    if (isBanned) {
                        // 解封：切换到封禁链接
                        menu.innerHTML = `
                            <a href="javascript:void(0);" onclick="adminAction('确定要封禁这篇帖子吗？封禁后普通用户将无法看到', 'admin?action=ban&postId=${postId}', ${postId}, false)">封禁</a>
                            <a href="javascript:void(0);" onclick="confirmAction('确定要删除这篇帖子吗？此操作不可恢复', 'deletePost?articleId=${postId}')">删除</a>
                        `;
                        if (postTitle) {
                            postTitle.innerHTML = postTitle.textContent.replace('[已封禁] ', '');
                        }
                    } else {
                        // 封禁：切换到解封链接
                        menu.innerHTML = `
                            <a href="javascript:void(0);" onclick="adminAction('确定要解封这篇帖子吗？', 'admin?action=unban&postId=${postId}', ${postId}, true)">解封</a>
                            <a href="javascript:void(0);" onclick="confirmAction('确定要删除这篇帖子吗？此操作不可恢复', 'deletePost?articleId=${postId}')">删除</a>
                        `;
                        if (postTitle) {
                            postTitle.innerHTML = '[已封禁] ' + postTitle.textContent;
                        }
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('操作失败，请重试');
                });
        }
    }

    function previewImage(input, index) {
        var label = input.parentElement;
        var files = input.files;
        if (files.length > 0) {
            var file = files[0];
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'image-preview';
                label.classList.add('has-image');
                
                var existingPreview = label.querySelector('.image-preview');
                if (existingPreview) {
                    label.removeChild(existingPreview);
                }
                label.appendChild(img);
            };
            reader.readAsDataURL(file);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.addEventListener('click', function(event) {
            var target = event.target;
            
            if (target.classList.contains('admin-menu-btn')) {
                event.stopPropagation();
                var menuId = target.getAttribute('data-menu-id');
                var menu = document.getElementById(menuId);
                
                document.querySelectorAll('.admin-menu').forEach(function(m) {
                    if (m !== menu) {
                        m.classList.remove('active');
                    }
                });
                
                menu.classList.toggle('active');
            } else if (!target.closest('.admin-menu')) {
                document.querySelectorAll('.admin-menu').forEach(function(menu) {
                    menu.classList.remove('active');
                });
            }
        });
    });
</script>
</body>
</html>