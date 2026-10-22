# 蜂蜜罐小�?· 照片驱动�?3D 重建

一个纯静态单页站点，用来展示并下载这个根�?6 张参考照片重建的**毛绒小熊蜂蜜罐钥匙扣**模型�?
- 交互�?3D 查看器（Google [model-viewer]，本地打包，无外链依赖）
- 规格 / 建模过程 / 布线 / 材质 / 下载 五个章节
- 照片与渲染的并排对比、轮廓叠差图
- 深浅适配排版，支�?`prefers-reduced-motion`

```
.
├── index.html                  单页
├── favicon.svg
├── .nojekyll                   GitHub Pages 跳过 Jekyll
├── assets/
�?  ├── css/style.css
�?  ├── js/app.js
�?  ├── vendor/model-viewer.min.js   model-viewer 4.4.0�?.0 MB，ES Module�?�?  ├── model/
�?  �?  ├── pooh_keychain.glb        56,184 三角�?· 7 材质
�?  �?  └── pooh_keychain.blend      Blender 工程（含灯光相机�?�?  └── img/                         全部�?WebP
└── README.md
```

## 本地预览

`model-viewer` 通过 `fetch` 读取 GLB，`file://` 直接双击会被 CORS 拦，必须起一个本地服务器�?
```bash
# 任选一�?python -m http.server 8099        # Python 3
npx serve .                       # Node
```

然后打开 <http://127.0.0.1:8099/>�?
> 本站已在无外网环境下自测：所有资源本地化，`assets/vendor/model-viewer.min.js`
> �?ESM 自注册包（`type="module"`），不依�?CDN�?
## 部署�?GitHub Pages

### 方式 0：双�?`publish.cmd`（推荐，无需命令行）

1. 先建仓库：打开 <https://github.com/new?name=pooh-keychain&visibility=public>
   �?**Public**�?*不要**勾�?“Add a README�?�?Create repository�?2. 双击本目录下�?**`publish.cmd`**。它会自动提交、绑�?`origin`�?   推�?`main`，然后打开 Pages 设置页与仓库首页�?3. �?Pages 页里设置：Source = **Deploy from a branch**�?   Branch = **main** / Folder = **/ (root)** �?Save�?4. 等约 1 分钟，打开 `https://<用户�?.github.io/pooh-keychain/`�?
> 换账号或换仓库名时，可带参数运行：`publish.cmd https://github.com/�?仓库.git`

### 方式 A：有 gh CLI

```bash
gh repo create pooh-keychain --public --source=. --remote=origin --push
gh api -X POST repos/{owner}/pooh-keychain/pages \
  -f 'source[branch]=main' -f 'source[path]=/'
```

### 方式 B：纯命令�?
1. �?GitHub 新建一�?**public** 仓库（例�?`pooh-keychain`），**不要**勾选初始化 README�?2. 在本目录执行�?
```bash
git remote add origin https://github.com/<你的用户�?/pooh-keychain.git
git branch -M main
git push -u origin main
```

3. 仓库 �?**Settings �?Pages** �?*Build and deployment*
   �?Source: **Deploy from a branch** �?Branch: **main** / **/(root)** �?Save�?4. 等一分钟，访�?`https://<你的用户�?.github.io/pooh-keychain/`�?
### 方式 C：仓库里已带工作流（可选）

如果想让每次 `git push` 自动发布，把 `publish.ps1` 里的
`enable-workflow` 分支打开即可生成 `.github/workflows/pages.yml`�?
## 修改内容

| 想改 | 改哪�?|
|---|---|
| 文案、规格数�?| `index.html` |
| 配色、间距、字�?| `assets/css/style.css` 顶部�?`:root` 变量 |
| 模型 | 替换 `assets/model/pooh_keychain.glb`（保持文件名�?|
| 图片 | 替换 `assets/img/*.webp`，建议宽�?�?1000 px、质�?85 |
| 默认视角 | `index.html` �?`<model-viewer>` �?`camera-orbit` |

## 许可

- **代码**（HTML / CSS / JS / �?README）：MIT
- **3D 模型**（`.glb` / `.blend`）与渲染图：由照片重建的衍生作品，版权归你所有；
  若想公开授权，建�?CC BY 4.0，并把署名写进本文件�?- **model-viewer**：�?Google LLC，Apache-2.0 / BSD-3-Clause，见包内 license 头�?
---

模型规格：单一水密主体 · 56,184 三角�?· 17 个命名部�?· 7 个基础 PBR 材质 ·
真实尺寸 69 × 61 × 151 mm · 与照片剪�?IoU 0.837�?