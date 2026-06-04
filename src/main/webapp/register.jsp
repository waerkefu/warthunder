<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登记户口 - Gaijin.Net</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", sans-serif;
        }

        body {
            background-color: #2a303c;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #fff;
            padding: 60px 20px 0;
        }

        /* Logo 区域 */
        .logo {
            margin-bottom: 40px;
            text-align: center;
        }
        .logo img {
            height: 60px;
            /* 这里保持你原来的图片路径 */
            content: url("./static/images/gaijin.png");
        }

        /* 注册容器 */
        .register-container {
            width: 100%;
            max-width: 500px;
        }

        .register-title {
            font-size: 28px;
            font-weight: 500;
            margin-bottom: 24px;
            color: #fff;
        }

        /* 输入框组 */
        .form-group {
            margin-bottom: 16px;
            position: relative; /* 作为绝对定位容器 */
        }

        .form-row {
            display: flex;
            gap: 12px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* 核心修改：输入框样式 */
        .form-control {
            width: 100%;
            /* 关键：左内边距增大，给左侧图标腾出 40px 宽度 */
            padding: 14px 16px 14px 40px;
            background-color: #1e232c;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #00e0d0;
        }

        /* 核心修改：密码框图标定位 */
        .password-icon {
            position: absolute;
            left: 14px; /* 距离左边框 14px */
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            color: #8892a5; /* 图标颜色 */
            pointer-events: none; /* 允许点击穿透，不影响输入框聚焦 */
        }

        /* 引入 SVG 图标 */
        .icon-user { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%238892a5'%3E%3Cpath d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z'/%3E%3C/svg%3E"); }
        .icon-lock { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%238892a5'%3E%3Cpath d='M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-.61.54-1.13 1.14-1.13h3.92c.6 0 1.1.52 1.1 1.13v2z'/%3E%3C/svg%3E"); }

        /* 提示文字 */
        .form-hint {
            font-size: 12px;
            color: #00e0d0;
            margin-top: 4px;
            padding-left: 4px;
        }

        /* 同意条款 */
        .agree-term {
            display: flex;
            align-items: center;
            margin: 20px 0;
            font-size: 14px;
            color: #ccc;
        }
        .agree-term input {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            accent-color: #00e0d0;
        }
        .agree-term a {
            color: #00e0d0;
            text-decoration: none;
        }
        .agree-term a:hover {
            text-decoration: underline;
        }

        /* 按钮 */
        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 4px;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-register {
            background: linear-gradient(90deg, #00d4c4, #00e0d0);
            color: #000;
            margin-bottom: 16px;
        }
        .btn-register:hover {
            background: linear-gradient(90deg, #00c2b3, #00d4c4);
        }
        .btn-login {
            background-color: transparent;
            color: #ccc;
            border: 1px solid #3a4252;
        }
        .btn-login:hover {
            background-color: #3a4252;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="logo">
    <!-- 保持 Logo 路径 -->
    <img src="./static/images/gaijin.png" alt="Gaijin Logo">
</div>

<div class="register-container">
    <h1 class="register-title">登记户口</h1>

    <%-- 显示错误信息 --%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div style="background: #d9232e; color: #fff; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; font-size: 16px;">
        <%= error %>
    </div>
    <% } %>

    <form action="register" method="post">
        <!-- 用户名 -->
        <div class="form-group">
            <div class="password-icon icon-user"></div>
            <input type="text" class="form-control" name="username" placeholder="用户名" required>
        </div>

        <!-- 邮箱 -->
        <div class="form-group">
            <div class="password-icon icon-user"></div>
            <input type="email" class="form-control" name="email" placeholder="邮箱地址" required>
        </div>

        <!-- 密码行 -->
        <div class="form-row">
            <div class="form-group">
                <div class="password-icon icon-lock"></div>
                <input type="password" class="form-control" name="password" placeholder="密码长度至少为6位" required>
                <div class="form-hint">Password must be at least 6 characters</div>
            </div>
        </div>

        <!-- 同意条款 -->
        <div class="agree-term">
            <input type="checkbox" id="agree" required>
            <label for="agree">我同意 <a href="#">服务条款</a> 以及 <a href="#">隐私政策</a></label>
        </div>

        <!-- 注册按钮 -->
        <button type="submit" class="btn btn-register">注册帐户</button>
    </form>

    <!-- 登录按钮 -->
    <button class="btn btn-login" onclick="location.href='Login.jsp'">登录到另一个</button>
</div>
</body>
</html>