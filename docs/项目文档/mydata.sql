/*
 Navicat Premium Dump SQL

 Source Server         : WT
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : 127.0.0.1:3306
 Source Schema         : mydata

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 02/06/2026 19:34:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `post_id` int NOT NULL COMMENT '所属帖子ID',
  `user_id` int NOT NULL COMMENT '评论人ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `parent_id` int NULL DEFAULT NULL COMMENT '父评论ID，NULL=一级评论',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `post_id`(`post_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `parent_id`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '帖子评论表（支持楼中楼回复）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (15, 6, 2, '好的我会遵守', '2026-05-26 17:36:18', NULL);
INSERT INTO `comment` VALUES (16, 6, 3, '是的，我同一', '2026-05-26 17:36:44', NULL);
INSERT INTO `comment` VALUES (17, 6, 3, '@play2 我同意', '2026-05-26 17:37:06', 16);

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '帖子内容',
  `user_id` int NOT NULL COMMENT '发帖人ID，关联用户表id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发帖时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1=正常 0=封禁',
  `image1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片1路径',
  `image2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片2路径',
  `image3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片3路径',
  `image4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片4路径',
  `image5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片5路径',
  `image6` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片6路径',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '论坛帖子表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (6, '战争雷霆社区-论坛守则与食用指南', '论坛安全食用特别提醒：\r\n\r\n在使用论坛回复功能的时候请注意不要滥用论坛的 Flag 功能，Flag 功能（图标是一个小旗子，位于文本框的右下角的功能栏之中） 是论坛的帖子举报功能。\r\n当一个回复或文章在短时间内受到大量举报，该贴文会暂时隐藏等待论坛版主审核。\r\n但是请注意，如果故意滥用 Flag 功能妨碍他人正常发帖，在经过版主调查后会遭受一定的惩罚。\r\n\r\n在论坛上发言之前请先考虑清楚，自己的发言是否违反最终用户许可协议。\r\n任何形式的威胁，“不出xxx就删号”，“不加强xxx就卖号”之类的账号交易宣言将会被视为主观账号交易行为。账号交易按照最终用户许可协议将有可能会对账号进行永久封禁。\r\n\r\n与外国用户进行交流的时候请尊重文化差异，有些玩笑对于国人来说可能无伤大雅，但是对于外国人来说是非常冒犯的事情。\r\n如果因为不当玩笑而陷入纠纷之中，就只能按照论坛规则进行处理了。例如尽量不要使用“斯拉夫”“雅利安”等种族分类容易造成误解的词汇。由于论坛并不只有中文管理员，各位管理员对这些事情的感度也不同，所以处理纠纷的方式也不一样。\r\n\r\n并非所有的外国用户都以话题性为主，警惕部分种族歧视的外国人，如果您在交流中遇到了感觉被歧视的情况，请使用 Flag 功能进行举报。\r\n请勿在讨论或提交 Bug 时上传或讨论涉密资料！一旦发现，永久封禁！\r\n\r\n------------------------------------------------\r\n论坛私信功能遇到问题？\r\n\r\n如果您在使用论坛时遇到其他用户通过私信对您进行辱骂或者骚扰，请使用 Flag 功能进行举报。\r\n\r\n请勿以任何的形式公开或传播您与论坛管理员的私聊记录，这是违反社区守则的行为。\r\n\r\n------------------------------------------------\r\n游戏内发言特别提醒\r\n\r\n我们的游戏的玩家来自于世界各地，其中也包括我国香港、澳门、台湾等地区，并且其他地区例如新加坡等地的玩家也可能会使用 非简体 中文。\r\n我们的简体中文也是基于繁体字简化而来，繁体字自古就是我们文化的一部分，请不要把老祖宗留下来的东西当作某些特定政治敏感区域的代表，非常丢人。在交流时，如果只是因为玩家使用繁体字或非违规昵称而对玩家进行人身攻击则会视为地域歧视，按照 Racism 相关规则进行处理。\r\n\r\n请勿在游戏内声称自己买卖账号，或者开非常不恰当的政治玩笑。\r\n前者大概率直接由 Gaijin 永久封号，后者可能会导致较为严重的禁言惩罚。\r\n\r\n请勿在游戏里声称自己贩卖外挂或者使用外挂，无论您是否真的使用违禁修改器，您所述的话语就是最有力的证据，谨记。\r\n切忌一时心大嘲讽别的玩家说自己“开了”之类的话。相关情况一经核实，就相当于有了您口头承认自己使用第三方修改器的证据，直接按照最终用户许可协议进行永久封号。', 1, '2026-05-26 17:29:42', 1, 'upload/post/3966d18c-a8c9-494d-ba6b-491884786d15.jpeg', 'upload/post/6e62b7fb-2675-42aa-a701-97915daf37f2.png', 'upload/post/933d0d06-eb20-4f52-8ca0-a559f2b610f2.png', NULL, NULL, NULL);
INSERT INTO `post` VALUES (7, '霹雳12被大砍！', 'bvvd大手一挥给霹雳12砍成aim120', 1, '2026-05-28 09:14:23', 1, 'upload/post/fe29470a-9891-4377-8d68-fb6821c6d6dc.jpeg', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `post` VALUES (8, '你好', '你好', 3, '2026-06-02 17:15:32', 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `post` VALUES (9, '发布', '发布', 2, '2026-06-02 17:15:56', 1, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for tutorial_articles
-- ----------------------------
DROP TABLE IF EXISTS `tutorial_articles`;
CREATE TABLE `tutorial_articles`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '教程ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教程标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教程内容',
  `category` enum('maps','vehicles','weakspots') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'maps' COMMENT '分类',
  `user_id` int NOT NULL COMMENT '作者ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '作者用户名（冗余）',
  `image1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片1',
  `image2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片2',
  `image3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片3',
  `image4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片4',
  `image5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片5',
  `image6` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片6',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  `status` int NULL DEFAULT 1 COMMENT '状态：1=正常 0=隐藏',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `tutorial_articles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '教程文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tutorial_articles
-- ----------------------------
INSERT INTO `tutorial_articles` VALUES (2, '豹2A5之后的炮盾装甲弱区', '玩法偏保守，经可能的去桡侧', 'vehicles', 1, 'waerkefu', 'upload/tutorial/1c69ff64-a166-4115-a6ef-dc9ada35314a.png', 'upload/tutorial/2ae8c5f7-12ad-4290-916a-057d52e284e3.png', 'upload/tutorial/7a235a7c-5a9f-4934-87cd-ab0c1a2c3cee.png', 'upload/tutorial/9c4c16ed-bb42-4733-b1e3-01f67e6ffde3.png', 'upload/tutorial/1394edc8-021a-4eb7-9be0-a3a1b8723068.png', 'upload/tutorial/31ba1c0b-3008-4e7c-9c15-644a46d47fba.png', 10, 1, '2026-05-30 13:58:15');
INSERT INTO `tutorial_articles` VALUES (3, '阴险的狙图【莫兹多克】走线教学', '这次带来的是三点莫兹多克，地图狙位较多，适合绕侧', 'maps', 2, 'play1', 'upload/tutorial/d11e4736-a24a-416c-8fe5-468b77e67dbd.webp', 'upload/tutorial/464ad0c1-ae88-4a77-bc82-96028a3db068.jpg', 'upload/tutorial/16999689-3659-479f-abc6-24949deff4b8.webp', 'upload/tutorial/b573e55d-ba3a-4bc1-a3ff-1cc655541167.webp', NULL, NULL, 0, 1, '2026-05-30 14:13:27');
INSERT INTO `tutorial_articles` VALUES (4, '美系二战防载具弱点分析', '如图，后序内容代补\r\n这一对折叠载具实在没有什么特别突出不一致的地方，同款的炮（不过E8有硬芯）、同款的装甲，机动方面大差不差，E8的方向机比(76)W慢，可以把它俩当成换装了76炮的M4A2。\r\n三.M6A1（5.0）\r\n很多萌新第一次看到这三辆“重”坦想必都被吓了一跳，看起来厚重的装甲、硕大的车体，它甚至还有两门炮？！\r\n\r\n嘛，不必惊慌，它们三个只是徒有其表而已，除了值得一说的更为精准的76mmM7坦克炮和加装了一门37mmM3坦克炮以外，这辆车其实满满都是槽点\r\n\r\n首先便是它履带上方两块侧倾角装甲，不对这这地方来一炮完全不能证明你玩到了二级房，不论怎么摆也只有区区不到100的等效（如果你非得从对角打当我没说）是个同权重的坦克炮都能打穿。\r\n\r\n正面也相当薄弱，依靠全身上下没有一块超过100mm的装甲，在重坦所有特征中它也只占了个“重”字。\r\n\r\n而且由于成员组拥挤，代英打孔机和法棍同样能造成不错的毁伤', 'weakspots', 2, 'play1', 'upload/tutorial/fedf4377-a41b-40fe-b2a2-561fee9e0278.webp', 'upload/tutorial/c80740b3-778f-42e4-9de2-0a2950c3d120.webp', 'upload/tutorial/c4326a0a-c439-48a0-8d4a-7f0ad5d82793.webp', NULL, NULL, NULL, 1, 1, '2026-05-30 14:18:53');

-- ----------------------------
-- Table structure for tutorial_videos
-- ----------------------------
DROP TABLE IF EXISTS `tutorial_videos`;
CREATE TABLE `tutorial_videos`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `bvid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `thumbnail_url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category` enum('maps','vehicles','weakspots') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `view_count` int NULL DEFAULT 0,
  `likes` int NULL DEFAULT 0,
  `author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tutorial_videos
-- ----------------------------
INSERT INTO `tutorial_videos` VALUES (1, 'BV113576fELk', '你已经开到德顶了何不将错就错把德系玩明白 国防军并非软弱可欺！', '', 'upload/video/a3b8cfaa-4cca-467f-8cd6-cc384efac8de.png', 'vehicles', 0, 0, '瓦尔科夫斯基', '2026-05-30 12:20:52');
INSERT INTO `tutorial_videos` VALUES (2, 'BV1DVdHBEELn', '“阿尔卑斯山里最灵活的区”瑞士F/A-18C 历史&简评&实战', '', 'upload/video/ade0a607-e73c-4dce-bde7-3a91ad9a1f64.jpg', 'vehicles', 0, 0, '瓦尔科夫斯基', '2026-05-30 12:49:34');
INSERT INTO `tutorial_videos` VALUES (3, 'BV1zQ2SB9EBB', '合格的车长如何驾驶{豹F}打好“日耀之城”？（6.0）', '', 'upload/video/b2a14a83-9642-49a8-a8af-81942c272be0.png', 'maps', 0, 0, '瓦尔科夫斯基', '2026-05-30 12:55:53');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID 主键自增',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密存储)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱地址 唯一',
  `role` tinyint NOT NULL DEFAULT 1 COMMENT '权限：0=管理员 1=普通用户',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像URL/路径',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'waerkefu', '123456', '1234@qq.com', 0, 'upload/avatar/c022c026-2374-4b7e-810c-52b0129429f0.png');
INSERT INTO `user` VALUES (2, 'play1', '123456', '3214@qq.com', 1, 'upload/avatar/c0c67e5a-6425-4180-80ee-18b64f2d5aff.jpeg');
INSERT INTO `user` VALUES (3, 'play2', '123456', '3654@qq.com', 2, 'upload/avatar/5eb40c0a-727d-4e40-854c-c62b8bef21da.jpeg');
INSERT INTO `user` VALUES (4, 'play3', '123456', '7894@qq.com', 2, 'upload/avatar/173ba61d-9c4e-4afe-876f-8e45f59d7668.jpg');

SET FOREIGN_KEY_CHECKS = 1;
