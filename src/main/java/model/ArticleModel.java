package model;

public class ArticleModel {
    public ArticleModel(int id, String author, String title, String content, String update_time) {
        this.id = id;
        this.author = author;
        this.title = title;
        this.content = content;
        this.update_time = update_time;
    }
    public ArticleModel() {

    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
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

    private int id;
    private String author;   // 作者
    private String title;
    private String content;
    private String update_time; // 最后的更新时间
}