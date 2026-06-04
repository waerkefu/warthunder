package dao;

import db.DBHelper;
import model.ArticleModel;
import model.CommentModel;
import model.PostModel;
import model.TutorialArticleModel;
import model.VideoModel;
import model.user_model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * user_dao - 数据访问层（Data Access Object）
 * 
 * 【职责说明】
 * 这是项目的数据访问层，负责所有与数据库交互的操作。
 * 每个方法都对应一个具体的数据库操作（CRUD：增删改查）
 * 
 * 【架构说明】
 * Controller（控制器） -> Service（服务层） -> DAO（数据访问层） -> DB（数据库）
 * 
 * 【使用方法】
 * 1. Controller调用Service的业务方法
 * 2. Service调用DAO的数据访问方法
 * 3. DAO使用DBHelper执行SQL语句
 * 4. DBHelper返回结果给DAO
 * 5. DAO将结果封装成Java对象返回给Service
 * 
 * 【命名规范】
 * - find_xxx: 查询操作，返回数据
 * - insert_xxx: 插入操作，返回受影响的行数
 * - update_xxx: 更新操作，返回受影响的行数
 * - delete_xxx: 删除操作，返回受影响的行数
 * 
 * @author WarThunder Team
 */
public class user_dao {

    // ==================== 用户相关方法 ====================
    
