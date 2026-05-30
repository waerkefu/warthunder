-- =====================================================
-- 教程文章数据库表创建脚本
-- War Thunder 社区论坛
-- =====================================================

-- 创建教程文章表
CREATE TABLE IF NOT EXISTS tutorial_articles (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '教程ID',
    title VARCHAR(200) NOT NULL COMMENT '教程标题',
    content TEXT NOT NULL COMMENT '教程内容',
    category ENUM('maps', 'vehicles', 'weakspots') NOT NULL DEFAULT 'maps' COMMENT '分类',
    user_id INT NOT NULL COMMENT '作者ID',
    username VARCHAR(50) COMMENT '作者用户名（冗余）',
    image1 VARCHAR(255) DEFAULT NULL COMMENT '图片1',
    image2 VARCHAR(255) DEFAULT NULL COMMENT '图片2',
    image3 VARCHAR(255) DEFAULT NULL COMMENT '图片3',
    image4 VARCHAR(255) DEFAULT NULL COMMENT '图片4',
    image5 VARCHAR(255) DEFAULT NULL COMMENT '图片5',
    image6 VARCHAR(255) DEFAULT NULL COMMENT '图片6',
    view_count INT DEFAULT 0 COMMENT '浏览量',
    status INT DEFAULT 1 COMMENT '状态：1=正常 0=隐藏',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教程文章表';

-- =====================================================
-- 示例数据（可选）
-- =====================================================

INSERT INTO tutorial_articles (title, content, category, user_id, username, view_count) VALUES
('诺曼底地图完全攻略', '诺曼底是战争雷霆中最经典的地图之一，本文将详细分析该地图的地形特点、关键点位和战术路线。\n\n## 地形概述\n诺曼底地图以二战诺曼底登陆为背景...', 'maps', 1, 'admin', 1250),
('虎式H1完全测评', '虎式H1是德国四级重型坦克，以其强大的火力和厚重的装甲著称。', 'vehicles', 1, 'admin', 2340),
('T-34系列弱点全解析', 'T-34是苏联最著名的坦克系列，了解其弱点对击穿至关重要。', 'weakspots', 1, 'admin', 1890);