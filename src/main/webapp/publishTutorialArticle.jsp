<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布教程文章 - War Thunder 社区</title>
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
            padding: 24px;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
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

        .btn-back {
            padding: 10px 20px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .form-card {
            background-color: #1e232a;
            border-radius: 12px;
            padding: 32px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #b0b8c1;
            font-size: 14px;
        }

        .form-group input[type="text"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            background-color: #252a32;
            border: 1px solid #3a4252;
            border-radius: 6px;
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
            min-height: 300px;
            resize: vertical;
            line-height: 1.6;
        }

        .image-upload-area {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }

        .image-upload-box {
            position: relative;
            aspect-ratio: 16/9;
            background-color: #252a32;
            border: 2px dashed #3a4252;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.2s;
        }

        .image-upload-box:hover {
            border-color: #00e0d0;
        }

        .image-upload-box input {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .image-upload-box .placeholder {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            color: #8892a5;
        }

        .image-upload-box .placeholder .icon {
            font-size: 32px;
            margin-bottom: 8px;
        }

        .image-upload-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 32px;
        }

        .btn-submit {
            flex: 1;
            padding: 14px;
            background-color: #00e0d0;
            color: #000;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-submit:hover {
            background-color: #00c2b3;
        }

        .btn-cancel {
            flex: 1;
            padding: 14px;
            background-color: #3a4252;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .tips {
            background-color: #252a32;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
        }

        .tips h3 {
            color: #00e0d0;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .tips p {
            color: #8892a5;
            font-size: 12px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📝 发布教程文章</h1>
            <a href="tutorial.jsp" class="btn-back">返回教程</a>
        </div>

        <div class="tips">
            <h3>💡 发布提示</h3>
            <p>
                • 标题和内容为必填项<br>
                • 支持 Markdown 格式（使用 ## 标题、**加粗** 等）<br>
                • 图片支持 jpg、png、gif 格式，单张最大 5MB<br>
                • 请确保内容原创或已获得授权
            </p>
        </div>

        <div class="form-card">
            <form action="publishTutorialArticle" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="title">文章标题 *</label>
                    <input type="text" id="title" name="title" placeholder="输入文章标题" required maxlength="200">
                </div>

                <div class="form-group">
                    <label for="category">文章分类</label>
                    <select id="category" name="category">
                        <option value="maps">🗺️ 地图解析</option>
                        <option value="vehicles">⚔️ 载具测评</option>
                        <option value="weakspots">🎯 车辆弱点</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="content">文章内容 *</label>
                    <textarea id="content" name="content" placeholder="输入文章内容，支持 Markdown 格式..." required></textarea>
                </div>

                <div class="form-group">
                    <label>文章图片（可选，最多6张）</label>
                    <div class="image-upload-area">
                        <div class="image-upload-box">
                            <input type="file" name="image1" accept="image/*" onchange="previewImage(this, 1)">
                            <div class="placeholder" id="placeholder1">
                                <div class="icon">📷</div>
                                <div>图片 1</div>
                            </div>
                            <img id="preview1" style="display:none;">
                        </div>
                        <div class="image-upload-box">
                            <input type="file" name="image2" accept="image/*" onchange="previewImage(this, 2)">
                            <div class="placeholder" id="placeholder2">
                                <div class="icon">📷</div>
                                <div>图片 2</div>
                            </div>
                            <img id="preview2" style="display:none;">
                        </div>
                        <div class="image-upload-box">
                            <input type="file" name="image3" accept="image/*" onchange="previewImage(this, 3)">
                            <div class="placeholder" id="placeholder3">
                                <div class="icon">📷</div>
                                <div>图片 3</div>
                            </div>
                            <img id="preview3" style="display:none;">
                        </div>
                        <div class="image-upload-box">
                            <input type="file" name="image4" accept="image/*" onchange="previewImage(this, 4)">
                            <div class="placeholder" id="placeholder4">
                                <div class="icon">📷</div>
                                <div>图片 4</div>
                            </div>
                            <img id="preview4" style="display:none;">
                        </div>
                        <div class="image-upload-box">
                            <input type="file" name="image5" accept="image/*" onchange="previewImage(this, 5)">
                            <div class="placeholder" id="placeholder5">
                                <div class="icon">📷</div>
                                <div>图片 5</div>
                            </div>
                            <img id="preview5" style="display:none;">
                        </div>
                        <div class="image-upload-box">
                            <input type="file" name="image6" accept="image/*" onchange="previewImage(this, 6)">
                            <div class="placeholder" id="placeholder6">
                                <div class="icon">📷</div>
                                <div>图片 6</div>
                            </div>
                            <img id="preview6" style="display:none;">
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel" onclick="location.href='tutorial.jsp'">取消</button>
                    <button type="submit" class="btn-submit">发布文章</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function previewImage(input, index) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('preview' + index).src = e.target.result;
                    document.getElementById('preview' + index).style.display = 'block';
                    document.getElementById('placeholder' + index).style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>