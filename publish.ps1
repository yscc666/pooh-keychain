# 一键发布到 GitHub Pages
#
#   .\publish.ps1 -RepoUrl https://github.com/<用户名>/pooh-keychain.git
#
# 需要：已安装 git，且已配置 GitHub 凭据（SSH key 或 Personal Access Token）。

param(
  [Parameter(Mandatory = $true)]
  [string]$RepoUrl,

  [string]$Branch = "main",
  [switch]$EnableWorkflow
)

$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

if (-not (Test-Path ".git")) { throw "当前目录不是 git 仓库，请在 site/ 目录下运行本脚本。" }

if ($EnableWorkflow) {
  $wfDir = ".github/workflows"
  New-Item -ItemType Directory -Path $wfDir -Force | Out-Null
  @"
name: Deploy static site to Pages
on:
  push:
    branches: [$Branch]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: true
jobs:
  deploy:
    environment:
      name: github-pages
      url: `${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: actions/upload-pages-artifact@v3
        with:
          path: .
      - id: deployment
        uses: actions/deploy-pages@v4
"@ | Set-Content -LiteralPath (Join-Path $wfDir "pages.yml") -Encoding utf8
  Write-Host "已生成 .github/workflows/pages.yml" -ForegroundColor Green
  git add .github 2>$null
  git commit -m "ci: deploy to GitHub Pages" 2>$null
}

git remote remove origin 2>$null
git remote add origin $RepoUrl
git branch -M $Branch
Write-Host "推送到 $RepoUrl ($Branch) ..." -ForegroundColor Cyan
git push -u origin $Branch

Write-Host ""
Write-Host "推送完成。最后两步：" -ForegroundColor Green
Write-Host "  1) 仓库 Settings -> Pages -> Source: Deploy from a branch"
Write-Host "     Branch: $Branch   Folder: / (root)  ->  Save"
if ($EnableWorkflow) {
  Write-Host "     （或 Source: GitHub Actions，如果启用了 -EnableWorkflow）"
}
Write-Host "  2) 等待 1 分钟，站点地址形如 https://<用户名>/<仓库名>/"
