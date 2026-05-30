-- =====================================================
-- 视频教程数据库表创建脚本
-- War Thunder 社区论坛
-- =====================================================

-- 创建视频教程表
CREATE TABLE IF NOT EXISTS tutorial_videos (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '视频ID',
    bvid VARCHAR(50) NOT NULL COMMENT 'Bilibili视频BV号',
    title VARCHAR(200) NOT NULL COMMENT '视频标题',
    description TEXT COMMENT '视频描述',
    thumbnail_url VARCHAR(300) COMMENT '视频缩略图URL',
    category ENUM('maps', 'vehicles', 'weakspots') DEFAULT 'maps' COMMENT '所属分类：maps地图解析/vehicles载具测评/weakspots车辆弱点',
    view_count INT DEFAULT 0 COMMENT '播放次数',
    likes INT DEFAULT 0 COMMENT '点赞数',
    author VARCHAR(50) COMMENT 'UP主名称',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='视频教程表';

-- =====================================================
-- 示例数据插入（可选）
-- =====================================================

-- 插入示例视频数据
INSERT INTO tutorial_videos (bvid, title, description, thumbnail_url, category, view_count, likes, author) VALUES
('BV1GJ411x7h7', '【战争雷霆】新手入门教程 - 从零开始的飞行员指南', '本教程面向所有新入坑的飞行学员，详细讲解游戏基本操作、飞机操控、机动技巧等基础知识。', 'https://i0.hdslb.com/bfs/archive/placeholder.jpg', 'vehicles', 125000, 8321, '战争雷霆学院'),
('BV1example001', '虎式坦克完全指南 - 重装甲的荣耀与弱点', '深入分析虎式坦克的装甲分布、主炮威力、机动性能，以及如何在战场上发挥最大作用。', 'https://i0.hdslb.com/bfs/archive/placeholder.jpg', 'vehicles', 82000, 5632, '重装甲师'),
('BV1example002', '空战技巧进阶 - 桶滚与破S机动详解', '专业飞行员教你掌握高级空战机动，桶滚、破S、殷麦曼转弯等经典机动动作教学。', 'https://i0.hdslb.com/bfs/archive/placeholder.jpg', 'vehicles', 67000, 4210, '王牌飞行员'),
('BV1example003', '苏联坦克弱点全解析 - 一击必杀的关键位置', '详细标注各型苏联坦克的装甲弱点，包括驾驶舱、弹药架、发动机等关键位置。', 'https://i0.hdslb.com/bfs/archive/placeholder.jpg', 'weakspots', 95000, 6789, '穿甲高手'),
('BV1example004', '诺曼底地图深度解析 - 登陆作战的战略要点', '分析诺曼底地图的每一个关键点位，讲解进攻路线、防守策略和载具选择建议。', 'https://i0.hdslb.com/bfs/archive/placeholder.jpg', 'maps', 78000, 5120, '战术大师');

-- =====================================================
-- 常用查询示例
-- =====================================================

-- 查询所有视频
-- SELECT * FROM tutorial_videos ORDER BY create_time DESC;

-- 按分类查询
-- SELECT * FROM tutorial_videos WHERE category = 'vehicles' ORDER BY view_count DESC;

-- 查询热门视频（按播放量排序）
-- SELECT * FROM tutorial_videos ORDER BY view_count DESC LIMIT 10;

-- 更新播放量（当用户点击播放时）
-- UPDATE tutorial_videos SET view_count = view_count + 1 WHERE id = 1;

-- 删除视频
-- DELETE FROM tutorial_videos WHERE id = 1;