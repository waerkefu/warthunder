package db;

import java.sql.*;

//数据库结构调用包
public class DBHelper {
    private static String url = "jdbc:mysql://localhost:3306/mydata?serverTimezone=UTC";
    private static String user = "root";
    private static String password = "123456";
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    private void getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        try {
            conn = DriverManager.getConnection(url,user,password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int executeUpdate(String sql, Object...objects) {
        getConnection();
        try {
            pst = conn.prepareStatement(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        setPrepared(objects);
        try {
            return pst.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void setPrepared(Object...objects) {
        if(objects!=null && objects.length>0) {
            for(int i=0;i<objects.length;i++) {
                try {
                    pst.setObject(i+1,objects[i]);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }

    public ResultSet executeQuery(String sql, Object...objects) {
        getConnection();
        try {
            pst = conn.prepareStatement(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        setPrepared(objects);
        try {
            return pst.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void close() {
        // 1. 关闭 ResultSet（结果集）：后创建的先关闭
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                throw new RuntimeException("关闭 ResultSet 失败", e);
            }
        }

        // 2. 关闭 PreparedStatement（预处理语句）
        if (pst != null) {
            try {
                pst.close();
            } catch (SQLException e) {
                throw new RuntimeException("关闭 PreparedStatement 失败", e);
            }
        }

        // 3. 关闭 Connection（数据库连接）：先创建的后关闭
        if (conn != null) {
            try {
                // 先判断连接是否已经关闭，避免重复关闭报错
                if (!conn.isClosed()) {
                    conn.close();
                }
            } catch (SQLException e) {
                throw new RuntimeException("关闭 Connection 数据库连接失败", e);
            }
        }
    }
}
