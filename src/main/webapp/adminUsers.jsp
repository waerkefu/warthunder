<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - War Thunder 社区</title>
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

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 24px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .header h1 {
            color: #fff;
            font-size: 24px;
        }

        .search-bar {
            flex: 1;
            max-width: 400px;
            display: flex;
            gap: 8px;
            margin: 0 24px;
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

        .btn-back {
            padding: 8px 16px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-back:hover {
            background-color: #4a5568;
        }

        .user-table {
            width: 100%;
            background-color: #1e232a;
            border-radius: 8px;
            overflow: hidden;
            border-collapse: collapse;
        }

        .user-table th,
        .user-table td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #2d333b;
        }

        .user-table th {
            background-color: #252a32;
            color: #8892a5;
            font-weight: 500;
            font-size: 14px;
        }

        .user-table tr:hover {
            background-color: #252a32;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 10px;
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
            color: #b0b8c1;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
        }

        .btn-promote {
            background-color: #2196f3;
            color: #fff;
        }

        .btn-promote:hover {
            background-color: #1976d2;
        }

        .btn-demote {
            background-color: #ff9800;
            color: #fff;
        }

        .btn-demote:hover {
            background-color: #f57c00;
        }

        .btn-delete {
            background-color: #d9232e;
            color: #fff;
        }

        .btn-delete:hover {
            background-color: #c11f29;
        }

        .no-users {
            text-align: center;
            padding: 40px;
            color: #8892a5;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>用户管理</h1>
            <form action="adminUsers.jsp" method="get" class="search-bar">
                <input type="text" class="search-input" name="keyword" placeholder="搜索用户名或邮箱..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
                <button type="submit" class="btn-search">搜索</button>
            </form>
            <a href="adminUsers.jsp" class="btn-back">返回首页</a>
        </div>

        <table class="user-table">
            <thead>
                <tr>
                    <th>用户名</th>
                    <th>邮箱</th>
                    <th>角色</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String loginUser = (String) session.getAttribute("loginUser");
                    if (loginUser == null) {
                %>
                <tr>
                    <td colspan="4" class="no-users">请先登录</td>
                </tr>
                <%
                    } else {
                        try {
                            user_service us = new user_service();
                            user_model currentUser = us.findUserByUsername(loginUser);
                            
                            if (!currentUser.isAdmin()) {
                %>
                <tr>
                    <td colspan="4" class="no-users">权限不足，只有管理员可以访问此页面</td>
                </tr>
                <%
                            } else {
                                String keyword = request.getParameter("keyword");
                                ArrayList<user_model> users;
                                if (keyword != null && !keyword.trim().isEmpty()) {
                                    users = us.searchUsers(keyword.trim());
                                } else {
                                    users = us.findAllUsers();
                                }
                                if (users != null && !users.isEmpty()) {
                                    for (user_model user : users) {
                %>
                <tr>
                    <td><%= user.getUser_name() %></td>
                    <td><%= user.getEmail() %></td>
                    <td>
                        <% if (user.isAdmin()) { %>
                        <span class="role-badge role-admin">管理员</span>
                        <% } else if (user.isModerator()) { %>
                        <span class="role-badge role-moderator">小管理</span>
                        <% } else { %>
                        <span class="role-badge role-user">普通用户</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <% if (!user.isAdmin()) { %>
                                <% if (user.isModerator()) { %>
                                <a href="javascript:void(0);" onclick="confirmAction('确定要撤销该用户的小管理权限吗？', 'admin?action=demote&userId=<%= user.getUser_id() %>')" class="btn-action btn-demote">撤销小管理</a>
                                <% } else { %>
                                <a href="javascript:void(0);" onclick="confirmAction('确定要将该用户设为小管理吗？', 'admin?action=promote&userId=<%= user.getUser_id() %>')" class="btn-action btn-promote">设为小管理</a>
                                <% } %>
                                <a href="javascript:void(0);" onclick="confirmAction('确定要删除该用户吗？此操作不可恢复！', 'admin?action=deleteUser&userId=<%= user.getUser_id() %>')" class="btn-action btn-delete">删除用户</a>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <%
                                    }
                                } else {
                %>
                <tr>
                    <td colspan="4" class="no-users">暂无用户</td>
                </tr>
                <%
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                %>
                <tr>
                    <td colspan="4" class="no-users">数据库错误</td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <script>
        function confirmAction(message, url) {
            if (confirm(message)) {
                location.href = url;
            }
        }
    </script>
</body>
</html>