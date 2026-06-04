# 📺 Bilibili 视频缩略图获取指南

## 方法一：手动获取缩略图（最简单）

1. 打开 Bilibili 视频页面
2. 右键点击视频封面或视频播放器中的缩略图
3. 选择"复制图片地址"或"检查元素"查看图片 URL

## 方法二：使用 Bilibili API 格式

Bilibili 缩略图的标准格式：

```
https://i0.hdslb.com/bfs/archive/[CID].jpg
```

其中 `CID` 是视频的分P ID，可以从视频页面获取。

## 方法三：使用 BV 号直接访问（推荐）

使用以下格式可以获取视频的缩略图：

```
https://api.bilibili.com/x/web-interface/view?bvid=BV号
```

访问这个接口可以获取完整的视频信息，包括缩略图 URL。

## 方法四：快捷获取方法

你可以使用以下网站快速获取视频信息：
- https://bilivideo.com/
- https://bilibili.iiilab.com/

## 常用缩略图尺寸

| 尺寸 | 说明 |
|------|------|
| 640x360 | 标准封面 |
| 320x180 | 小缩略图 |
| 480x270 | 中缩略图 |

## 示例代码

如果你想在浏览器中通过 BV 号获取视频信息，可以使用：

```javascript
async function getVideoInfo(bvid) {
    try {
        const response = await fetch(`https://api.bilibili.com/x/web-interface/view?bvid=${bvid}`);
        const data = await response.json();
        if (data.code === 0) {
            return {
                title: data.data.title,
                thumbnail: data.data.pic,
                author: data.data.owner.name,
                desc: data.data.desc
            };
        }
    } catch (error) {
        console.error('获取视频信息失败', error);
    }
}
```

## 注意事项

⚠️ **重要提示**：
- 直接使用 Bilibili API 可能存在跨域问题
- 建议使用后端代理或手动复制缩略图 URL
- 遵守 Bilibili 的服务条款，不要滥用 API

## 快速示例

对于 BV 号 `BV1GJ411x7h7`：
- 你可以直接在浏览器中打开视频，右键复制封面图片地址
- 或者使用 API 获取完整的视频信息

在我们的管理页面中，你可以：
1. 先在 Bilibili 找到想要的视频
2. 右键视频封面，复制图片地址
3. 粘贴到"缩略图URL"输入框中
4. 或者点击"自动获取视频信息"按钮尝试自动获取