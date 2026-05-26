<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="model.CommentModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>帖子详情 - War Thunder 社区</title>
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

        .btn-reply {
            background-color: #252a32;
            color: #00e0d0;
            padding: 4px 10px;
            font-size: 12px;
            border: 1px solid #3a4252;
        }

        .btn-reply:hover {
            background-color: #3a4252;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 24px;
        }

        .post-card {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            margin-bottom: 24px;
        }

        .post-header {
            padding-bottom: 16px;
            border-bottom: 1px solid #2d333b;
            margin-bottom: 16px;
        }

        .post-title {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 12px;
        }

        .post-meta {
            display: flex;
            gap: 16px;
            font-size: 14px;
            color: #8892a5;
        }

        .post-content {
            color: #e0e0e0;
            line-height: 1.8;
            font-size: 16px;
            white-space: pre-wrap;
        }

        .post-images {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #2d333b;
        }

        .images-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 12px;
        }

        .post-image {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .post-image:hover {
            transform: scale(1.02);
        }

        .post-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            padding-top: 16px;
            border-top: 1px solid #2d333b;
        }

        .comment-section {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .comment-title {
            font-size: 18px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 20px;
        }

        .comment-form {
            margin-bottom: 24px;
        }

        .comment-textarea {
            width: 100%;
            padding: 12px 16px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }

        .comment-textarea:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .comment-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .comment-item {
            background-color: #252a32;
            border-radius: 6px;
            padding: 16px;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .comment-author {
            color: #00e0d0;
            font-weight: 500;
            cursor: pointer;
        }

        .comment-author:hover {
            text-decoration: underline;
        }

        .comment-time {
            font-size: 12px;
            color: #8892a5;
        }

        .comment-content {
            color: #b0b8c1;
            font-size: 14px;
            line-height: 1.6;
        }

        .comment-actions {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid #3a4252;
        }

        .reply-list {
            margin-top: 12px;
            margin-left: 24px;
            border-left: 2px solid #3a4252;
            padding-left: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .reply-item {
            background-color: #1e232a;
            border-radius: 4px;
            padding: 12px;
        }

        .reply-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .reply-author {
            color: #00e0d0;
            font-weight: 500;
            font-size: 13px;
        }

        .reply-time {
            font-size: 11px;
            color: #8892a5;
        }

        .reply-content {
            color: #b0b8c1;
            font-size: 13px;
            line-height: 1.5;
        }

        .reply-quote {
            background-color: rgba(0, 224, 208, 0.05);
            border-left: 3px solid #00e0d0;
            padding: 8px 12px;
            margin-bottom: 8px;
            font-size: 12px;
            color: #8892a5;
        }

        .reply-form {
            margin-top: 12px;
            display: none;
        }

        .reply-textarea {
            width: 100%;
            padding: 8px 12px;
            background-color: #1e232a;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 13px;
            resize: vertical;
            min-height: 60px;
            font-family: inherit;
            margin-bottom: 8px;
        }

        .reply-textarea:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .empty-state {
            text-align: center;
            padding: 30px;
            color: #8892a5;
        }

        .error-message {
            color: #d9232e;
            margin-bottom: 16px;
            padding: 12px;
            background-color: rgba(217, 35, 46, 0.1);
            border-radius: 4px;
        }

        .cancel-reply {
            color: #8892a5;
            font-size: 12px;
            cursor: pointer;
            margin-left: 8px;
        }

        .cancel-reply:hover {
            color: #fff;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-logo">
        <h2>War Thunder 社区</h2>
    </div>
    <div class="navbar-user">
        <%
            String loginUser = (String) session.getAttribute("loginUser");
            if (loginUser != null && !loginUser.isEmpty()) {
        %>
        <span>欢迎, <%= loginUser %></span>
        <button class="btn btn-secondary" onclick="location.href='profile'">个人中心</button>
        <button class="btn btn-secondary" onclick="location.href='index.jsp'">返回首页</button>
        <%
            } else {
        %>
        <button class="btn btn-secondary" onclick="location.href='Login.jsp'">登录</button>
        <%
            }
        %>
    </div>
</nav>

<div class="container">
    <%
        PostModel post = (PostModel) request.getAttribute("post");
        ArrayList<CommentModel> comments = (ArrayList<CommentModel>) request.getAttribute("comments");
        
        if (post == null) {
    %>
    <div class="error-message">帖子不存在</div>
    <button class="btn btn-secondary" onclick="location.href='index.jsp'">返回首页</button>
    <%
            return;
        }
        
        HashMap<Integer, ArrayList<CommentModel>> replyMap = new HashMap<>();
        ArrayList<CommentModel> topLevelComments = new ArrayList<>();
        
        if (comments != null) {
            for (CommentModel comment : comments) {
                if (comment.hasParent()) {
                    if (!replyMap.containsKey(comment.getParent_id())) {
                        replyMap.put(comment.getParent_id(), new ArrayList<CommentModel>());
                    }
                    replyMap.get(comment.getParent_id()).add(comment);
                } else {
                    topLevelComments.add(comment);
                }
            }
        }
    %>

    <div class="post-card">
        <div class="post-header">
            <h1 class="post-title"><%= post.getTitle() %></h1>
            <div class="post-meta">
                <span>作者: <%= post.getUsername() %></span>
                <span>发布时间: <%= post.getCreate_time() %></span>
            </div>
        </div>
        <div class="post-content"><%= post.getContent() %></div>
        
        <% if (post.hasImages()) { %>
        <div class="post-images">
            <div class="images-grid">
                <% if (post.getImage1() != null) { %><img src="<%= post.getImage1() %>" class="post-image" alt="图片1"><% } %>
                <% if (post.getImage2() != null) { %><img src="<%= post.getImage2() %>" class="post-image" alt="图片2"><% } %>
                <% if (post.getImage3() != null) { %><img src="<%= post.getImage3() %>" class="post-image" alt="图片3"><% } %>
                <% if (post.getImage4() != null) { %><img src="<%= post.getImage4() %>" class="post-image" alt="图片4"><% } %>
                <% if (post.getImage5() != null) { %><img src="<%= post.getImage5() %>" class="post-image" alt="图片5"><% } %>
            </div>
        </div>
        <% } %>
        
        <%
            boolean isAdmin = false;
            if (loginUser != null) {
                try {
                    user_service us = new user_service();
                    user_model user = us.findUserByUsername(loginUser);
                    isAdmin = user.isAdmin();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            boolean isPostOwner = loginUser != null && loginUser.equals(post.getUsername());
            
            if (isPostOwner || isAdmin) {
        %>
        <div class="post-actions">
            <button class="btn btn-secondary" onclick="location.href='editPost?articleId=<%= post.getId() %>'">编辑帖子</button>
            <button class="btn btn-danger" onclick="if(confirm('确定要删除这篇帖子吗？')) location.href='deletePost?articleId=<%= post.getId() %>'">删除帖子</button>
        </div>
        <%
            }
        %>
    </div>

    <div class="comment-section">
        <h3 class="comment-title">评论 (<%= comments != null ? comments.size() : 0 %>)</h3>

        <%
            if (loginUser != null && !loginUser.isEmpty()) {
        %>
        <form class="comment-form" action="addComment" method="post">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            <textarea class="comment-textarea" name="content" placeholder="发表你的评论..." required></textarea>
            <button type="submit" class="btn btn-primary" style="margin-top: 12px;">发表评论</button>
        </form>
        <%
            } else {
        %>
        <p style="color: #8892a5; margin-bottom: 16px;">请先登录才能发表评论</p>
        <%
            }
        %>

        <div class="comment-list">
            <%
                if (topLevelComments != null && !topLevelComments.isEmpty()) {
                    for (CommentModel comment : topLevelComments) {
                        ArrayList<CommentModel> replies = replyMap.get(comment.getId());
            %>
            <div class="comment-item" id="comment-<%= comment.getId() %>">
                <div class="comment-header">
                    <span class="comment-author" onclick="showReplyForm(<%= comment.getId() %>, '<%= comment.getUsername() %>')">@<%= comment.getUsername() %></span>
                    <span class="comment-time"><%= comment.getCreate_time() %></span>
                </div>
                <div class="comment-content"><%= comment.getContent() %></div>
                <div class="comment-actions">
                    <button class="btn btn-reply" onclick="showReplyForm(<%= comment.getId() %>, '<%= comment.getUsername() %>')">回复</button>
                    <% if (isPostOwner || isAdmin) { %>
                    <button class="btn btn-danger" style="font-size: 12px; padding: 4px 10px;" onclick="if(confirm('确定要删除这条评论吗？')) location.href='admin?action=deleteComment&commentId=<%= comment.getId() %>&postId=<%= post.getId() %>'">删除</button>
                    <% } %>
                </div>
                
                <div class="reply-form" id="reply-form-<%= comment.getId() %>">
                    <form action="addComment" method="post">
                        <input type="hidden" name="postId" value="<%= post.getId() %>">
                        <input type="hidden" name="parentId" value="<%= comment.getId() %>">
                        <textarea class="reply-textarea" name="content" placeholder="回复 <%= comment.getUsername() %>..." required></textarea>
                        <button type="submit" class="btn btn-primary" style="font-size: 12px; padding: 4px 12px;">发送</button>
                        <span class="cancel-reply" onclick="hideReplyForm(<%= comment.getId() %>)">取消</span>
                    </form>
                </div>
                
                <% if (replies != null && !replies.isEmpty()) { %>
                <div class="reply-list">
                    <% for (CommentModel reply : replies) { %>
                    <div class="reply-item">
                        <div class="reply-header">
                            <span class="reply-author">@<%= reply.getUsername() %></span>
                            <span class="reply-time"><%= reply.getCreate_time() %></span>
                        </div>
                        <% if (reply.hasParent() && reply.getParent_username() != null) { %>
                        <div class="reply-quote">
                            <strong><%= reply.getParent_username() %>:</strong> <%= comment.getContent().length() > 50 ? comment.getContent().substring(0, 50) + "..." : comment.getContent() %>
                        </div>
                        <% } %>
                        <div class="reply-content"><%= reply.getContent() %></div>
                        <div style="margin-top: 8px;">
                            <button class="btn btn-reply" onclick="showReplyForm(<%= comment.getId() %>, '<%= reply.getUsername() %>')">回复</button>
                            <% if (isPostOwner || isAdmin) { %>
                            <button class="btn btn-danger" style="font-size: 12px; padding: 4px 10px;" onclick="if(confirm('确定要删除这条回复吗？')) location.href='admin?action=deleteComment&commentId=<%= reply.getId() %>&postId=<%= post.getId() %>'">删除</button>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">
                <p>暂无评论，快来发表第一条评论吧！</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

<script>
    function showReplyForm(commentId, username) {
        var form = document.getElementById('reply-form-' + commentId);
        var textarea = form.querySelector('textarea');
        textarea.value = '@' + username + ' ';
        textarea.focus();
        form.style.display = 'block';
    }

    function hideReplyForm(commentId) {
        var form = document.getElementById('reply-form-' + commentId);
        form.style.display = 'none';
        var textarea = form.querySelector('textarea');
        textarea.value = '';
    }
</script>
</body>
</html>