package model;

public class PostModel {
    private int id;
    private String title;
    private String content;
    private int user_id;
    private String username;
    private String create_time;
    private int status;

    public PostModel() {}

    public PostModel(int id, String title, String content, int user_id, String create_time) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.user_id = user_id;
        this.create_time = create_time;
        this.status = 1;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isActive() {
        return status == 1;
    }
}