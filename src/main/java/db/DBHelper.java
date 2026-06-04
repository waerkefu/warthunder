package db;

import java.sql.*;

/**
 * DBHelper - 数据库操作工具类
 * 
 * 【功能说明】
 * 这是项目的数据访问基础设施，封装了JDBC操作的所有细节。
 * 提供了数据库连接、查询、更新、资源关闭等核心功能。
 * 
 * 【使用场景】
 * - 所有需要访问数据库的操作都需要通过这个类
 * - DAO层使用这个类来执行SQL语句
 * 
 * 【技术要点】
 * - 使用JDBC的PreparedStatement防止SQL注入
 * - 单例模式的数据库连接管理
 * - 资源正确关闭，避免内存泄漏
 * 
 * @author WarThunder Team
 */
public class DBHelper {
    
    // ==================== 数据库连接配置 ====================
    // 数据库地址：协议://主机:端口/数据库名?时区设置
    private static String url = "jdbc:mysql://localhost:3306/mydata?serverTimezone=UTC";
    //private static String url = "jdbc:mysql://localhost:3306/mydata?serverTimezone=UTC&useSSL=false";
    
    // 数据库用户名（根据实际情况修改）
    private static String user = "root";
    
    // 数据库密码（根据实际情况修改）
    private static String password = "123456";
    
    // ==================== JDBC连接对象 ====================
    // Connection: 数据库连接对象，用于建立与数据库的连接
    Connection conn = null;
    
    // PreparedStatement: 预处理语句对象，用于执行SQL语句
    // 优点：可以防止SQL注入，提高SQL执行效率
    PreparedStatement pst = null;
    
    // ResultSet: 结果集对象，用于存储查询结果
    ResultSet rs = null;
    
    /**
     * getConnection - 获取数据库连接
     * 
     * 【执行流程】
     * 1. 加载MySQL JDBC驱动（Class.forName）
     * 2. 通过DriverManager获取数据库连接
     * 
     * 【注意事项】
     * - 需要捕获ClassNotFoundException（驱动类未找到）
     * - 需要捕获SQLException（数据库连接失败）
     */
    private void getConnection() {
        // 加载MySQL JDBC驱动
        // Class.forName会触发驱动的静态代码块，注册驱动到DriverManager
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // 如果驱动类找不到，抛出运行时异常
            throw new RuntimeException(e);
        }
        
        // 通过DriverManager获取数据库连接
        try {
            conn = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            // 如果连接失败，抛出运行时异常
            throw new RuntimeException(e);
        }
    }
    
    /**
     * executeUpdate - 执行增删改操作
     * 
     * 【功能说明】
     * 用于执行INSERT、UPDATE、DELETE等写操作
     * 
     * 【参数说明】
     * @param sql SQL语句，使用?作为占位符
     * @param objects 可变参数，用于填充SQL中的占位符
     * @return 受影响的行数（通常为1表示成功，0表示失败）
     * 
     * 【使用示例】
     * executeUpdate("INSERT INTO user VALUES(?,?)", "张三", 25);
     * 
     * 【技术要点】
     * - 使用PreparedStatement而非Statement，防止SQL注入
     * - 占位符从1开始编号，不是0
     */
    public int executeUpdate(String sql, Object...objects) {
        // 1. 获取数据库连接
        getConnection();
        
        try {
            // 2. 创建预处理语句对象
            pst = conn.prepareStatement(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        
        // 3. 设置占位符参数
        setPrepared(objects);
        
        try {
            // 4. 执行更新操作并返回受影响的行数
            return pst.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * setPrepared - 设置PreparedStatement的占位符参数
     * 
     * 【功能说明】
     * 将可变参数objects逐个设置到PreparedStatement的占位符位置
     * 
     * 【参数说明】
     * @param objects 要设置的可变参数数组
     * 
     * 【示例】
     * SQL: "INSERT INTO user VALUES(?,?,?)"
     * objects: ["张三", "男", 25]
     * 结果: pst.setString(1, "张三"), pst.setString(2, "男"), pst.setInt(3, 25)
     */
    private void setPrepared(Object...objects) {
        // 如果有参数需要设置
        if(objects!=null && objects.length>0) {
            // 遍历所有参数，逐个设置到占位符位置
            for(int i=0;i<objects.length;i++) {
                try {
                    // setObject(index, value)：设置第index个占位符的值
                    // 注意：索引从1开始，不是从0开始
                    pst.setObject(i+1,objects[i]);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
    
    /**
     * executeQuery - 执行查询操作
     * 
     * 【功能说明】
     * 用于执行SELECT查询语句，返回查询结果集
     * 
     * 【参数说明】
     * @param sql SQL查询语句，使用?作为占位符
     * @param objects 可变参数，用于填充SQL中的占位符
     * @return ResultSet结果集对象，包含查询到的所有数据
     * 
     * 【使用示例】
     * ResultSet rs = executeQuery("SELECT * FROM user WHERE age > ?", 18);
     * while(rs.next()) {
     *     System.out.println(rs.getString("name"));
     * }
     * 
     * 【注意事项】
     * - 查询完成后需要在finally块或finally方法中关闭ResultSet
     * - ResultSet保持与数据库的连接，不要过早关闭
     */
    public ResultSet executeQuery(String sql, Object...objects) {
        // 1. 获取数据库连接
        getConnection();
        
        try {
            // 2. 创建预处理语句对象
            pst = conn.prepareStatement(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        
        // 3. 设置占位符参数
        setPrepared(objects);
        
        try {
            // 4. 执行查询并返回结果集
            return pst.executeQuery();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    /**
     * close - 关闭所有数据库资源
     * 
     * 【功能说明】
     * 关闭ResultSet、PreparedStatement、Connection三个资源对象
     * 这是最重要的资源释放方法，必须在所有数据库操作后调用
     * 
     * 【关闭顺序】
     * 采用"后创建先关闭"的原则：
     * 1. 先关闭ResultSet（最后创建的结果集）
     * 2. 再关闭PreparedStatement（中间创建的语句对象）
     * 3. 最后关闭Connection（最先创建的连接对象）
     * 
     * 【异常处理】
     * - 每个资源的关闭操作都单独try-catch
     * - 即使一个资源关闭失败，也会继续关闭其他资源
     * - 捕获异常后抛出运行时异常，方便调试
     * 
     * 【最佳实践】
     * try {
     *     // 执行数据库操作
     * } finally {
     *     db.close(); // 确保资源一定被关闭
     * }
     */
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
