<%!
    public String getThumbnailUrl(model.VideoModel video) {
        String url = video.getThumbnailUrl();
        if (url != null && !url.isEmpty()) {
            return url;
        }
        // 根据分类返回不同的占位图
        String category = video.getCategory();
        if ("maps".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🗺️</text></svg>";
        } else if ("vehicles".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>⚔️</text></svg>";
        } else if ("weakspots".equals(category)) {
            return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🎯</text></svg>";
        }
        return "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 9'><rect fill='%23252a32' width='16' height='9'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-size='0.8' fill='%2300e0d0'>🎬</text></svg>";
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.VideoModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>视频管理 - War Thunder 社区</title>
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
            max-width: 1200px;
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

        .btn-back,
        .btn-add {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
        }

        .btn-back {
            background-color: #3a4252;
            color: #fff;
        }

        .btn-add {
            background-color: #00e0d0;
            color: #000;
        }

        .btn-add:hover {
            background-color: #00c2b3;
        }

        .video-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }

        .video-card {
            background-color: #1e232a;
            border-radius: 12px;
            overflow: hidden;
        }

        .video-thumb {
            width: 100%;
            height: 180px;
            background-color: #252a32;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .video-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-thumb-placeholder {
            font-size: 48px;
            color: #8892a5;
        }

        .bilibili-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            background-color: #fb7299;
            color: #fff;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .video-info {
            padding: 16px;
        }

        .video-title {
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .video-meta {
            color: #8892a5;
            font-size: 12px;
            margin-bottom: 12px;
        }

        .video-actions {
            display: flex;
            gap: 8px;
        }

        .btn-edit,
        .btn-delete {
            flex: 1;
            padding: 8px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            text-align: center;
        }

        .btn-edit {
            background-color: #2196f3;
            color: #fff;
        }

        .btn-delete {
            background-color: #d9232e;
            color: #fff;
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
            padding: 32px;
            width: 90%;
            max-width: 600px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }

        .modal-header h2 {
            color: #fff;
            font-size: 20px;
        }

        .modal-close {
            background: none;
            border: none;
            color: #8892a5;
            font-size: 28px;
            cursor: pointer;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #b0b8c1;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 4px;
            color: #fff;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #00e0d0;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .btn-submit {
            flex: 1;
            padding: 12px;
            background-color: #00e0d0;
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
        }

        .btn-cancel {
            flex: 1;
            padding: 12px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .no-videos {
            text-align: center;
            padding: 60px;
            color: #8892a5;
        }

        .category-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .category-maps {
            background-color: #2196f3;
            color: #fff;
        }

        .category-vehicles {
            background-color: #4caf50;
            color: #fff;
        }

        .category-weakspots {
            background-color: #ff9800;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎬 视频教程管理</h1>
            <div>
                <button class="btn-add" onclick="openModal()">添加视频</button>
                <button class="btn-back" onclick="location.href='index.jsp'">返回首页</button>
            </div>
        </div>

        <div class="video-grid">
            <%
                String loginUser = (String) session.getAttribute("loginUser");
                if (loginUser == null) {
            %>
            <div class="no-videos">请先登录</div>
            <%
                } else {
                    try {
                        user_service us = new user_service();
                        user_model currentUser = us.findUserByUsername(loginUser);

                        if (!currentUser.isAdmin() && !currentUser.isModerator()) {
            %>
            <div class="no-videos">权限不足，只有管理员和小管理可以访问此页面</div>
            <%
                        } else {
                            ArrayList<VideoModel> videos = us.findAllVideos();
                            if (videos != null && !videos.isEmpty()) {
                                for (VideoModel video : videos) {
            %>
            <div class="video-card">
                <div class="video-thumb">
                    <img 
                        src="<%= getThumbnailUrl(video) %>" 
                        alt="缩略图"
                        onerror="this.onerror=null;this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 16 9%22><rect fill=%22%23252a32%22 width=%2216%22 height=%229%22/><text x=%2250%%22 y=%2250%%22 dominant-baseline=%22middle%22 text-anchor=%22middle%22 font-size=%220.8%22 fill=%22%2300e0d0%22>🎬</text></svg>';"
                        style="width:100%;height:100%;object-fit:cover;"
                    >
                    <span class="bilibili-badge">BV:<%= video.getBvid() %></span>
                </div>
                <div class="video-info">
                    <span class="category-badge <%= "category-" + video.getCategory() %>"><%= video.getCategoryName() %></span>
                    <h3 class="video-title"><%= video.getTitle() %></h3>
                    <p class="video-meta">
                        <%= video.getAuthor() %> · <%= video.getViewCount() %>次播放 · <%= video.getCreateTime() != null ? video.getCreateTime().substring(0, 10) : "" %>
                    </p>
                    <div class="video-actions">
                        <a href="javascript:void(0);" class="btn-edit" onclick="editVideo(<%= video.getId() %>, '<%= video.getBvid() %>', '<%= video.getTitle() %>', '<%= video.getDescription() != null ? video.getDescription().replace("'", "\\'").replace("\n", " ") : "" %>', '<%= video.getThumbnailUrl() != null ? video.getThumbnailUrl() : "" %>', '<%= video.getCategory() %>', '<%= video.getAuthor() %>')">编辑</a>
                        <a href="javascript:void(0);" class="btn-delete" onclick="confirmDelete(<%= video.getId() %>)">删除</a>
                    </div>
                </div>
            </div>
            <%
                                }
                            } else {
            %>
            <div class="no-videos">暂无视频，点击"添加视频"开始添加</div>
            <%
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
            %>
            <div class="no-videos">加载失败，请稍后重试</div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <div class="modal" id="videoModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">添加视频</h2>
                <button class="modal-close" onclick="closeModal()">×</button>
            </div>
            <form action="video" method="post" id="videoForm" enctype="multipart/form-data">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="videoId">
                <input type="hidden" name="keepThumbnail" id="keepThumbnail" value="true">

                <div class="form-group">
                    <label for="bvid">BV号 *</label>
                    <input type="text" id="bvid" name="bvid" placeholder="例如: BV1234567890" required>
                </div>

                <div class="form-group">
                    <label for="title">视频标题 *</label>
                    <input type="text" id="title" name="title" placeholder="输入视频标题" required>
                </div>

                <div class="form-group">
                    <label for="description">视频描述</label>
                    <textarea id="description" name="description" placeholder="输入视频描述（可选）"></textarea>
                </div>

                <div class="form-group">
                    <label for="thumbnail">缩略图</label>
                    <input type="file" id="thumbnail" name="thumbnail" accept="image/*" onchange="previewThumbnail(this)">
                    <div id="thumbnailPreview" style="margin-top:10px;display:none;">
                        <img id="previewImg" style="max-width:200px;max-height:150px;border-radius:4px;border:2px solid #3a4252;">
                        <p style="color:#8892a5;font-size:12px;margin-top:5px;">点击可预览</p>
                    </div>
                    <div id="existingThumbnail" style="margin-top:10px;display:none;">
                        <p style="color:#8892a5;font-size:12px;margin-bottom:5px;">现有缩略图：</p>
                        <img id="existingImg" style="max-width:200px;max-height:150px;border-radius:4px;border:2px solid #3a4252;">
                        <label style="display:block;margin-top:8px;cursor:pointer;color:#00e0d0;">
                            <input type="checkbox" id="removeThumbnail" onchange="toggleRemoveThumbnail()"> 移除现有缩略图
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="category">分类</label>
                    <select id="category" name="category">
                        <option value="maps">🗺️ 地图解析</option>
                        <option value="vehicles">⚔️ 载具测评</option>
                        <option value="weakspots">🎯 车辆弱点</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="author">UP主</label>
                    <input type="text" id="author" name="author" placeholder="输入UP主名称（可选）">
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal()">取消</button>
                    <button type="submit" class="btn-submit">提交</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('modalTitle').textContent = '添加视频';
            document.getElementById('formAction').value = 'add';
            document.getElementById('videoForm').reset();
            document.getElementById('videoId').value = '';
            document.getElementById('keepThumbnail').value = 'true';
            document.getElementById('removeThumbnail').checked = false;
            document.getElementById('thumbnailPreview').style.display = 'none';
            document.getElementById('existingThumbnail').style.display = 'none';
            document.getElementById('videoModal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('videoModal').classList.remove('active');
        }

        function editVideo(id, bvid, title, description, thumbnailUrl, category, author) {
            document.getElementById('modalTitle').textContent = '编辑视频';
            document.getElementById('formAction').value = 'update';
            document.getElementById('videoId').value = id;
            document.getElementById('bvid').value = bvid;
            document.getElementById('title').value = title;
            document.getElementById('description').value = description;
            document.getElementById('category').value = category;
            document.getElementById('author').value = author;
            
            // 重置预览和复选框
            document.getElementById('thumbnailPreview').style.display = 'none';
            document.getElementById('removeThumbnail').checked = false;
            document.getElementById('keepThumbnail').value = 'true';
            
            // 显示现有缩略图
            if (thumbnailUrl && thumbnailUrl.trim() !== '') {
                document.getElementById('existingImg').src = thumbnailUrl;
                document.getElementById('existingThumbnail').style.display = 'block';
            } else {
                document.getElementById('existingThumbnail').style.display = 'none';
            }
            
            document.getElementById('videoModal').classList.add('active');
        }

        function previewThumbnail(input) {
            var preview = document.getElementById('thumbnailPreview');
            var img = document.getElementById('previewImg');
            
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    img.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            }
        }

        function toggleRemoveThumbnail() {
            var checkbox = document.getElementById('removeThumbnail');
            document.getElementById('keepThumbnail').value = checkbox.checked ? 'false' : 'true';
        }

        function confirmDelete(id) {
            if (confirm('确定要删除这个视频吗？此操作不可恢复！')) {
                window.location.href = 'video?action=delete&id=' + id;
            }
        }

        document.getElementById('videoModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
    </script>
</body>
</html>