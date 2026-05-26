<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user_model" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑资料 - War Thunder 社区</title>
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

        .container {
            max-width: 600px;
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

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
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
        <h2 class="edit-title">编辑资料</h2>
        <%
            user_model user = (user_model) request.getAttribute("user");
            if (user == null) {
        %>
        <script>
            alert("用户信息获取失败！");
            location.href = "profile";
        </script>
        <%
                return;
            }
        %>
        <form action="profile?action=update" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" class="form-control" id="username" name="username" value="<%= user.getUser_name() %>" required>
            </div>

            <div class="form-group">
                <label for="email">邮箱地址</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
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