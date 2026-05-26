<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑帖子 - War Thunder 社区</title>
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

        .btn-secondary {
            background-color: #3a4252;
            color: #fff;
        }

        .btn-secondary:hover {
            background-color: #4a5568;
        }

        .btn-primary {
            background-color: #00e0d0;
            color: #000;
        }

        .btn-primary:hover {
            background-color: #00c2b3;
        }

        .btn-danger {
            background-color: #d9232e;
            color: #fff;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .edit-card {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 32px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .edit-title {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 1px solid #2d333b;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #8892a5;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 16px;
        }

        .form-control:focus {
            outline: none;
            border-color: #00e0d0;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 200px;
            font-family: inherit;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .error-message {
            color: #d9232e;
            margin-bottom: 16px;
            padding: 12px;
            background-color: rgba(217, 35, 46, 0.1);
            border-radius: 4px;
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
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
    </div>
</nav>

<div class="container">
    <div class="edit-card">
        <h2 class="edit-title">编辑帖子</h2>
        
        <%
            String loginUser = (String) session.getAttribute("loginUser");
            if (loginUser == null) {
        %>
        <script>
            alert("请先登录！");
            location.href = "Login.jsp";
        </script>
        <%
                return;
            }
            
            String articleId = request.getParameter("articleId");
            if (articleId == null || articleId.isEmpty()) {
        %>
        <div class="error-message">参数错误，未指定帖子ID</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                return;
            }
            
            PostModel post = null;
            try {
                user_service us = new user_service();
                post = us.findPostById(Integer.parseInt(articleId));
                
                if (post == null || post.getId() == 0) {
        %>
        <div class="error-message">帖子不存在</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                    return;
                }
                
                if (!post.getUsername().equals(loginUser)) {
        %>
        <div class="error-message">您只能编辑自己的帖子</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                    return;
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
        <div class="error-message">数据库错误</div>
        <%
                return;
            }
        %>
        
        <form action="editPost" method="post">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            
            <div class="form-group">
                <label for="title">帖子标题</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= post.getTitle() %>" required>
            </div>

            <div class="form-group">
                <label for="content">帖子内容</label>
                <textarea class="form-control" id="content" name="content" required><%= post.getContent() %></textarea>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" style="flex: 1;">保存修改</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='profile'">取消</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>