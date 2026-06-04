package service;

import dao.user_dao;
import model.ArticleModel;
import model.CommentModel;
import model.PostModel;
import model.TutorialArticleModel;
import model.VideoModel;
import model.user_model;

import java.sql.SQLException;
import java.util.ArrayList;

/**
 * user_service - 业务逻辑层（Service）
 * 
 * 【职责说明】
 * 这是项目的业务逻辑层，负责处理业务逻辑和事务管理。
 * Service层是DAO层和Controller层之间的桥梁。
 * 
 * 【架构位置】
 * Controller（控制器） -> Service（服务层） -> DAO（数据访问层） -> DB（数据库）
 * 
 * 【设计原则】
 * - 单一职责：每个方法只做一件事
 * - 解耦合：Controller不直接访问DAO，通过Service间接访问
 * - 业务封装：在Service层可以添加复杂的业务逻辑
 * 
 * 【使用场景】
 * - Controller调用Service的业务方法
 * - Service调用DAO的数据访问方法
 * - Service可以添加事务管理、缓存、日志等
 * 
 * 【本项目说明】
 * 当前项目的Service层相对简单，主要是DAO的简单封装。
 * 在更复杂的项目中，这里会包含更多的业务逻辑。
 * 
 * @author WarThunder Team
 */
public class user_service {
    
    // ==================== 用户相关服务 ====================
    
    /**
     * 用户登录验证
     * 
     * 【功能说明】
     * 验证用户邮箱和密码是否匹配
     * 
     * 【参数说明】
     * @param email 用户邮箱
     * @param password 用户密码
     * @return user_model对象，登录成功返回用户信息，失败返回id=0的对象
     * 
     * 【业务逻辑】
     * 1. 调用DAO层查询数据库
     * 2. DAO返回查询结果
     * 3. Service层直接返回结果给Controller
     */
    public user_model find_user_name_password(String email, String password) throws SQLException {
        // 创建DAO实例，调用数据访问方法
        user_dao userdao = new user_dao();
        return userdao.find_user_name_password(email,password);
    }
    
    /**
     * 用户注册
     * 
     * 【功能说明】
     * 向数据库插入新用户记录
     */
    public int insertuser(String username, String password, String email) {
        user_dao userdao = new user_dao();
        return userdao.insertuser(username,password,email);
    }
    
    /**
     * 根据ID查询用户
     */
    public user_model findUserById(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findUserById(userId);
    }
    
