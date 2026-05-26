package service;

import dao.user_dao;
import model.ArticleModel;
import model.CommentModel;
import model.PostModel;
import model.user_model;

import java.sql.SQLException;
import java.util.ArrayList;

public class user_service {
    public user_model find_user_name_password(String email, String password) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.find_user_name_password(email,password);
    }

    public int insertuser(String username, String password, String email) {
        user_dao userdao = new user_dao();
        return userdao.insertuser(username,password,email);
    }

    public user_model findUserById(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findUserById(userId);
    }

    public user_model findUserByUsername(String username) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findUserByUsername(username);
    }

    public ArrayList<PostModel> findPostsByUserId(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findPostsByUserId(userId);
    }

    public ArrayList<PostModel> findAllPosts() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllPosts();
    }

    public ArrayList<PostModel> findAllPostsForAdmin() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllPostsForAdmin();
    }

    public PostModel findPostById(int postId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findPostById(postId);
    }

    public int insertPost(int userId, String title, String content) {
        user_dao userdao = new user_dao();
        return userdao.insertPost(userId, title, content);
    }

    public int insertPostWithImages(int userId, String title, String content, String image1, String image2, String image3, String image4, String image5, String image6) {
        user_dao userdao = new user_dao();
        return userdao.insertPostWithImages(userId, title, content, image1, image2, image3, image4, image5, image6);
    }

    public int updatePost(int postId, String title, String content) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updatePost(postId, title, content);
    }

    public int updatePostWithImages(int postId, String title, String content, String image1, String image2, String image3, String image4, String image5, String image6) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updatePostWithImages(postId, title, content, image1, image2, image3, image4, image5, image6);
    }

    public int deletePost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.deletePost(postId);
    }

    public int banPost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.banPost(postId);
    }

    public int unbanPost(int postId) {
        user_dao userdao = new user_dao();
        return userdao.unbanPost(postId);
    }

    public int deleteComment(int commentId) {
        user_dao userdao = new user_dao();
        return userdao.deleteComment(commentId);
    }

    public int getUserPostCount(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getUserPostCount(userId);
    }

    public ArrayList<CommentModel> findCommentsByPostId(int postId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findCommentsByPostId(postId);
    }

    public int insertComment(int postId, int userId, String content) {
        user_dao userdao = new user_dao();
        return userdao.insertComment(postId, userId, content);
    }

    public int insertReplyComment(int postId, int userId, String content, int parentId) {
        user_dao userdao = new user_dao();
        return userdao.insertReplyComment(postId, userId, content, parentId);
    }

    public int updateUserInfo(int userId, String username, String email) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateUserInfo(userId, username, email);
    }

    public int updateAvatar(int userId, String avatarPath) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateAvatar(userId, avatarPath);
    }

    public int changePassword(int userId, String newPassword) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.changePassword(userId, newPassword);
    }

    public ArrayList<user_model> findAllUsers() throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findAllUsers();
    }

    public int deleteUser(int userId) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.deleteUser(userId);
    }

    public int updateUserRole(int userId, int role) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.updateUserRole(userId, role);
    }

    public ArrayList<ArticleModel> findArticlesByAuthor(String author) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.findArticlesByAuthor(author);
    }

    public int getUserArticleCount(String author) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.getUserArticleCount(author);
    }

    public ArrayList<PostModel> searchPosts(String keyword) throws SQLException {
        user_dao userdao = new user_dao();
        return userdao.searchPosts(keyword);
    }
}