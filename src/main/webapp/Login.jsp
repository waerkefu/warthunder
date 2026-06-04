<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - Gaijin.Net</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", sans-serif;
        }

        body {
            /* 用测试成功的相对路径写法 */
            background: #1a1d24 url("./static/images/beijing.png") no-repeat center center;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
        }

        .login-container {
            background: rgba(26, 29, 36, 0.92);
            padding: 40px;
            border-radius: 8px;
            width: 100%;
            max-width: 800px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
        }

        .header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
        }

        .header img {
            width: 48px;
            height: 48px;
            margin-right: 12px;
        }

        .header h2 {
            font-size: 20px;
            font-weight: 400;
            opacity: 0.9;
        }

        .header h2 small {
            display: block;
            font-size: 28px;
            font-weight: 600;
            margin-top: 4px;
        }

        .title {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 30px;
            color: #fff;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            background: #2d313a;
            border: 1px solid #3a3f4b;
            border-radius: 4px;
            color: #fff;
            font-size: 18px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #d9232e;
        }

        .hint-text {
            font-size: 24px;
            line-height: 1.6;
            margin: 20px 0;
            opacity: 0.9;
        }

        .btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 4px;
            font-size: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            margin-bottom: 16px; /* 统一按钮间距 */
        }

        .btn-login {
            background: #d9232e;
            color: #fff;
        }

        .btn-login:hover {
            background: #c11f29;
        }

        .btn-forgot {
            background: transparent;
            color: #fff;
            border: 1px solid #fff;
        }

        .btn-forgot:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        /* 新增注册按钮样式 */
        .btn-register {
            background: #2d313a;
            color: #fff;
            border: 1px solid #d9232e;
        }

        .btn-register:hover {
            background: #3a3f4b;
            box-shadow: 0 0 8px rgba(217, 35, 46, 0.3);
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="header">
        <!-- 用测试成功的相对路径写法 -->
        <img src="./static/images/logo.png" alt="Gaijin Logo">
        <h2>帐户<br><small>Gaijin.Net</small></h2>
    </div>

    <h1 class="title">登录</h1>

    <%-- 显示错误信息 --%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div style="background: #d9232e; color: #fff; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; font-size: 16px;">
        <%= error %>
    </div>
    <% } %>

    <form action="Login" method="post">
        <div class="form-group">
            <input type="email" class="form-control" name="email" placeholder="邮箱地址" required>
        </div>
        <div class="form-group">
            <input type="password" class="form-control" name="password" placeholder="密码" required>
        </div>

        <p class="hint-text">
            登录 War Thunder 论坛
        </p>

        <button type="submit" class="btn btn-login">登录</button>
        <button type="button" class="btn btn-forgot" onclick="alert('请联系管理员电话：15147002984')">找回密码</button>
        <!-- 新增注册按钮 -->
        <button type="button" class="btn btn-register" onclick="location.href='register.jsp'">注册账号</button>
    </form>
</div>
</body>
</html>