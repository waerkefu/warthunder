package model;

public class CommentModel {
    private int id;
    private int post_id;
    private int user_id;
    private String username;
    private String content;
    private String create_time;
    private int parent_id;
    private String parent_username;
    private String avatar;

    public CommentModel() {}

    public CommentModel(int id, int post_id, int user_id, String content, String create_time) {
        this.id = id;
        this.post_id = post_id;
        this.user_id = user_id;
        this.content = content;
        this.create_time = create_time;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPost_id() {
        return post_id;
    }

    public void setPost_id(int post_id) {
        this.post_id = post_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public int getParent_id() {
        return parent_id;
    }

    public void setParent_id(int parent_id) {
        this.parent_id = parent_id;
    }

    public String getParent_username() {
        return parent_username;
    }

    public void setParent_username(String parent_username) {
        this.parent_username = parent_username;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public boolean hasAvatar() {
        return avatar != null && !avatar.isEmpty();
    }

    public boolean hasParent() {
        return parent_id > 0;
    }
}