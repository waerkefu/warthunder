<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user_model" %>
<%@ page import="model.PostModel" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员仪表盘 - War Thunder 社区</title>
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

        /* 侧边栏样式 */
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
            margin-top: auto;
            padding-top: 24px;
            border-top: 1px solid #2d333b;
            margin-top: 32px;
        }

        .sidebar-footer p {
            color: #6b7280;
            font-size: 12px;
            text-align: center;
        }

        /* 主内容区域 */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 32px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .header-left h1 {
            color: #fff;
            font-size: 28px;
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

        /* 统计卡片 */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .stat-card {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid #2d333b;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            border-color: #3a4252;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .stat-icon.users {
            background: linear-gradient(135deg, #2196f3, #1976d2);
        }

        .stat-icon.posts {
            background: linear-gradient(135deg, #4caf50, #388e3c);
        }

        .stat-icon.videos {
            background: linear-gradient(135deg, #ff9800, #f57c00);
        }

        .stat-icon.comments {
            background: linear-gradient(135deg, #9c27b0, #7b1fa2);
        }

        .stat-icon.admins {
            background: linear-gradient(135deg, #00e0d0, #00b8a3);
        }

        .stat-icon.banned {
            background: linear-gradient(135deg, #d9232e, #c11f29);
        }

        .stat-info {
            flex: 1;
        }

        .stat-info .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            display: block;
        }

        .stat-info .stat-label {
            font-size: 14px;
            color: #8892a5;
            margin-top: 4px;
        }

        /* 双栏布局 */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }

        /* 快捷操作卡片 */
        .quick-actions {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #2d333b;
        }

        .quick-actions h2 {
            color: #fff;
            font-size: 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .action-card {
            background-color: #252a32;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: 1px solid transparent;
        }

        .action-card:hover {
            background-color: #3a4252;
            border-color: #00e0d0;
            transform: translateY(-2px);
        }

        .action-card i {
            font-size: 28px;
            color: #00e0d0;
            margin-bottom: 8px;
            display: block;
        }

        .action-card span {
            font-size: 14px;
            color: #fff;
            display: block;
        }

        .action-card small {
            font-size: 12px;
            color: #6b7280;
            display: block;
            margin-top: 4px;
        }

        /* 最近帖子 */
        .recent-section {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #2d333b;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            color: #fff;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-header a {
            color: #00e0d0;
            text-decoration: none;
            font-size: 14px;
            padding: 6px 12px;
            border-radius: 4px;
            background-color: #252a32;
            transition: background-color 0.3s;
        }

        .section-header a:hover {
            background-color: #3a4252;
        }

        .recent-table {
            width: 100%;
            border-collapse: collapse;
        }

        .recent-table th,
        .recent-table td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #2d333b;
        }

        .recent-table th {
            background-color: #252a32;
            color: #8892a5;
            font-weight: 500;
            font-size: 14px;
        }

        .recent-table tr:hover {
            background-color: #252a32;
        }

        .recent-table .title {
            color: #fff;
            font-size: 14px;
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            cursor: pointer;
            transition: color 0.3s;
        }

        .recent-table .title:hover {
            color: #00e0d0;
        }

        .recent-table .author {
            color: #8892a5;
            font-size: 13px;
        }

        .recent-table .date {
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

        /* 状态概览 */
        .status-overview {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #2d333b;
        }

        .status-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #2d333b;
        }

        .status-item:last-child {
            border-bottom: none;
        }

        .status-item .label {
            color: #8892a5;
            font-size: 14px;
        }

        .status-item .value {
            color: #fff;
            font-size: 18px;
            font-weight: 600;
        }

        .status-item .value.positive {
            color: #4caf50;
        }

        .status-item .value.negative {
            color: #d9232e;
        }

        /* 响应式设计 */
        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                position: relative;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <!-- 侧边栏 -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <span>⚔️</span>
            <span>WT Admin</span>
        </div>
        
        <ul class="sidebar-nav">
            <li><a href="admin" class="active"><i>📊</i>仪表盘</a></li>
            <li><a href="admin?action=listUsers"><i>👥</i>用户管理</a></li>
            <li><a href="admin?action=listPosts"><i>📝</i>帖子管理</a></li>
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

    <!-- 主内容区域 -->
    <main class="main-content">
        <div class="header">
            <div class="header-left">
                <h1>📊 管理员仪表盘</h1>
                <p>欢迎回来，<%= ((user_model)request.getAttribute("currentUser")).getUser_name() %>！这是今日系统概览。</p>
            </div>
            <div class="header-right">
                <div class="user-info">
                    <div class="user-avatar">👤</div>
                    <span><%= ((user_model)request.getAttribute("currentUser")).getUser_name() %></span>
                </div>
                <button class="btn-logout" onclick="location.href='Login.jsp'">退出登录</button>
            </div>
        </div>

        <!-- 统计卡片 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon users">👥</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("userCount") %></span>
                    <span class="stat-label">注册用户</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon posts">📝</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("activePostCount") %></span>
                    <span class="stat-label">活跃帖子</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon videos">🎬</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("videoCount") %></span>
                    <span class="stat-label">视频教程</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon comments">💬</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("commentCount") %></span>
                    <span class="stat-label">评论总数</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon admins">👑</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("adminCount") %></span>
                    <span class="stat-label">管理员</span>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon banned">🚫</div>
                <div class="stat-info">
                    <span class="stat-value"><%= request.getAttribute("bannedPostCount") %></span>
                    <span class="stat-label">封禁帖子</span>
                </div>
            </div>
        </div>

        <!-- 双栏布局 -->
        <div class="dashboard-grid">
            <!-- 快捷操作 -->
            <div class="quick-actions">
                <h2>⚡ 快捷操作</h2>
                <div class="actions-grid">
                    <div class="action-card" onclick="location.href='admin?action=listUsers'">
                        <i>👥</i>
                        <span>管理用户</span>
                        <small>查看和管理所有用户</small>
                    </div>
                    <div class="action-card" onclick="location.href='admin?action=listPosts'">
                        <i>📝</i>
                        <span>审核帖子</span>
                        <small>审核和管理帖子内容</small>
                    </div>
                    <div class="action-card" onclick="location.href='admin?action=listVideos'">
                        <i>🎬</i>
                        <span>添加视频</span>
                        <small>上传和管理教程视频</small>
                    </div>
                    <div class="action-card" onclick="location.href='tutorial.jsp'">
                        <i>📚</i>
                        <span>教程中心</span>
                        <small>管理教程文章</small>
                    </div>
                </div>
            </div>

            <!-- 状态概览 -->
            <div class="status-overview">
                <h2>📈 系统状态</h2>
                <div class="status-item">
                    <span class="label">总帖子数</span>
                    <span class="value"><%= request.getAttribute("postCount") %></span>
                </div>
                <div class="status-item">
                    <span class="label">活跃帖子</span>
                    <span class="value positive"><%= request.getAttribute("activePostCount") %></span>
                </div>
                <div class="status-item">
                    <span class="label">封禁帖子</span>
                    <span class="value negative"><%= request.getAttribute("bannedPostCount") %></span>
                </div>
                <div class="status-item">
                    <span class="label">封禁率</span>
                    <span class="value"><%= (Integer)request.getAttribute("postCount") > 0 ? 
                        String.format("%.1f%%", (Integer)request.getAttribute("bannedPostCount") * 100.0 / (Integer)request.getAttribute("postCount")) : "0%" %></span>
                </div>
            </div>
        </div>

        <!-- 最近帖子 -->
        <div class="recent-section">
            <div class="section-header">
                <h2>📋 最新帖子</h2>
                <a href="admin?action=listPosts">查看全部 →</a>
            </div>
            <table class="recent-table">
                <thead>
                    <tr>
                        <th>标题</th>
                        <th>作者</th>
                        <th>状态</th>
                        <th>创建时间</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            user_service us = new user_service();
                            ArrayList<PostModel> recentPosts = us.findAllPostsForAdmin();
                            if (recentPosts != null && !recentPosts.isEmpty()) {
                                int count = 0;
                                for (PostModel post : recentPosts) {
                                    if (count++ >= 5) break;
                    %>
                <tr>
                    <td class="title" onclick="location.href='postDetail?articleId=<%= post.getId() %>'">
                        <%= post.getTitle() %>
                    </td>
                    <td class="author"><%= post.getUsername() %></td>
                    <td>
                        <span class="status-badge <%= post.getStatus() == 1 ? "status-active" : "status-banned" %>">
                            <%= post.getStatus() == 1 ? "正常" : "已封禁" %>
                        </span>
                    </td>
                    <td class="date"><%= post.getCreate_time() != null && post.getCreate_time().length() >= 10 ? post.getCreate_time().substring(0, 10) : "" %></td>
                </tr>
                    <%
                                }
                            } else {
                    %>
                <tr>
                    <td colspan="4" style="text-align:center;color:#6b7280;">暂无帖子</td>
                </tr>
                    <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                    %>
                <tr>
                    <td colspan="4" style="text-align:center;color:#6b7280;">加载失败</td>
                </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>