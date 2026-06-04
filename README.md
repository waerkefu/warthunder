# War Thunder 社区论坛

> 一个功能完善的战争雷霆游戏社区论坛系统，支持帖子发布、教程视频、教程文章、搜索等功能。

---

## 目录

- [快速开始](#快速开始)
- [核心特性](#核心特性)
- [项目结构](#项目结构)
- [技术栈](#技术栈)
- [版本](#版本)

---

## 快速开始

### 环境要求

- **JDK**: JDK 8 或更高版本
- **Web服务器**: Apache Tomcat 8.5 或更高版本
- **数据库**: MySQL 5.7 或更高版本
- **浏览器**: Chrome, Firefox, Edge, Safari 等现代浏览器

### 安装与配置

```bash
# 1. 克隆仓库
git clone https://github.com/waerkefu/warthunder.git
cd warthunder

# 2. 创建数据库
# 登录MySQL，执行以下命令创建数据库
CREATE DATABASE warthunder_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE warthunder_db;

# 3. 导入数据库表结构
# 根据 database/ 目录下的 SQL 文件创建表

# 4. 配置数据库连接
# 编辑 src/main/java/db/DBHelper.java 中的数据库连接信息
DB_HOST=localhost
DB_PORT=3306
DB_NAME=warthunder_db
DB_USER=your_username
DB_PASSWORD=your_password

# 5. 部署到Tomcat
# 将项目打包为 WAR 文件并部署到 Tomcat webapps 目录

# 6. 访问应用
# 打开浏览器访问 http://localhost:8080/your-project-name
```

> **首次使用**：管理员账号请联系系统管理员创建，或直接在数据库中插入用户记录。

---

## 核心特性

### 用户系统

- **用户注册登录**：完整的用户认证系统，支持邮箱注册和登录
- **个人中心**：用户可以管理个人信息、修改头像、查看发帖记录
- **权限管理**：支持管理员、版主、普通用户三种角色，不同权限访问不同功能

### 论坛功能

- **帖子发布**：用户可以发布带图片的帖子，支持多图上传
- **评论系统**：支持帖子评论和回复功能
- **图片上传**：发布帖子时支持上传最多6张图片
- **用户权限**：管理员和版主可以管理（删除/编辑）帖子和评论

### 教程中心

- **视频教程**：集成Bilibili视频，支持视频分类管理（地图解析、载具测评、车辆弱点）
- **教程文章**：支持发布图文教程文章，可分类查看
- **分类浏览**：用户可以按分类筛选，查看全部内容或特定分类下的教程
- **缩略图上传**：为视频和文章提供缩略图展示

### 搜索功能

- **帖子搜索**：支持按关键词搜索论坛帖子
- **用户搜索**：管理员可以搜索用户账号
- **实时结果**：快速返回搜索结果页面

### 战绩查询

- **集成外部服务**：提供战绩查询入口，链接到 statshark.net
- **官方链接**：方便用户访问 War Thunder 官网

---

## 项目结构

```
项目根目录/
├── src/main/
│   ├── java/
│   │   ├── controller/          # Servlet控制器，处理HTTP请求
│   │   │   ├── AdminController.java        # 管理员控制器
│   │   │   ├── CommentController.java       # 评论控制器
│   │   │   ├── PostController.java          # 帖子控制器
│   │   │   ├── SearchController.java        # 搜索控制器
│   │   │   ├── TutorialArticleController.java    # 教程文章控制器
│   │   │   ├── VideoController.java          # 视频控制器
│   │   │   └── user_controller.java         # 用户控制器
│   │   │
│   │   ├── dao/                 # 数据访问层
│   │   │   └── user_dao.java     # 数据库操作类
│   │   │
│   │   ├── db/                   # 数据库配置
│   │   │   └── DBHelper.java     # 数据库连接工具类
│   │   │
│   │   ├── model/               # 数据模型
│   │   │   ├── user_model.java   # 用户模型
│   │   │   ├── PostModel.java    # 帖子模型
│   │   │   ├── CommentModel.java # 评论模型
│   │   │   ├── VideoModel.java   # 视频模型
│   │   │   └── TutorialArticleModel.java  # 教程文章模型
│   │   │
│   │   └── service/              # 业务逻辑层
│   │       └── user_service.java # 业务服务类
│   │
│   └── webapp/                  # Web资源
│       ├── index.jsp            # 论坛首页
│       ├── tutorial.jsp         # 教程中心首页
│       ├── Login.jsp            # 登录页面
│       ├── register.jsp         # 注册页面
│       ├── profile.jsp          # 个人中心
│       ├── searchResult.jsp      # 搜索结果页
│       ├── adminVideos.jsp      # 视频管理页面
│       └── static/              # 静态资源
│           ├── images/          # 网站图片
│           └── upload/          # 上传文件存储
│
├── database/                    # 数据库脚本
│   ├── tutorial_articles.sql    # 教程文章表结构
│   └── tutorial_videos.sql      # 视频表结构
│
├── logs/                        # 开发日志
│   └── *.md                     # 各版本更新日志
│
├── pom.xml                      # Maven项目配置
├── CHANGELOG.md                 # 变更日志
└── README.md                    # 项目说明文档
```

---

## 技术栈

### 后端技术

- **语言**: Java 8
- **框架**: 原生 Java Web (Servlet/JSP)
- **数据库**: MySQL 8.0
- **JDBC驱动**: MySQL Connector Java 8.0.25

### 前端技术

- **页面**: HTML5, JSP
- **样式**: CSS3 (原生CSS)
- **交互**: 原生 JavaScript
- **图标**: Emoji 表情符号

### 开发工具

- **IDE**: IntelliJ IDEA
- **版本控制**: Git
- **构建工具**: Maven
- **Web服务器**: Apache Tomcat

### 第三方服务

- **Bilibili**: 视频托管和播放
- **statshark.net**: 战绩查询服务
- **warthunder.com**: 官方网站链接

---

## 功能演示

### 首页论坛
- 浏览所有帖子
- 发布新帖子（支持图片）
- 评论和回复帖子

### 教程中心
- 查看全部教程内容
- 按分类筛选（地图解析、载具测评、车辆弱点）
- 播放视频教程
- 阅读图文教程
- 视频和文章同时展示

### 管理员功能
- 用户管理
- 帖子管理
- 评论管理
- 视频管理

---

## 版本

当前版本: **v1.4.0** (2026-05-31)

完整版本历史请查看 [Git提交历史](logs/Git提交历史_2026-05-31.md)

### 版本更新

- **v1.4.0 (2026-05-31)**: 完善教程功能，添加分类筛选、全部内容展示、优化UI
- **v1.3.0 (2026-05-30)**: 添加教程视频功能，Bilibili视频集成
- **v1.2.0 (2026-05-28)**: 添加搜索功能
- **v1.1.0 (2026-05-27)**: 添加图片功能和战绩查询
- **v1.0.0 (2026-05-26)**: 基础论坛功能

---

## 开发者

**作者**: waerkefu  
**项目类型**: Java Web 作业项目  
**应用场景**: War Thunder 游戏社区论坛

---

## 许可证

本项目仅供学习和教育目的使用。

---

**最后更新**: 2026-05-31
