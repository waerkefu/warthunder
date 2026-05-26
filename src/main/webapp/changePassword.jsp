<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改密码 - War Thunder 社区</title>
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

        .form-hint {
            font-size: 12px;
            color: #8892a5;
            margin-top: 4px;
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
        <h2 class="edit-title">修改密码</h2>
        <form action="profile?action=updatePassword" method="post">
            <div class="form-group">
                <label for="oldPassword">旧密码</label>
                <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="请输入当前密码" required>
            </div>

            <div class="form-group">
                <label for="newPassword">新密码</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="请输入新密码" required>
                <div class="form-hint">密码长度至少为6位</div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">确认密码</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="请再次输入新密码" required>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" style="flex: 1;">修改密码</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='profile'">取消</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>