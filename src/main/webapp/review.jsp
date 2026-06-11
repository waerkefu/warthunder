<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="model.TutorialArticleModel" %>
<%@ page import="model.VideoModel" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>内容审核 - War Thunder 社区</title>
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

        .btn-back {
            background-color: #00e0d0;
            color: #000;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 24px;
        }

        .review-section {
            background-color: #1e232a;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title .badge {
            background-color: #d9232e;
            color: #fff;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
        }

        .review-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .review-item {
            background-color: #252a32;
            border-radius: 6px;
            padding: 16px;
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 8px;
        }

        .item-title {
            font-size: 16px;
            font-weight: 500;
            color: #fff;
        }

        .item-author {
            font-size: 12px;
            color: #8892a5;
        }

        .item-content {
            color: #b0b8c1;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .item-meta {
            font-size: 12px;
            color: #8892a5;
            margin-bottom: 12px;
        }

        .item-actions {
            display: flex;
            gap: 8px;
        }

        .btn-pass {
            background-color: #4caf50;
            color: #fff;
            padding: 6px 14px;
            font-size: 13px;
        }

        .btn-reject {
            background-color: #d9232e;
            color: #fff;
            padding: 6px 14px;
            font-size: 13px;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 24px;
            width: 90%;
            max-width: 480px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .modal-header h3 {
            color: #fff;
            font-size: 18px;
        }

        .modal-close {
            background: none;
            border: none;
            color: #8892a5;
            font-size: 24px;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #b0b8c1;
            font-size: 14px;
        }

        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
            min-height: 80px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .btn-submit {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #8892a5;
        }

        .video-item {
            display: flex;
            gap: 16px;
        }

        .video-thumb {
            width: 120px;
            height: 80px;
            background-color: #252a32;
            border-radius: 4px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .video-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 4px;
        }

        .video-info {
            flex: 1;
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
        <button class="btn btn-back" onclick="location.href='profile'">返回个人中心</button>
    </div>
</nav>

<div class="container">
    <h1 class="page-title">🔍 内容审核</h1>

    <div class="review-section">
        <div class="section-title">
            📝 待审核帖子
            <%
                ArrayList<PostModel> pendingPosts = (ArrayList<PostModel>) request.getAttribute("pendingPosts");
                if (pendingPosts != null && pendingPosts.size() > 0) {
            %>
            <span class="badge"><%= pendingPosts.size() %></span>
            <% } %>
        </div>
        <div class="review-list">
            <%
                if (pendingPosts != null && !pendingPosts.isEmpty()) {
                    for (PostModel post : pendingPosts) {
            %>
            <div class="review-item">
                <div class="item-header">
                    <div>
                        <div class="item-title"><%= post.getTitle() %></div>
                        <div class="item-author">作者: <%= post.getUsername() %></div>
                    </div>
                </div>
                <div class="item-content"><%= post.getContent() %></div>
                <div class="item-meta">发布时间: <%= post.getCreate_time() %></div>
                <div class="item-actions">
                    <button class="btn btn-pass" onclick="showPassModal('post', <%= post.getId() %>)">通过</button>
                    <button class="btn btn-reject" onclick="showRejectModal('post', <%= post.getId() %>)">不通过</button>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">暂无待审核的帖子</div>
            <% } %>
        </div>
    </div>

    <div class="review-section">
        <div class="section-title">
            📄 待审核教程文章
            <%
                ArrayList<TutorialArticleModel> pendingArticles = (ArrayList<TutorialArticleModel>) request.getAttribute("pendingArticles");
                if (pendingArticles != null && pendingArticles.size() > 0) {
            %>
            <span class="badge"><%= pendingArticles.size() %></span>
            <% } %>
        </div>
        <div class="review-list">
            <%
                if (pendingArticles != null && !pendingArticles.isEmpty()) {
                    for (TutorialArticleModel article : pendingArticles) {
            %>
            <div class="review-item">
                <div class="item-header">
                    <div>
                        <div class="item-title"><%= article.getTitle() %></div>
                        <div class="item-author">作者: <%= article.getUsername() %> | 分类: <%= article.getCategoryName() %></div>
                    </div>
                </div>
                <div class="item-content"><%= article.getContent() %></div>
                <div class="item-meta">发布时间: <%= article.getCreateTime() %></div>
                <div class="item-actions">
                    <button class="btn btn-pass" onclick="showPassModal('article', <%= article.getId() %>)">通过</button>
                    <button class="btn btn-reject" onclick="showRejectModal('article', <%= article.getId() %>)">不通过</button>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">暂无待审核的教程文章</div>
            <% } %>
        </div>
    </div>

    <%
        Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin) {
    %>
    <div class="review-section">
        <div class="section-title">
            🎬 待审核视频
            <%
                ArrayList<VideoModel> pendingVideos = (ArrayList<VideoModel>) request.getAttribute("pendingVideos");
                if (pendingVideos != null && pendingVideos.size() > 0) {
            %>
            <span class="badge"><%= pendingVideos.size() %></span>
            <% } %>
        </div>
        <div class="review-list">
            <%
                if (pendingVideos != null && !pendingVideos.isEmpty()) {
                    for (VideoModel video : pendingVideos) {
            %>
            <div class="review-item video-item">
                <div class="video-thumb">
                    <% if (video.getThumbnailUrl() != null && !video.getThumbnailUrl().isEmpty()) { %>
                    <img src="<%= video.getThumbnailUrl() %>" alt="缩略图">
                    <% } else { %>
                    🎬
                    <% } %>
                </div>
                <div class="video-info">
                    <div class="item-header">
                        <div>
                            <div class="item-title"><%= video.getTitle() %></div>
                            <div class="item-author">UP主: <%= video.getAuthor() %> | BV: <%= video.getBvid() %></div>
                        </div>
                    </div>
                    <div class="item-content"><%= video.getDescription() != null ? video.getDescription() : "暂无描述" %></div>
                    <div class="item-meta">分类: <%= video.getCategoryName() %> | 发布时间: <%= video.getCreateTime() %></div>
                    <div class="item-actions">
                        <button class="btn btn-pass" onclick="showPassModal('video', <%= video.getId() %>)">通过</button>
                        <button class="btn btn-reject" onclick="showRejectModal('video', <%= video.getId() %>)">不通过</button>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">暂无待审核的视频</div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>

<div class="modal" id="passModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>确认通过审核</h3>
            <button class="modal-close" onclick="closeModal('passModal')">×</button>
        </div>
        <p style="color: #b0b8c1; margin-bottom: 16px;">确认通过该内容的审核？</p>
        <form id="passForm" action="review" method="post">
            <input type="hidden" id="passAction" name="action">
            <input type="hidden" id="passId" name="id">
            <div class="form-actions">
                <button type="button" class="btn-submit btn-secondary" onclick="closeModal('passModal')">取消</button>
                <button type="submit" class="btn-submit btn-pass">确认通过</button>
            </div>
        </form>
    </div>
</div>

<div class="modal" id="rejectModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>审核不通过</h3>
            <button class="modal-close" onclick="closeModal('rejectModal')">×</button>
        </div>
        <form id="rejectForm" action="review" method="post">
            <input type="hidden" id="rejectAction" name="action">
            <input type="hidden" id="rejectId" name="id">
            <div class="form-group">
                <label for="rejectMessage">驳回原因（选填）</label>
                <textarea id="rejectMessage" name="message" placeholder="请输入驳回原因，将显示给发布者"></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn-submit btn-secondary" onclick="closeModal('rejectModal')">取消</button>
                <button type="submit" class="btn-submit btn-reject">确认驳回</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showPassModal(type, id) {
        document.getElementById('passAction').value = 'pass' + capitalizeFirst(type);
        document.getElementById('passId').value = id;
        document.getElementById('passModal').classList.add('active');
    }

    function showRejectModal(type, id) {
        document.getElementById('rejectAction').value = 'reject' + capitalizeFirst(type);
        document.getElementById('rejectId').value = id;
        document.getElementById('rejectMessage').value = '';
        document.getElementById('rejectModal').classList.add('active');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('active');
    }

    function capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    document.getElementById('passModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('passModal');
    });

    document.getElementById('rejectModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('rejectModal');
    });
</script>
</body>
</html>