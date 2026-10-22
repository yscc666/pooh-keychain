# 蜂蜜罐小熊 · 照片驱动的 3D 重建

一个纯静态单页站点，用来展示并下载这个根据 6 张参考照片重建的**毛绒小熊蜂蜜罐钥匙扣**模型。

**在线地址：<https://yscc666.github.io/pooh-keychain/>**

- 交互式 3D 查看器（Google model-viewer，本地打包，无 CDN 依赖）
- 规格 / 建模过程 / 布线 / 材质 / 下载 五个章节
- 6 张原始参考照片、照片与渲染并排对比、轮廓叠差图
- 支持灯箱、AR、`prefers-reduced-motion`

```
.
├── index.html                      单页
├── favicon.svg
├── .nojekyll                       GitHub Pages 跳过 Jekyll
├── publish.cmd                     双击即可重新发布
├── assets/
│   ├── css/style.css
│   ├── js/app.js
│   ├── vendor/model-viewer.min.js   model-viewer 4.4.0（1.0 MB，ES Module）
│   ├── model/
│   │   ├── pooh_keychain.glb        56,184 三角面 · 7 材质
│   │   └── pooh_keychain.blend      Blender 工程（含灯光相机）
│   └── img/                         全部为 WebP
└── README.md
```

## 本地预览

`model-viewer` 通过 `fetch` 读取 GLB，`file://` 直接双击会被 CORS 拦，必须起一个本地服务器：

```bash
python -m http.server 8099        # Python 3
npx serve .                       # Node
```

然后打开 <http://127.0.0.1:8099/>。

> 所有资源均已本地化：`assets/vendor/model-viewer.min.js` 是自注册 ESM 包
> （用 `type="module"` 引入），不依赖 CDN，断网也能正常显示模型。

## 更新站点

改完文件后，二选一：

- **双击 `publish.cmd`** —— 自动提交、推送，并打开 Pages 设置页。
- 命令行：`git add -A && git commit -m "update" && git push`

Pages 会在推送后 30–90 秒自动重建。

## 修改内容

| 想改 | 改哪里 |
|---|---|
| 文案、规格数字 | `index.html` |
| 配色、间距、字体 | `assets/css/style.css` 顶部的 `:root` 变量 |
| 模型 | 替换 `assets/model/pooh_keychain.glb`（保持文件名） |
| 图片 | 替换 `assets/img/*.webp`，建议宽度 ≤ 1000 px、质量 85 |
| 默认视角 | `index.html` 里 `<model-viewer>` 的 `camera-orbit` |

## 许可

- **代码**（HTML / CSS / JS / 本 README）：MIT
- **3D 模型**（`.glb` / `.blend`）与渲染图：由照片重建的衍生作品，版权归作者所有；
  如需公开授权建议 CC BY 4.0，并把署名写进本文件。
- **model-viewer**：© Google LLC，Apache-2.0 / BSD-3-Clause，见包内 license 头。

---

模型规格：单一水密主体 · 56,184 三角面 · 17 个命名部件 · 7 个基础 PBR 材质 ·
真实尺寸 69 × 61 × 151 mm · 与照片剪影 IoU 0.837。
