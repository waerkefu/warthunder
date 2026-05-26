<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PostModel" %>
<%@ page import="model.user_model" %>
<%@ page import="service.user_service" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑帖子 - War Thunder 社区</title>
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

        .container {
            max-width: 800px;
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

        textarea.form-control {
            resize: vertical;
            min-height: 200px;
            font-family: inherit;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }

        .error-message {
            color: #d9232e;
            margin-bottom: 16px;
            padding: 12px;
            background-color: rgba(217, 35, 46, 0.1);
            border-radius: 4px;
        }

        .image-upload-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-top: 12px;
        }

        .image-upload-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 150px;
            border: 2px dashed #3a4252;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .image-upload-box:hover {
            border-color: #00e0d0;
            background-color: rgba(0, 224, 208, 0.05);
        }

        .image-upload-box input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .upload-icon {
            font-size: 32px;
            margin-bottom: 4px;
        }

        .image-upload-box span {
            font-size: 12px;
            color: #8892a5;
        }

        .image-upload-box.has-image {
            border-style: solid;
            border-color: #00e0d0;
        }

        .image-preview {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
        }

        .delete-image-btn {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 24px;
            height: 24px;
            background-color: rgba(217, 35, 46, 0.8);
            border: none;
            border-radius: 50%;
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
        }

        .delete-image-btn:hover {
            background-color: #d9232e;
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
        <h2 class="edit-title">编辑帖子</h2>
        
        <%
            String loginUser = (String) session.getAttribute("loginUser");
            if (loginUser == null) {
        %>
        <script>
            alert("请先登录！");
            location.href = "Login.jsp";
        </script>
        <%
                return;
            }
            
            String articleId = request.getParameter("articleId");
            if (articleId == null || articleId.isEmpty()) {
        %>
        <div class="error-message">参数错误，未指定帖子ID</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                return;
            }
            
            PostModel post = null;
            try {
                user_service us = new user_service();
                post = us.findPostById(Integer.parseInt(articleId));
                
                if (post == null || post.getId() == 0) {
        %>
        <div class="error-message">帖子不存在</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                    return;
                }
                
                if (!post.getUsername().equals(loginUser)) {
        %>
        <div class="error-message">您只能编辑自己的帖子</div>
        <button class="btn btn-secondary" onclick="location.href='profile'">返回个人中心</button>
        <%
                    return;
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
        <div class="error-message">数据库错误</div>
        <%
                return;
            }
        %>
        
        <form action="editPost" method="post" enctype="multipart/form-data">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            <input type="hidden" id="deleteImages" name="deleteImages" value="">
            
            <div class="form-group">
                <label for="title">帖子标题</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= post.getTitle() %>" required>
            </div>

            <div class="form-group">
                <label for="content">帖子内容</label>
                <textarea class="form-control" id="content" name="content" required><%= post.getContent() %></textarea>
            </div>

            <div class="form-group">
                <label>帖子图片（点击图片可删除，重新上传可替换）</label>
                <div class="image-upload-container">
                    <label class="image-upload-box <%= post.getImage1() != null ? "has-image" : "" %>">
                        <input type="file" name="image1" accept="image/*" onchange="previewImage(this, 1)">
                        <% if (post.getImage1() != null) { %>
                        <img src="<%= post.getImage1() %>" class="image-preview" alt="图片1">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(1)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片1</span>
                        <% } %>
                    </label>
                    <label class="image-upload-box <%= post.getImage2() != null ? "has-image" : "" %>">
                        <input type="file" name="image2" accept="image/*" onchange="previewImage(this, 2)">
                        <% if (post.getImage2() != null) { %>
                        <img src="<%= post.getImage2() %>" class="image-preview" alt="图片2">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(2)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片2</span>
                        <% } %>
                    </label>
                    <label class="image-upload-box <%= post.getImage3() != null ? "has-image" : "" %>">
                        <input type="file" name="image3" accept="image/*" onchange="previewImage(this, 3)">
                        <% if (post.getImage3() != null) { %>
                        <img src="<%= post.getImage3() %>" class="image-preview" alt="图片3">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(3)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片3</span>
                        <% } %>
                    </label>
                    <label class="image-upload-box <%= post.getImage4() != null ? "has-image" : "" %>">
                        <input type="file" name="image4" accept="image/*" onchange="previewImage(this, 4)">
                        <% if (post.getImage4() != null) { %>
                        <img src="<%= post.getImage4() %>" class="image-preview" alt="图片4">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(4)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片4</span>
                        <% } %>
                    </label>
                    <label class="image-upload-box <%= post.getImage5() != null ? "has-image" : "" %>">
                        <input type="file" name="image5" accept="image/*" onchange="previewImage(this, 5)">
                        <% if (post.getImage5() != null) { %>
                        <img src="<%= post.getImage5() %>" class="image-preview" alt="图片5">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(5)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片5</span>
                        <% } %>
                    </label>
                    <label class="image-upload-box <%= post.getImage6() != null ? "has-image" : "" %>">
                        <input type="file" name="image6" accept="image/*" onchange="previewImage(this, 6)">
                        <% if (post.getImage6() != null) { %>
                        <img src="<%= post.getImage6() %>" class="image-preview" alt="图片6">
                        <button type="button" class="delete-image-btn" onclick="deleteImage(6)">×</button>
                        <% } else { %>
                        <div class="upload-icon">📷</div>
                        <span>选择图片6</span>
                        <% } %>
                    </label>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary" style="flex: 1;">保存修改</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='profile'">取消</button>
            </div>
        </form>
    </div>
</div>

<script>
    var deletedImages = [];

    function previewImage(input, index) {
        var label = input.parentElement;
        var files = input.files;
        if (files.length > 0) {
            var file = files[0];
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.createElement('img');
                img.src = e.target.result;
                img.className = 'image-preview';
                
                var existingPreview = label.querySelector('.image-preview');
                if (existingPreview) {
                    label.removeChild(existingPreview);
                }
                
                var existingBtn = label.querySelector('.delete-image-btn');
                if (existingBtn) {
                    label.removeChild(existingBtn);
                }
                
                label.classList.add('has-image');
                label.appendChild(img);
                
                var deleteBtn = document.createElement('button');
                deleteBtn.className = 'delete-image-btn';
                deleteBtn.innerHTML = '×';
                deleteBtn.onclick = function() { deleteImage(index); };
                label.appendChild(deleteBtn);
                
                var idx = deletedImages.indexOf(index.toString());
                if (idx > -1) {
                    deletedImages.splice(idx, 1);
                }
            };
            reader.readAsDataURL(file);
        }
    }

    function deleteImage(index) {
        var label = document.querySelector('.image-upload-container label:nth-child(' + index + ')');
        var input = label.querySelector('input[type="file"]');
        input.value = '';
        
        var img = label.querySelector('.image-preview');
        if (img) {
            label.removeChild(img);
        }
        
        var btn = label.querySelector('.delete-image-btn');
        if (btn) {
            label.removeChild(btn);
        }
        
        label.classList.remove('has-image');
        
        var icon = document.createElement('div');
        icon.className = 'upload-icon';
        icon.innerHTML = '📷';
        label.appendChild(icon);
        
        var span = document.createElement('span');
        span.innerHTML = '选择图片' + index;
        label.appendChild(span);
        
        if (deletedImages.indexOf(index.toString()) === -1) {
            deletedImages.push(index.toString());
        }
        
        document.getElementById('deleteImages').value = deletedImages.join(',');
    }
</script>
</body>
</html>