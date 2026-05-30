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

public class user_dao {

    public user_model find_user_name_password(String email, String password) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select * from user where email = ? and password = ?";
        user_model user = new user_model();
        ResultSet rs = db.executeQuery(sql, email, password);
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

    public int insertuser(String username, String password, String email) {
        DBHelper db = new DBHelper();
        String sql = "insert into user(username,password,email,role) values(?,?,?,1)";
        int i = db.executeUpdate(sql, username, password, email);
        db.close();
        return i;
    }

    public user_model findUserById(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "select * from user where id = ?";
        user_model user = new user_model();
        ResultSet rs = db.executeQuery(sql, userId);
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

    public ArrayList<PostModel> findPostsByUserId(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.user_id = ? ORDER BY p.create_time DESC";
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql, userId);
        while (rs.next()){
            PostModel post = new PostModel();
            post.setId(rs.getInt("id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setUser_id(rs.getInt("user_id"));
            post.setUsername(rs.getString("username"));
            post.setCreate_time(rs.getString("create_time"));
            list.add(post);
        }
        db.close();
        return list;
    }

    public ArrayList<PostModel> findAllPosts() throws SQLException {
        DBHelper db = new DBHelper();
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

    public int insertPost(int userId, String title, String content) {
        DBHelper db = new DBHelper();
        String sql = "insert into post(title,content,user_id) values(?,?,?)";
        int i = db.executeUpdate(sql, title, content, userId);
        db.close();
        return i;
    }

    public int insertPostWithImages(int userId, String title, String content, String image1, String image2, String image3, String image4, String image5, String image6) {
        DBHelper db = new DBHelper();
        String sql = "insert into post(title,content,user_id,image1,image2,image3,image4,image5,image6) values(?,?,?,?,?,?,?,?,?)";
        int i = db.executeUpdate(sql, title, content, userId, image1, image2, image3, image4, image5, image6);
        db.close();
        return i;
    }

    public int updatePost(int postId, String title, String content) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update post set title = ?, content = ? where id = ?";
        int i = db.executeUpdate(sql, title, content, postId);
        db.close();
        return i;
    }

    public int updatePostWithImages(int postId, String title, String content, String image1, String image2, String image3, String image4, String image5, String image6) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update post set title = ?, content = ?, image1 = ?, image2 = ?, image3 = ?, image4 = ?, image5 = ?, image6 = ? where id = ?";
        int i = db.executeUpdate(sql, title, content, image1, image2, image3, image4, image5, image6, postId);
        db.close();
        return i;
    }

    public int deletePost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "delete from post where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }

    public int banPost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "update post set status = 0 where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }

    public int unbanPost(int postId) {
        DBHelper db = new DBHelper();
        String sql = "update post set status = 1 where id = ?";
        int i = db.executeUpdate(sql, postId);
        db.close();
        return i;
    }

    public int deleteComment(int commentId) {
        DBHelper db = new DBHelper();
        String sql = "delete from comment where id = ?";
        int i = db.executeUpdate(sql, commentId);
        db.close();
        return i;
    }

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

    public int insertComment(int postId, int userId, String content) {
        DBHelper db = new DBHelper();
        String sql = "insert into comment(post_id,user_id,content) values(?,?,?)";
        int i = db.executeUpdate(sql, postId, userId, content);
        db.close();
        return i;
    }

    public int insertReplyComment(int postId, int userId, String content, int parentId) {
        DBHelper db = new DBHelper();
        String sql = "insert into comment(post_id,user_id,content,parent_id) values(?,?,?,?)";
        int i = db.executeUpdate(sql, postId, userId, content, parentId);
        db.close();
        return i;
    }

    public int updateUserInfo(int userId, String username, String email) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set username = ?, email = ? where id = ?";
        int i = db.executeUpdate(sql, username, email, userId);
        db.close();
        return i;
    }

    public int updateAvatar(int userId, String avatarPath) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set avatar = ? where id = ?";
        int i = db.executeUpdate(sql, avatarPath, userId);
        db.close();
        return i;
    }

    public int changePassword(int userId, String newPassword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "update user set password = ? where id = ?";
        int i = db.executeUpdate(sql, newPassword, userId);
        db.close();
        return i;
    }

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

    public ArrayList<user_model> searchUsers(String keyword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT * FROM user WHERE username LIKE ? OR email LIKE ? ORDER BY role ASC, id DESC";
        String likeKeyword = "%" + keyword + "%";
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

    public int deleteUser(int userId) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM user WHERE id = ?";
        int i = db.executeUpdate(sql, userId);
        db.close();
        return i;
    }

    public int updateUserRole(int userId, int role) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE user SET role = ? WHERE id = ?";
        int i = db.executeUpdate(sql, role, userId);
        db.close();
        return i;
    }

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

    public ArrayList<PostModel> searchPosts(String keyword) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "SELECT p.*, u.username FROM post p JOIN user u ON p.user_id = u.id WHERE p.title LIKE ? OR p.content LIKE ? ORDER BY p.create_time DESC";
        String likeKeyword = "%" + keyword + "%";
        ArrayList<PostModel> list = new ArrayList<PostModel>();
        ResultSet rs = db.executeQuery(sql, likeKeyword, likeKeyword);
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

    public int addVideo(VideoModel video) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "INSERT INTO tutorial_videos (bvid, title, description, thumbnail_url, category, author) VALUES (?, ?, ?, ?, ?, ?)";
        int result = db.executeUpdate(sql, video.getBvid(), video.getTitle(), video.getDescription(), video.getThumbnailUrl(), video.getCategory(), video.getAuthor());
        db.close();
        return result;
    }

    public int updateVideo(VideoModel video) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_videos SET bvid = ?, title = ?, description = ?, thumbnail_url = ?, category = ?, author = ? WHERE id = ?";
        int result = db.executeUpdate(sql, video.getBvid(), video.getTitle(), video.getDescription(), video.getThumbnailUrl(), video.getCategory(), video.getAuthor(), video.getId());
        db.close();
        return result;
    }

    public int deleteVideo(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM tutorial_videos WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }

    public int incrementViewCount(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_videos SET view_count = view_count + 1 WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }

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

    public int addTutorialArticle(TutorialArticleModel article) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "INSERT INTO tutorial_articles (title, content, category, user_id, username, image1, image2, image3, image4, image5, image6) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int result = db.executeUpdate(sql, article.getTitle(), article.getContent(), article.getCategory(), 
            article.getUserId(), article.getUsername(), article.getImage1(), article.getImage2(), 
            article.getImage3(), article.getImage4(), article.getImage5(), article.getImage6());
        db.close();
        return result;
    }

    public int updateTutorialArticle(TutorialArticleModel article) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_articles SET title = ?, content = ?, category = ?, image1 = ?, image2 = ?, image3 = ?, image4 = ?, image5 = ?, image6 = ? WHERE id = ?";
        int result = db.executeUpdate(sql, article.getTitle(), article.getContent(), article.getCategory(),
            article.getImage1(), article.getImage2(), article.getImage3(), article.getImage4(), 
            article.getImage5(), article.getImage6(), article.getId());
        db.close();
        return result;
    }

    public int deleteTutorialArticle(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "DELETE FROM tutorial_articles WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }

    public int incrementTutorialArticleViewCount(int id) throws SQLException {
        DBHelper db = new DBHelper();
        String sql = "UPDATE tutorial_articles SET view_count = view_count + 1 WHERE id = ?";
        int result = db.executeUpdate(sql, id);
        db.close();
        return result;
    }

    // ==================== 获取分类内容数量 ====================

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
}