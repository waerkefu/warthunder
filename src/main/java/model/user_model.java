package model;

import lombok.Data;

@Data
public class user_model {
    private int id;
    private String username;
    private String password;
    private String email;
    private int role;
    private String avatar;

    public user_model(int user_id, String user_name, String user_password) {
        this.id = user_id;
        this.username = user_name;
        this.password = user_password;
    }

    public user_model() {}

    public int getUser_id() {
        return id;
    }

    public void setUser_id(int user_id) {
        this.id = user_id;
    }

    public String getUser_name() {
        return this.username;
    }

    public void setUser_name(String user_name) {
        this.username = user_name;
    }

    public String getUser_password() {
        return this.password;
    }

    public void setUser_password(String user_password) {
        this.password = user_password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public boolean isAdmin() {
        return role == 0;
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
}
