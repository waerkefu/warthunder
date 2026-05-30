<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.TutorialArticleModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>教程文章详情 - War Thunder 社区</title>
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
            max-width: 900px;
            margin: 0 auto;
            padding: 24px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .btn-back {
            padding: 10px 20px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .article-card {
            background-color: #1e232a;
            border-radius: 12px;
            overflow: hidden;
        }

        .article-header {
            padding: 32px;
            border-bottom: 1px solid #252a32;
        }

        .category-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 12px;
            margin-bottom: 16px;
        }

        .category-maps { background-color: #2196f3; color: #fff; }
        .category-vehicles { background-color: #4caf50; color: #fff; }
        .category-weakspots { background-color: #ff9800; color: #fff; }

        .article-title {
            font-size: 28px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 16px;
            line-height: 1.4;
        }

        .article-meta {
            display: flex;
            gap: 24px;
            color: #8892a5;
            font-size: 14px;
        }

        .article-meta span {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .article-content {
            padding: 32px;
        }

        .article-content p {
            line-height: 1.8;
            margin-bottom: 16px;
            color: #b0b8c1;
        }

        .article-content h2 {
            color: #00e0d0;
            font-size: 20px;
            margin: 32px 0 16px 0;
        }

        .article-content h3 {
            color: #fff;
            font-size: 18px;
            margin: 24px 0 12px 0;
        }

        .article-content ul, .article-content ol {
            margin: 16px 0;
            padding-left: 24px;
        }

        .article-content li {
            line-height: 1.8;
            margin-bottom: 8px;
            color: #b0b8c1;
        }

        .article-content strong {
            color: #fff;
        }

        .article-images {
            padding: 0 32px 32px 32px;
        }

        .article-images h3 {
            color: #fff;
            font-size: 16px;
            margin-bottom: 16px;
        }

        .image-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        .image-grid img {
            width: 100%;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .image-grid img:hover {
            transform: scale(1.02);
        }

        .article-actions {
            padding: 24px 32px;
            border-top: 1px solid #252a32;
            display: flex;
            gap: 12px;
        }

        .btn-edit {
            padding: 10px 20px;
            background-color: #2196f3;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-delete {
            padding: 10px 20px;
            background-color: #d9232e;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .lightbox {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.9);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .lightbox.active {
            display: flex;
        }

        .lightbox img {
            max-width: 90%;
            max-height: 90%;
            border-radius: 8px;
        }

        .lightbox-close {
            position: absolute;
            top: 20px;
            right: 20px;
            background: none;
            border: none;
            color: #fff;
            font-size: 32px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-left">
                <a href="tutorial.jsp" class="btn-back">← 返回教程</a>
            </div>
        </div>

        <%
            TutorialArticleModel article = (TutorialArticleModel) request.getAttribute("article");
            if (article == null) {
        %>
        <div style="text-align:center;padding:60px;color:#8892a5;">文章不存在或已被删除</div>
        <%
            } else {
                String loginUser = (String) session.getAttribute("loginUser");
                boolean canEdit = false;
                if (loginUser != null) {
                    try {
                        user_service us = new user_service();
                        user_model currentUser = us.findUserByUsername(loginUser);
                        canEdit = currentUser.isAdmin() || currentUser.isModerator() || article.getUserId() == currentUser.getUser_id();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
        %>
        <div class="article-card">
            <div class="article-header">
                <span class="category-badge <%= "category-" + article.getCategory() %>"><%= article.getCategoryIcon() %> <%= article.getCategoryName() %></span>
                <h1 class="article-title"><%= article.getTitle() %></h1>
                <div class="article-meta">
                    <span>👤 <%= article.getUsername() != null ? article.getUsername() : "未知" %></span>
                    <span>👁️ <%= article.getViewCount() %> 次浏览</span>
                    <span>📅 <%= article.getCreateTime() != null ? article.getCreateTime().substring(0, 10) : "" %></span>
                </div>
            </div>

            <div class="article-content">
                <%
                    String content = article.getContent();
                    if (content != null) {
                        // 简单的 Markdown 渲染
                        content = content.replace("\n\n", "</p><p>");
                        content = content.replace("\n", "<br>");
                        content = content.replaceAll("## (.*)", "<h2>$1</h2>");
                        content = content.replaceAll("### (.*)", "<h3>$1</h3>");
                        content = content.replaceAll("\\*\\*(.*?)\\*\\*", "<strong>$1</strong>");
                        content = content.replaceAll("- (.*)", "<li>$1</li>");
                        out.println(content);
                    }
                %>
            </div>

            <%
                boolean hasImages = article.getImage1() != null || article.getImage2() != null || 
                                   article.getImage3() != null || article.getImage4() != null || 
                                   article.getImage5() != null || article.getImage6() != null;
                if (hasImages) {
            %>
            <div class="article-images">
                <h3>📎 文章配图</h3>
                <div class="image-grid">
                    <% if (article.getImage1() != null) { %>
                    <img src="<%= article.getImage1() %>" onclick="openLightbox(this.src)">
                    <% } %>
                    <% if (article.getImage2() != null) { %>
                    <img src="<%= article.getImage2() %>" onclick="openLightbox(this.src)">
                    <% } %>
                    <% if (article.getImage3() != null) { %>
                    <img src="<%= article.getImage3() %>" onclick="openLightbox(this.src)">
                    <% } %>
                    <% if (article.getImage4() != null) { %>
                    <img src="<%= article.getImage4() %>" onclick="openLightbox(this.src)">
                    <% } %>
                    <% if (article.getImage5() != null) { %>
                    <img src="<%= article.getImage5() %>" onclick="openLightbox(this.src)">
                    <% } %>
                    <% if (article.getImage6() != null) { %>
                    <img src="<%= article.getImage6() %>" onclick="openLightbox(this.src)">
                    <% } %>
                </div>
            </div>
            <%
                }
                
                if (canEdit) {
            %>
            <div class="article-actions">
                <a href="editTutorialArticle.jsp?id=<%= article.getId() %>" class="btn-edit">编辑文章</a>
                <button class="btn-delete" onclick="confirmDelete(<%= article.getId() %>)">删除文章</button>
            </div>
            <%
                }
            %>
        </div>
        <%
            }
        %>
    </div>

    <div class="lightbox" id="lightbox" onclick="closeLightbox()">
        <button class="lightbox-close">×</button>
        <img id="lightboxImg" src="">
    </div>

    <script>
        function openLightbox(src) {
            document.getElementById('lightboxImg').src = src;
            document.getElementById('lightbox').classList.add('active');
        }

        function closeLightbox() {
            document.getElementById('lightbox').classList.remove('active');
        }

        function confirmDelete(id) {
            if (confirm('确定要删除这篇文章吗？此操作不可恢复！')) {
                window.location.href = 'tutorialArticle?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>