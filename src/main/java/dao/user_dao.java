package dao;

import db.DBHelper;
import model.ArticleModel;
import model.CommentModel;
import model.PostModel;
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
}