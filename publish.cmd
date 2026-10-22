@echo off
chcp 65001 >nul
setlocal
title Publish Pooh site to GitHub Pages
cd /d "%~dp0"

set "OWNER=gaolenmanbo666-glitch"
set "REPO=pooh-keychain"
set "URL=https://github.com/%OWNER%/%REPO%.git"
if not "%~1"=="" set "URL=%~1"

echo ============================================================
echo   Publish plush-3d site to GitHub Pages
echo   Target: %URL%
echo ============================================================
echo.

if not exist ".git" goto NOSETUP

echo [1/4] Check working tree...
git status --porcelain > "%TEMP%\pc_status.txt" 2>nul
for %%A in ("%TEMP%\pc_status.txt") do if %%~zA GTR 0 (
  echo       committing local changes...
  git add -A
  git commit -m "chore: update site" >nul
) else (
  echo       clean.
)
del "%TEMP%\pc_status.txt" >nul 2>&1

echo [2/4] Set remote...
git remote remove origin >nul 2>&1
git remote add origin "%URL%"

echo [3/4] Push main (a browser window may pop up - click Authorize)...
git branch -M main
git push -u origin main
if errorlevel 1 goto PUSHFAIL

echo [4/4] Open Pages settings...
set "WEB=%URL:.git=%"
start "" "%WEB%/settings/pages"
timeout /t 2 >nul
start "" "%WEB%"

echo.
echo ============================================================
echo  DONE. Two last steps:
echo    1. On the Pages page that just opened:
echo         Source = Deploy from a branch
echo         Branch = main    Folder = / (root)    then Save
echo    2. Wait 1 minute, then open:
echo         https://%OWNER%.github.io/%REPO%/
echo ============================================================
pause
exit /b 0

:NOSETUP
echo [ERROR] Not a git repository. Put this file inside the site folder.
pause
exit /b 1

:PUSHFAIL
echo.
echo ============================================================
echo  [FAILED] Push did not succeed. Most likely:
echo    1. The repo does not exist yet - create a PUBLIC repo first
echo       (do NOT tick "Add a README"):
echo       https://github.com/new?name=%REPO%^&visibility=public
echo    2. The authorization window was closed - run this file again.
echo ============================================================
start "" "https://github.com/new?name=%REPO%^&visibility=public"
pause
exit /b 1