    /**
     * 根据用户名查询用户
     */
    public user_model findUserByUsername(String username) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findUserByUsername(username);
    }
    
    // ==================== 帖子相关服务 ====================
    
    /**
     * 查询用户的所有帖子
     */
    public ArrayList<PostModel> findPostsByUserId(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findPostsByUserId(userId);
    }
    
    /**
     * 查询所有已发布的帖子
     */
    public ArrayList<PostModel> findAllPosts() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllPosts();
    }
    
    /**
     * 查询所有帖子（管理员用）
     */
    public ArrayList<PostModel> findAllPostsForAdmin() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllPostsForAdmin();
    }
    
    /**
     * 查询帖子详情
     */
    public PostModel findPostById(int postId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findPostById(postId);
    }
    
    /**
     * 发布帖子（无图片）
     */
    public int insertPost(int userId, String title, String content) {
        user_dao userdao = new user_dao();
        return userdao.insertPost(userId, title, content);
    }
    
    /**
     * 发布帖子（带图片）
     */
    public int insertPostWithImages(int userId, String title, String content, 
                                     String image1, String image2, String image3,
                                     String image4, String image5, String image6) {
        user_dao userdao = new user_dao();
        return userdao.insertPostWithImages(userId, title, content, image1, image2, image3, image4, image5, image6);
    }
    
    /**
     * 更新帖子（无图片）
     */
    public int updatePost(int postId, String title, String content) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updatePost(postId, title, content);
    }
    
    /**
     * 更新帖子（带图片）
     */
    public int updatePostWithImages(int postId, String title, String content,
                                     String image1, String image2, String image3,
                                     String image4, String image5, String image6) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updatePostWithImages(postId, title, content, image1, image2, image3, image4, image5, image6);
    }
    
    /**
     * 删除帖子
     */
    public int deletePost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.deletePost(postId);
    }
    
    /**
     * 封禁帖子
     */
    public int banPost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.banPost(postId);
    }
    
    /**
     * 解禁帖子
     */
    public int unbanPost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.unbanPost(postId);
    }
    
    /**
     * 删除评论
     */
    public int deleteComment(int commentId) {
        user_dao userdao = new user_dao();
        return userdao.deleteComment(commentId);
    }
    
    /**
     * 统计用户发帖数量
     */
    public int getUserPostCount(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getUserPostCount(userId);
    }
    
    // ==================== 评论相关服务 ====================
    
    /**
     * 查询帖子的所有评论
     */
    public ArrayList<CommentModel> findCommentsByPostId(int postId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findCommentsByPostId(postId);
    }
    
    /**
     * 添加评论
     */
    public int insertComment(int postId, int userId, String content) {
        user_dao userdao = new user_dao();
        return userdao.insertComment(postId, userId, content);
    }
    
    /**
     * 添加回复评论
     */
    public int insertReplyComment(int postId, int userId, String content, int parentId) {
        user_dao userdao = new user_dao();
        return userdao.insertReplyComment(postId, userId, content, parentId);
    }
    
    // ==================== 用户信息管理服务 ====================
    
    /**
     * 更新用户信息
     */
    public int updateUserInfo(int userId, String username, String email) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateUserInfo(userId, username, email);
    }
    
    /**
     * 更新用户头像
     */
    public int updateAvatar(int userId, String avatarPath) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateAvatar(userId, avatarPath);
    }
    
    /**
     * 修改密码
     */
    public int changePassword(int userId, String newPassword) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.changePassword(userId, newPassword);
    }
    
    // ==================== 管理员服务 ====================
    
    /**
     * 查询所有用户
     */
    public ArrayList<user_model> findAllUsers() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllUsers();
    }
    
    /**
     * 搜索用户
     */
    public ArrayList<user_model> searchUsers(String keyword) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.searchUsers(keyword);
    }
    
    /**
     * 删除用户
     */
    public int deleteUser(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.deleteUser(userId);
    }
    
    /**
     * 更新用户角色
     */
    public int updateUserRole(int userId, int role) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateUserRole(userId, role);
    }
    
    // ==================== 文章相关服务 ====================
    
    /**
     * 查询某作者的所有文章
     */
    public ArrayList<ArticleModel> findArticlesByAuthor(String author) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findArticlesByAuthor(author);
    }
    
    /**
     * 统计用户文章数量
     */
    public int getUserArticleCount(String author) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getUserArticleCount(author);
    }
    
    // ==================== 搜索服务 ====================
    
    /**
     * 搜索帖子
     */
    public ArrayList<PostModel> searchPosts(String keyword) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.searchPosts(keyword);
    }
    
    // ==================== 视频教程相关服务 ====================
    
    /**
     * 查询所有视频教程
     */
    public ArrayList<VideoModel> findAllVideos() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllVideos();
    }
    
    /**
     * 按分类查询视频教程
     */
    public ArrayList<VideoModel> findVideosByCategory(String category) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findVideosByCategory(category);
    }
    
    /**
     * 查询视频详情
     */
    public VideoModel findVideoById(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findVideoById(id);
    }
    
    /**
     * 添加视频
     */
    public int addVideo(VideoModel video) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.addVideo(video);
    }
    
    /**
     * 更新视频
     */
    public int updateVideo(VideoModel video) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateVideo(video);
    }
    
    /**
     * 删除视频
     */
    public int deleteVideo(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.deleteVideo(id);
    }
    
    /**
     * 增加视频播放量
     */
    public int incrementViewCount(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.incrementViewCount(id);
    }
    
    /**
     * 获取精选视频
     */
    public ArrayList<VideoModel> getFeaturedVideos(int limit) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getFeaturedVideos(limit);
    }
    
    // ==================== 教程文章相关服务 ====================
    
    /**
     * 查询所有教程文章
     */
    public ArrayList<TutorialArticleModel> findAllTutorialArticles() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllTutorialArticles();
    }
    
    /**
     * 按分类查询教程文章
     */
    public ArrayList<TutorialArticleModel> findTutorialArticlesByCategory(String category) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findTutorialArticlesByCategory(category);
    }
    
    /**
     * 查询教程文章详情
     */
    public TutorialArticleModel findTutorialArticleById(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findTutorialArticleById(id);
    }
    
    /**
     * 添加教程文章
     */
    public int addTutorialArticle(TutorialArticleModel article) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.addTutorialArticle(article);
    }
    
    /**
     * 更新教程文章
     */
    public int updateTutorialArticle(TutorialArticleModel article) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateTutorialArticle(article);
    }
    
    /**
     * 删除教程文章
     */
    public int deleteTutorialArticle(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.deleteTutorialArticle(id);
    }
    
    /**
     * 增加文章阅读量
     */
    public int incrementTutorialArticleViewCount(int id) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.incrementTutorialArticleViewCount(id);
    }
    
    /**
     * 统计分类文章数量
     */
    public int getTutorialArticleCountByCategory(String category) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getTutorialArticleCountByCategory(category);
    }
    
    /**
     * 统计分类视频数量
     */
    public int getTutorialVideoCountByCategory(String category) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getTutorialVideoCountByCategory(category);
    }
    
    /**
     * 查询分类视频
     */
    public ArrayList<VideoModel> findTutorialVideosByCategory(String category) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findTutorialVideosByCategory(category);
    }
    
    // ==================== 仪表盘统计服务 ====================
    
    /**
     * 获取评论总数
     */
    public int getTotalCommentCount() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getTotalCommentCount();
    }
    
    /**
     * 获取管理员数量
     */
    public int getAdminUserCount() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getAdminUserCount();
    }
    
    /**
     * 获取被封禁帖子数量
     */
    public int getBannedPostCount() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getBannedPostCount();
    }
}
