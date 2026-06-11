package model;

public class PostModel {
    private int id;
    private String title;
    private String content;
    private int user_id;
    private String username;
    private String create_time;
    private int status;
    private int reviewStatus;
    private String reviewMessage;
    private String image1;
    private String image2;
    private String image3;
    private String image4;
    private String image5;
    private String image6;

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

    public String getImage1() {
        return image1;
    }

    public void setImage1(String image1) {
        this.image1 = image1;
    }

    public String getImage2() {
        return image2;
    }

    public void setImage2(String image2) {
        this.image2 = image2;
    }

    public String getImage3() {
        return image3;
    }

    public void setImage3(String image3) {
        this.image3 = image3;
    }

    public String getImage4() {
        return image4;
    }

    public void setImage4(String image4) {
        this.image4 = image4;
    }

    public String getImage5() {
        return image5;
    }

    public void setImage5(String image5) {
        this.image5 = image5;
    }

    public String getImage6() {
        return image6;
    }

    public void setImage6(String image6) {
        this.image6 = image6;
    }

    public boolean hasImages() {
        return image1 != null || image2 != null || image3 != null || image4 != null || image5 != null || image6 != null;
    }
}