    /**
     * find_user_name_password - 用户登录验证
     * 
     * 【功能说明】
     * 根据用户邮箱和密码查询用户信息，用于登录验证
     * 
     * 【参数说明】
     * @param email 用户邮箱（登录账号）
     * @param password 用户密码
     * @return user_model对象，如果未找到返回id=0的用户对象
     * 
     * 【SQL语句解析】
     * SELECT * FROM user WHERE email = ? AND password = ?
     * - 查询user表中email和password都匹配的用户
     * - ? 是占位符，由后面的参数替换
     * 
     * 【返回值处理】
     * 如果找到用户，返回包含所有用户信息的user_model对象
     * 如果未找到，user_id会保持为初始值0，Controller据此判断登录失败
     */
    public user_model find_user_name_password(String email, String password) throws SQLException {
        // 1. 创建DBHelper实例（数据库连接）
        DBHelper db = new DBHelper();
        
        // 2. 编写SQL语句，使用?作为占位符
        String sql = "select * from user where email = ? and password = ?";
        
        // 3. 创建用户对象，用于封装查询结果
        user_model user = new user_model();
        
        // 4. 执行查询，返回结果集
        // executeQuery方法会自动处理占位符，将email和password替换到?位置
        ResultSet rs = db.executeQuery(sql, email, password);
        
        // 5. 遍历结果集（while循环，因为可能有多条记录）
        while (rs.next()){
            // rs.getInt("id")：获取id字段的整数值
            // rs.getString("username")：获取username字段的字符串值
            // 以此类推，getXXX方法用于获取不同类型的数据
            user.setUser_id(rs.getInt("id"));
            user.setUser_name(rs.getString("username"));
            user.setUser_password(rs.getString("password"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getInt("role"));
            user.setAvatar(rs.getString("avatar"));
        }
        
        // 6. 关闭数据库连接（重要！防止资源泄漏）
        db.close();
        
        // 7. 返回用户对象
        return user;
    }
    
    /**
     * insertuser - 用户注册
     * 
     * 【功能说明】
     * 向数据库插入新的用户记录
     * 
     * 【参数说明】
     * @param username 用户名
     * @param password 密码
     * @param email 邮箱
     * @return 影响的行数（1表示插入成功，0表示失败）
     * 
     * 【SQL语句解析】
     * INSERT INTO user(username, password, email, role) VALUES(?, ?, ?, 1)
     * - INSERT INTO: 插入数据到指定表
     * - (username, password, email, role): 要插入的字段列表
     * - VALUES(?, ?, ?, 1): 对应的值，role固定为1（普通用户角色）
     */
    public int insertuser(String username, String password, String email) {
        DBHelper db = new DBHelper();
        String sql = "insert into user(username,password,email,role) values(?,?,?,2)";  // role=2 表示普通用户
        
        // executeUpdate用于执行INSERT、UPDATE、DELETE等写操作
        // 返回值是影响的行数
        int i = db.executeUpdate(sql, username, password, email);
        db.close();
        return i;
    }
    
    /**
     * findUserById - 根据ID查询用户
     * 
     * 【功能说明】
     * 根据用户ID查询单个用户的详细信息
     * 
     * 【参数说明】
     * @param userId 用户ID（数据库主键）
     * @return user_model对象，如果未找到返回空对象
     */
    public user_model findUserById(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select * from user where id = ?";
        user_model user = new user_model();
        ResultSet rs = db.executeQuery(sql, userId);
        
        // 因为ID是主键，最多只有一条记录，所以用if判断而不是while
        while (rs.next()){
            user.setUser_id(rs.getInt("id"));
            user.setUser_name(rs.getString("username"));
            user.setUser_password(rs.getString("password"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getInt("role"));
            user.setAvatar(rs.getString("avatar"));
        }
        db.close();
        return user;
    }
    
    /**
     * findUserByUsername - 根据用户名查询用户
     * 
     * 【功能说明】
     * 根据用户名查询用户信息（用于检查用户名是否已存在）
     */
    public user_model findUserByUsername(String username) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select * from user where username = ?";
        user_model user = new user_model();
        ResultSet rs = db.executeQuery(sql, username);
        while (rs.next()){
            user.setUser_id(rs.getInt("id"));
            user.setUser_name(rs.getString("username"));
            user.setUser_password(rs.getString("password"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getInt("role"));
            user.setAvatar(rs.getString("avatar"));
        }
        db.close();
        return user;
    }
    
    // ==================== 帖子相关方法 ====================
    
    /**
     * findPostsByUserId - 查询某个用户的所有帖子
     * 
     * 【功能说明】
     * 根据用户ID查询该用户发布的所有帖子，按时间倒序排列
     * 
     * 【SQL语句解析】
     * SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.user_id = ? ORDER BY p.create_time DESC
     * 
     * - SELECT p.*, u.username: 查询post表的所有字段，以及user表的username
     * - FROM post p: 主表是post表，别名为p
     * - JOIN user u: 关联user表，别名为u
     * - ON p.user_id = u.id: 关联条件，post的user_id等于user的id
     * - WHERE p.user_id = ?: 筛选条件，按用户ID筛选
     * - ORDER BY p.create_time DESC: 按创建时间倒序（最新的在前）
     * 
     * 【返回值】
     * 返回ArrayList<PostModel>，包含该用户的所有帖子
     */
    public ArrayList<PostModel> findPostsByUserId(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.user_id = ? ORDER BY p.create_time DESC";
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql, userId);
        
        // 遍历结果集，每条记录创建一个PostModel对象，添加到list中
        while (rs.next()){
            PostModel post = new PostModel();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));  // 来自关联的user表
            post.setCreate_time(rs.getString("create_time"));
            list.add(post);  // 将对象添加到列表
        }
        db.close();
        return list;
    }
    
    /**
     * findAllPosts - 查询所有已发布的帖子
     * 
     * 【功能说明】
     * 查询所有status=1的帖子（未删除的帖子），用于论坛首页展示
     */
    public ArrayList<PostModel> findAllPosts() throws SQLException {
        DBHelper db = new DBHelper();
        
        // status = 1 表示帖子已发布（未删除）
        // status = 0 表示帖子已删除或被屏蔽
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.status = 1 ORDER BY p.create_time DESC";
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql);
        
        while (rs.next()){
            PostModel post = new PostModel();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setCreate_time(rs.getString("create_time"));
            post.setStatus(rs.getInt("status"));
            post.setImage1(rs.getString("image1"));
            post.setImage2(rs.getString("image2"));
            post.setImage3(rs.getString("image3"));
            list.add(post);
        }
        db.close();
        return list;
    }
    
    /**
     * findAllPostsForAdmin - 查询所有帖子（管理员用）
     * 
     * 【功能说明】
     * 查询所有帖子，不考虑status状态，用于管理员后台管理
     */
    public ArrayList<PostModel> findAllPostsForAdmin() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id ORDER BY p.create_time DESC";
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql);
        while (rs.next()){
            PostModel post = new PostModel();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setCreate_time(rs.getString("create_time"));
            post.setStatus(rs.getInt("status"));
            post.setImage1(rs.getString("image1"));
            post.setImage2(rs.getString("image2"));
            post.setImage3(rs.getString("image3"));
            list.add(post);
        }
        db.close();
        return list;
    }
    
    /**
     * findPostById - 根据ID查询帖子详情
     * 
     * 【功能说明】
     * 查询单个帖子的详细信息，包括6张图片
     */
    public PostModel findPostById(int postId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.id = ?";
        PostModel post = new PostModel();
        ResultSet rs = db.executeQuery(sql, postId);
        while (rs.next()){
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setCreate_time(rs.getString("create_time"));
            post.setStatus(rs.getInt("status"));
            post.setImage1(rs.getString("image1"));
            post.setImage2(rs.getString("image2"));
            post.setImage3(rs.getString("image3"));
            post.setImage4(rs.getString("image4"));
            post.setImage5(rs.getString("image5"));
            post.setImage6(rs.getString("image6"));
        }
        db.close();
        return post;
    }
    
    /**
     * insertPost - 发布新帖子（无图片）
     */
    public int insertPost(int userId, String title, String content) {
        DBHelper db = new DBHelper();
        String sql = "insert into post(title,content,user_id) values(?,?,?)";
        int i = db.executeUpdate(sql, title, content, userId);
        db.close();
        return i;
    }
    
    /**
     * insertPostWithImages - 发布新帖子（带图片）
     * 
     * 【功能说明】
     * 支持最多6张图片的帖子发布
     * 图片路径存储在image1-image6字段中
     */
    public int insertPostWithImages(int userId, String title, String content, 
                                     String image1, String image2, String image3,
                                     String image4, String image5, String image6) {
        DBHelper db = new DBHelper();
        String sql = "insert into post(title,content,user_id,image1,image2,image3,image4,image5,image6) values(?,?,?,?,?,?,?,?,?)";
        int i = db.executeUpdate(sql, title, content, userId, image1, image2, image3, image4, image5, image6);
        db.close();
        return i;
    }
    
    /**
     * updatePost - 更新帖子内容（无图片）
     */
    public int updatePost(int postId, String title, String content) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update post set title = ?, content = ? where id = ?";
        int i = db.executeUpdate(sql, title, content, postId);
        db.close();
        return i;
    }
    
    /**
     * updatePostWithImages - 更新帖子内容（带图片）
     */
    public int updatePostWithImages(int postId, String title, String content,
                                     String image1, String image2, String image3,
                                     String image4, String image5, String image6) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update post set title = ?, content = ?, image1 = ?, image2 = ?, image3 = ?, image4 = ?, image5 = ?, image6 = ? where id = ?";
        int i = db.executeUpdate(sql, title, content, image1, image2, image3, image4, image5, image6, postId);
        db.close();
        return i;
    }
    
    /**
     * deletePost - 删除帖子（物理删除）
     */
    public int deletePost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "delete from post where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }
    
    /**
     * banPost - 封禁帖子（逻辑删除）
     * 
     * 【说明】
     * 这里采用逻辑删除（修改status=0）而非物理删除（DELETE语句）
     * 逻辑删除的好处是数据可以恢复，适合需要保留数据的场景
     */
    public int banPost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "update post set status = 0 where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }
    
    /**
     * unbanPost - 解禁帖子（恢复帖子）
     */
    public int unbanPost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "update post set status = 1 where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }
    
    /**
     * deleteComment - 删除评论
     */
    public int deleteComment(int commentId) {
        DBHelper db = new DBHelper();
        String sql = "delete from comment where id = ?";
        int i = db.executeUpdate(sql, commentId);
        db.close();
        return i;
    }
    
    /**
     * getUserPostCount - 统计用户发帖数量
     * 
     * 【功能说明】
     * 使用COUNT(*)函数统计指定用户发布的帖子总数
     * 
     * 【SQL语句解析】
     * SELECT count(*) as count FROM post WHERE user_id = ?
     * - count(*): 统计所有记录的数量
     * - as count: 给结果起个别名叫count，方便获取
     */
    public int getUserPostCount(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select count(*) as count from post where user_id = ?";
        ResultSet rs = db.executeQuery(sql, userId);
        int count = 0;
        while (rs.next()){
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    // ==================== 评论相关方法 ====================
    
    /**
     * findCommentsByPostId - 查询帖子的所有评论
     * 
     * 【SQL语句解析】
     * SELECT c.*, u.username, u.avatar, p.username as parent_username 
     * FROM comment c 
     * JOIN user u ON c.user_id = u.id 
     * LEFT JOIN comment pc ON c.parent_id = pc.id 
     * LEFT JOIN user p ON pc.user_id = p.id 
     * WHERE c.post_id = ? 
     * ORDER BY c.parent_id ASC, c.create_time ASC
     * 
     * - LEFT JOIN: 左外连接，即使没有匹配的记录也返回左表数据
     * - c.parent_id: 评论的父ID（用于回复功能）
     * - ORDER BY c.parent_id ASC: 先按父评论ID排序（父评论在前）
     * - c.create_time ASC: 再按创建时间排序（早的在前）
     */
    public ArrayList<CommentModel> findCommentsByPostId(int postId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT c.*, u.username, u.avatar, p.username as parent_username FROM comment c JOIN user u ON c.user_id = u.id LEFT JOIN comment pc ON c.parent_id = pc.id LEFT JOIN user p ON pc.user_id = p.id WHERE c.post_id = ? ORDER BY c.parent_id ASC, c.create_time ASC";
        ArrayList<CommentModel> list = new ArrayList<CommentModel>();
        ResultSet rs = db.executeQuery(sql, postId);
        while (rs.next()){
            CommentModel comment = new CommentModel();
            comment.setId(rs.getInt("id"));
            comment.setPost_id(rs.getInt("post_id"));
            comment.setUser_id(rs.getInt("user_id"));
            comment.setUsername(rs.getString("username"));
            comment.setAvatar(rs.getString("avatar"));
            comment.setContent(rs.getString("content"));
            comment.setCreate_time(rs.getString("create_time"));
            comment.setParent_id(rs.getInt("parent_id"));
            comment.setParent_username(rs.getString("parent_username"));
            list.add(comment);
        }
        db.close();
        return list;
    }
    
    /**
     * insertComment - 添加评论
     */
    public int insertComment(int postId, int userId, String content) {
        DBHelper db = new DBHelper();
        String sql = "insert into comment(post_id,user_id,content) values(?,?,?)";
        int i = db.executeUpdate(sql, postId, userId, content);
        db.close();
        return i;
    }
    
    /**
     * insertReplyComment - 添加回复评论
     * 
     * 【参数说明】
     * @param parentId 回复的目标评论ID
     * 
     * 【parent_id说明】
     * - 如果是直接评论帖子，parent_id = 0
     * - 如果是回复某条评论，parent_id = 被回复的评论ID
     */
    public int insertReplyComment(int postId, int userId, String content, int parentId) {
        DBHelper db = new DBHelper();
        String sql = "insert into comment(post_id,user_id,content,parent_id) values(?,?,?,?)";
        int i = db.executeUpdate(sql, postId, userId, content, parentId);
        db.close();
        return i;
    }
    
    // ==================== 用户信息管理 ====================
    
    /**
     * updateUserInfo - 更新用户基本信息
     */
    public int updateUserInfo(int userId, String username, String email) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set username = ?, email = ? where id = ?";
        int i = db.executeUpdate(sql, username, email, userId);
        db.close();
        return i;
    }
    
    /**
     * updateAvatar - 更新用户头像
     */
    public int updateAvatar(int userId, String avatarPath) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set avatar = ? where id = ?";
        int i = db.executeUpdate(sql, avatarPath, userId);
        db.close();
        return i;
    }
    
    /**
     * changePassword - 修改密码
     */
    public int changePassword(int userId, String newPassword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set password = ? where id = ?";
        int i = db.executeUpdate(sql, newPassword, userId);
        db.close();
        return i;
    }
    
    // ==================== 管理员功能 ====================
    
    /**
     * findAllUsers - 查询所有用户
     * 
     * 【ORDER BY说明】
     * ORDER BY role ASC, id DESC
     * - 先按role升序排列（管理员role=0排在前，普通人role=1排在后）
     * - 再按id降序排列（id大的在前）
     */
    public ArrayList<user_model> findAllUsers() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM user ORDER BY role ASC, id DESC";
        ArrayList<user_model> list = new ArrayList<user_model>();
        ResultSet rs = db.executeQuery(sql);
        while (rs.next()){
            user_model user = new user_model();
            user.setUser_id(rs.getInt("id"));
            user.setUser_name(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getInt("role"));
            user.setAvatar(rs.getString("avatar"));
            list.add(user);
        }
        db.close();
        return list;
    }
    
    /**
     * searchUsers - 搜索用户
     * 
     * 【LIKE语句说明】
     * WHERE username LIKE ? OR email LIKE ?
     * - LIKE: 模糊匹配关键字
     * - %keyword%: 匹配包含keyword的任何字符串
     * - 例如："%张%" 可以匹配"张三"、"张先生"等
     */
    public ArrayList<user_model> searchUsers(String keyword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM user WHERE username LIKE ? OR email LIKE ? ORDER BY role ASC, id DESC";
        String likeKeyword = "%" + keyword + "%";  // 添加%实现模糊匹配
        ArrayList<user_model> list = new ArrayList<user_model>();
        ResultSet rs = db.executeQuery(sql, likeKeyword, likeKeyword);
        while (rs.next()){
            user_model user = new user_model();
            user.setUser_id(rs.getInt("id"));
            user.setUser_name(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setRole(rs.getInt("role"));
            user.setAvatar(rs.getString("avatar"));
            list.add(user);
        }
        db.close();
        return list;
    }
    
    /**
     * deleteUser - 删除用户
     */
    public int deleteUser(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM user WHERE id = ?";
        int i = db.executeUpdate(sql, userId);
        db.close();
        return i;
    }
    
    /**
     * updateUserRole - 更新用户角色
     * 
     * 【角色说明】
     * role = 0: 管理员
     * role = 1: 普通用户
     */
    public int updateUserRole(int userId, int role) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE user SET role = ? WHERE id = ?";
        int i = db.executeUpdate(sql, role, userId);
        db.close();
        return i;
    }
    
    // ==================== 文章相关方法 ====================
    
    /**
     * findArticlesByAuthor - 查询某作者的所有文章
     */
    public ArrayList<ArticleModel> findArticlesByAuthor(String author) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select * from article where author = ? order by update_time desc";
        ArrayList<ArticleModel> list = new ArrayList<ArticleModel>();
        ResultSet rs = db.executeQuery(sql, author);
        while (rs.next()){
            ArticleModel am = new ArticleModel();
            am.setId(rs.getInt("id"));
            am.setAuthor(rs.getString("author"));
            am.setTitle(rs.getString("title"));
            am.setContent(rs.getString("content"));
            am.setUpdate_time(rs.getString("update_time"));
            list.add(am);
        }
        db.close();
        return list;
    }
    
    /**
     * getUserArticleCount - 统计用户文章数量
     */
    public int getUserArticleCount(String author) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select count(*) as count from article where author = ?";
        ResultSet rs = db.executeQuery(sql, author);
        int count = 0;
        while (rs.next()){
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    // ==================== 搜索功能 ====================
    
    /**
     * searchPosts - 搜索帖子
     * 
     * 【搜索范围】
     * - 帖子标题（title）中包含关键字
     * - 帖子内容（content）中包含关键字
     * - 作者用户名（username）中包含关键字
     * 使用OR连接，满足任一条件即可
     */
    public ArrayList<PostModel> searchPosts(String keyword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.title LIKE ? OR p.content LIKE ? OR u.username LIKE ? ORDER BY p.create_time DESC";
        String likeKeyword = "%" + keyword + "%";  // 模糊匹配
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql, likeKeyword, likeKeyword, likeKeyword);
        while (rs.next()){
            PostModel post = new PostModel();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setCreate_time(rs.getString("create_time"));
            post.setStatus(rs.getInt("status"));
            post.setImage1(rs.getString("image1"));
            post.setImage2(rs.getString("image2"));
            post.setImage3(rs.getString("image3"));
            list.add(post);
        }
        db.close();
        return list;
    }
    
    // ==================== 视频教程相关方法 ====================
    
    /**
     * findAllVideos - 查询所有视频教程
     */
    public ArrayList<VideoModel> findAllVideos() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_videos ORDER BY create_time DESC";
        ArrayList<VideoModel> list = new ArrayList<VideoModel>();
        ResultSet rs = db.executeQuery(sql);
        while (rs.next()){
            VideoModel video = new VideoModel();
            video.setId(rs.getInt("id"));
            video.setBvid(rs.getString("bvid"));
            video.setTitle(rs.getString("title"));
            video.setDescription(rs.getString("description"));
            video.setThumbnailUrl(rs.getString("thumbnail_url"));
            video.setCategory(rs.getString("category"));
            video.setViewCount(rs.getInt("view_count"));
            video.setLikes(rs.getInt("likes"));
            video.setAuthor(rs.getString("author"));
            video.setCreateTime(rs.getString("create_time"));
            list.add(video);
        }
        db.close();
        return list;
    }
    
    /**
     * findVideosByCategory - 按分类查询视频教程
     */
    public ArrayList<VideoModel> findVideosByCategory(String category) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_videos WHERE category = ? ORDER BY create_time DESC";
        ArrayList<VideoModel> list = new ArrayList<VideoModel>();
        ResultSet rs = db.executeQuery(sql, category);
        while (rs.next()){
            VideoModel video = new VideoModel();
            video.setId(rs.getInt("id"));
            video.setBvid(rs.getString("bvid"));
            video.setTitle(rs.getString("title"));
            video.setDescription(rs.getString("description"));
            video.setThumbnailUrl(rs.getString("thumbnail_url"));
            video.setCategory(rs.getString("category"));
            video.setViewCount(rs.getInt("view_count"));
            video.setLikes(rs.getInt("likes"));
            video.setAuthor(rs.getString("author"));
            video.setCreateTime(rs.getString("create_time"));
            list.add(video);
        }
        db.close();
        return list;
    }
    
    /**
     * findVideoById - 根据ID查询视频详情
     */
    public VideoModel findVideoById(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_videos WHERE id = ?";
        ResultSet rs = db.executeQuery(sql, id);
        VideoModel video = null;
        if (rs.next()){
            video = new VideoModel();
            video.setId(rs.getInt("id"));
            video.setBvid(rs.getString("bvid"));
            video.setTitle(rs.getString("title"));
            video.setDescription(rs.getString("description"));
            video.setThumbnailUrl(rs.getString("thumbnail_url"));
            video.setCategory(rs.getString("category"));
            video.setViewCount(rs.getInt("view_count"));
            video.setLikes(rs.getInt("likes"));
            video.setAuthor(rs.getString("author"));
            video.setCreateTime(rs.getString("create_time"));
        }
        db.close();
        return video;
    }
    
    /**
     * addVideo - 添加视频教程
     */
    public int addVideo(VideoModel video) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "INSERT INTO tutorial_videos (bvid, title, description, thumbnail_url, category, author) VALUES (?, ?, ?, ?, ?, ?)";
        int result = db.executeUpdate(sql, video.getBvid(), video.getTitle(), video.getDescription(), video.getThumbnailUrl(), video.getCategory(), video.getAuthor());
        db.close();
        return result;
    }
    
    /**
     * updateVideo - 更新视频信息
     */
    public int updateVideo(VideoModel video) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_videos SET bvid = ?, title = ?, description = ?, thumbnail_url = ?, category = ?, author = ? WHERE id = ?";
        int result = db.executeUpdate(sql, video.getBvid(), video.getTitle(), video.getDescription(), video.getThumbnailUrl(), video.getCategory(), video.getAuthor(), video.getId());
        db.close();
        return result;
    }
    
    /**
     * deleteVideo - 删除视频
     */
    public int deleteVideo(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM tutorial_videos WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }
    
    /**
     * incrementViewCount - 增加视频播放量
     * 
     * 【SQL语句解析】
     * UPDATE tutorial_videos SET view_count = view_count + 1 WHERE id = ?
     * - view_count = view_count + 1: 在原有基础上加1
     */
    public int incrementViewCount(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_videos SET view_count = view_count + 1 WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }
    
    /**
     * getFeaturedVideos - 获取精选视频（按播放量和点赞数排序）
     * 
     * 【LIMIT说明】
     * LIMIT ?: 限制返回的记录数量
     * ? 由参数limit指定
     */
    public ArrayList<VideoModel> getFeaturedVideos(int limit) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_videos ORDER BY view_count DESC, likes DESC LIMIT ?";
        ArrayList<VideoModel> list = new ArrayList<VideoModel>();
        ResultSet rs = db.executeQuery(sql, limit);
        while (rs.next()){
            VideoModel video = new VideoModel();
            video.setId(rs.getInt("id"));
            video.setBvid(rs.getString("bvid"));
            video.setTitle(rs.getString("title"));
            video.setDescription(rs.getString("description"));
            video.setThumbnailUrl(rs.getString("thumbnail_url"));
            video.setCategory(rs.getString("category"));
            video.setViewCount(rs.getInt("view_count"));
            video.setLikes(rs.getInt("likes"));
            video.setAuthor(rs.getString("author"));
            video.setCreateTime(rs.getString("create_time"));
            list.add(video);
        }
        db.close();
        return list;
    }
    
    // ==================== 教程文章相关方法 ====================
    
    /**
     * findAllTutorialArticles - 查询所有教程文章
     * 
     * 【status字段说明】
     * status = 1: 已发布（显示给用户）
     * status = 0: 未发布或已删除（不显示）
     */
    public ArrayList<TutorialArticleModel> findAllTutorialArticles() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_articles WHERE status = 1 ORDER BY create_time DESC";
        ArrayList<TutorialArticleModel> list = new ArrayList<TutorialArticleModel>();
        ResultSet rs = db.executeQuery(sql);
        while (rs.next()) {
            TutorialArticleModel article = new TutorialArticleModel();
            article.setId(rs.getInt("id"));
            article.setTitle(rs.getString("title"));
            article.setContent(rs.getString("content"));
            article.setCategory(rs.getString("category"));
            article.setUserId(rs.getInt("user_id"));
            article.setUsername(rs.getString("username"));
            article.setImage1(rs.getString("image1"));
            article.setImage2(rs.getString("image2"));
            article.setImage3(rs.getString("image3"));
            article.setImage4(rs.getString("image4"));
            article.setImage5(rs.getString("image5"));
            article.setImage6(rs.getString("image6"));
            article.setViewCount(rs.getInt("view_count"));
            article.setStatus(rs.getInt("status"));
            article.setCreateTime(rs.getString("create_time"));
            list.add(article);
        }
        db.close();
        return list;
    }
    
    /**
     * findTutorialArticlesByCategory - 按分类查询教程文章
     */
    public ArrayList<TutorialArticleModel> findTutorialArticlesByCategory(String category) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_articles WHERE category = ? AND status = 1 ORDER BY create_time DESC";
        ArrayList<TutorialArticleModel> list = new ArrayList<TutorialArticleModel>();
        ResultSet rs = db.executeQuery(sql, category);
        while (rs.next()) {
            TutorialArticleModel article = new TutorialArticleModel();
            article.setId(rs.getInt("id"));
            article.setTitle(rs.getString("title"));
            article.setContent(rs.getString("content"));
            article.setCategory(rs.getString("category"));
            article.setUserId(rs.getInt("user_id"));
            article.setUsername(rs.getString("username"));
            article.setImage1(rs.getString("image1"));
            article.setImage2(rs.getString("image2"));
            article.setImage3(rs.getString("image3"));
            article.setImage4(rs.getString("image4"));
            article.setImage5(rs.getString("image5"));
            article.setImage6(rs.getString("image6"));
            article.setViewCount(rs.getInt("view_count"));
            article.setStatus(rs.getInt("status"));
            article.setCreateTime(rs.getString("create_time"));
            list.add(article);
        }
        db.close();
        return list;
    }
    
    /**
     * findTutorialArticleById - 根据ID查询教程文章详情
     */
    public TutorialArticleModel findTutorialArticleById(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_articles WHERE id = ?";
        ResultSet rs = db.executeQuery(sql, id);
        TutorialArticleModel article = null;
        if (rs.next()) {
            article = new TutorialArticleModel();
            article.setId(rs.getInt("id"));
            article.setTitle(rs.getString("title"));
            article.setContent(rs.getString("content"));
            article.setCategory(rs.getString("category"));
            article.setUserId(rs.getInt("user_id"));
            article.setUsername(rs.getString("username"));
            article.setImage1(rs.getString("image1"));
            article.setImage2(rs.getString("image2"));
            article.setImage3(rs.getString("image3"));
            article.setImage4(rs.getString("image4"));
            article.setImage5(rs.getString("image5"));
            article.setImage6(rs.getString("image6"));
            article.setViewCount(rs.getInt("view_count"));
            article.setStatus(rs.getInt("status"));
            article.setCreateTime(rs.getString("create_time"));
        }
        db.close();
        return article;
    }
    
    /**
     * addTutorialArticle - 添加教程文章
     */
    public int addTutorialArticle(TutorialArticleModel article) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "INSERT INTO tutorial_articles (title, content, category, user_id, username, image1, image2, image3, image4, image5, image6) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int result = db.executeUpdate(sql, article.getTitle(), article.getContent(), article.getCategory(), 
            article.getUserId(), article.getUsername(), article.getImage1(), article.getImage2(), 
            article.getImage3(), article.getImage4(), article.getImage5(), article.getImage6());
        db.close();
        return result;
    }
    
    /**
     * updateTutorialArticle - 更新教程文章
     */
    public int updateTutorialArticle(TutorialArticleModel article) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_articles SET title = ?, content = ?, category = ?, image1 = ?, image2 = ?, image3 = ?, image4 = ?, image5 = ?, image6 = ? WHERE id = ?";
        int result = db.executeUpdate(sql, article.getTitle(), article.getContent(), article.getCategory(),
            article.getImage1(), article.getImage2(), article.getImage3(), article.getImage4(), 
            article.getImage5(), article.getImage6(), article.getId());
        db.close();
        return result;
    }
    
    /**
     * deleteTutorialArticle - 删除教程文章
     */
    public int deleteTutorialArticle(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM tutorial_articles WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }
    
    /**
     * incrementTutorialArticleViewCount - 增加文章阅读量
     */
    public int incrementTutorialArticleViewCount(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_articles SET view_count = view_count + 1 WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }
    
    // ==================== 获取分类内容数量 ====================
    
    /**
     * getTutorialArticleCountByCategory - 统计分类下的文章数量
     * 
     * 【COUNT(*)函数说明】
     * COUNT(*)会统计满足WHERE条件的记录总数
     * 这里用于显示每个分类下有多少篇文章
     */
    public int getTutorialArticleCountByCategory(String category) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT COUNT(*) as count FROM tutorial_articles WHERE category = ? AND status = 1";
        ResultSet rs = db.executeQuery(sql, category);
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    /**
     * getTutorialVideoCountByCategory - 统计分类下的视频数量
     */
    public int getTutorialVideoCountByCategory(String category) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT COUNT(*) as count FROM tutorial_videos WHERE category = ?";
        ResultSet rs = db.executeQuery(sql, category);
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    /**
     * findTutorialVideosByCategory - 查询分类下的所有视频
     */
    public ArrayList<VideoModel> findTutorialVideosByCategory(String category) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM tutorial_videos WHERE category = ? ORDER BY create_time DESC";
        ArrayList<VideoModel> list = new ArrayList<VideoModel>();
        ResultSet rs = db.executeQuery(sql, category);
        while (rs.next()) {
            VideoModel video = new VideoModel();
            video.setId(rs.getInt("id"));
            video.setBvid(rs.getString("bvid"));
            video.setTitle(rs.getString("title"));
            video.setDescription(rs.getString("description"));
            video.setThumbnailUrl(rs.getString("thumbnail_url"));
            video.setCategory(rs.getString("category"));
            video.setViewCount(rs.getInt("view_count"));
            video.setLikes(rs.getInt("likes"));
            video.setAuthor(rs.getString("author"));
            video.setCreateTime(rs.getString("create_time"));
            list.add(video);
        }
        db.close();
        return list;
    }
    
    // ==================== 仪表盘统计功能 ====================
    
    /**
     * getTotalCommentCount - 获取评论总数
     * 
     * 【功能说明】
     * 统计数据库中所有评论的数量，用于管理员仪表盘显示
     */
    public int getTotalCommentCount() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT COUNT(*) as count FROM comment";
        ResultSet rs = db.executeQuery(sql);
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    /**
     * getAdminUserCount - 获取管理员数量
     */
    public int getAdminUserCount() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT COUNT(*) as count FROM user WHERE role = 0";
        ResultSet rs = db.executeQuery(sql);
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
    
    /**
     * getBannedPostCount - 获取被封禁的帖子数量
     */
    public int getBannedPostCount() throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT COUNT(*) as count FROM post WHERE status = 0";
        ResultSet rs = db.executeQuery(sql);
        int count = 0;
        if (rs.next()) {
            count = rs.getInt("count");
        }
        db.close();
        return count;
    }
}
