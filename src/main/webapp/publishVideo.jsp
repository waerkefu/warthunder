<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>发布视频</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        .form-group input[type="text"]:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #4a90d9;
            outline: none;
        }
        .form-group textarea {
            height: 120px;
            resize: vertical;
        }
        .form-group input[type="file"] {
            border: none;
            padding: 0;
        }
        .btn-submit {
            width: 100%;
            padding: 14px;
            background-color: #4a90d9;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-submit:hover {
            background-color: #3a7bc8;
        }
        .btn-back {
            display: inline-block;
            padding: 10px 20px;
            background-color: #6c757d;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 20px;
            transition: background-color 0.3s;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
        .tip {
            color: #999;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="tutorial.jsp" class="btn-back">← 返回教程页面</a>
        <h1>发布视频教程</h1>
        
        <form action="publishVideo" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="bvid">视频BV号 <span style="color:red;">*</span></label>
                <input type="text" id="bvid" name="bvid" placeholder="请输入B站视频BV号，格式如：BV1xx411c7mZ" required>
                <div class="tip">请输入完整的BV号，系统将自动解析视频信息</div>
            </div>
            
            <div class="form-group">
                <label for="title">视频标题 <span style="color:red;">*</span></label>
                <input type="text" id="title" name="title" placeholder="请输入视频标题" required>
            </div>
            
            <div class="form-group">
                <label for="description">视频简介</label>
                <textarea id="description" name="description" placeholder="请输入视频简介（可选）"></textarea>
            </div>
            
            <div class="form-group">
                <label for="category">分类</label>
                <select id="category" name="category">
                    <option value="maps">地图制作</option>
                    <option value="resources">资源管理</option>
                    <option value="survival">生存技巧</option>
                    <option value="mods">模组教程</option>
                    <option value="other">其他</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="author">作者</label>
                <input type="text" id="author" name="author" placeholder="视频作者（默认使用用户名）">
            </div>
            
            <div class="form-group">
                <label for="thumbnail">缩略图</label>
                <input type="file" id="thumbnail" name="thumbnail" accept="image/*">
                <div class="tip">支持JPG、PNG格式，建议尺寸：1280×720</div>
            </div>
            
            <button type="submit" class="btn-submit">发布视频</button>
        </form>
    </div>
</body>
</html>