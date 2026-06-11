package model;

import java.sql.Timestamp;

public class VideoModel {
    private int id;
    private String bvid;
    private String title;
    private String description;
    private String thumbnailUrl;
    private String category;
    private int viewCount;
    private int likes;
    private String author;
    private int reviewStatus;
    private String reviewMessage;
    private String createTime;

    public VideoModel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBvid() {
        return bvid;
    }

    public void setBvid(String bvid) {
        this.bvid = bvid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(int reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public String getReviewMessage() {
        return reviewMessage;
    }

    public void setReviewMessage(String reviewMessage) {
        this.reviewMessage = reviewMessage;
    }

    public boolean isPendingReview() {
        return reviewStatus == 0;
    }

    public boolean isReviewPassed() {
        return reviewStatus == 1;
    }

    public boolean isReviewRejected() {
        return reviewStatus == 2;
    }

    public String getReviewStatusText() {
        switch (reviewStatus) {
            case 0: return "待审核";
            case 1: return "审核通过";
            case 2: return "审核不通过";
            default: return "未知";
        }
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getCategoryName() {
        switch (category) {
            case "maps": return "地图解析";
            case "vehicles": return "载具测评";
            case "weakspots": return "车辆弱点";
            default: return "其他";
        }
    }
}