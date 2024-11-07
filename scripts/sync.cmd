@echo off

git pull origin main

typora ../docs

git add .

for /f %%i in ('git diff --cached --name-only --diff-filter=ACMR') do (
    git diff --cached --name-status "%%i" | findstr /R "^M" > nul
    if %errorlevel% EQU 0 (
        git commit -m "update: %%i - %date%"
    ) else (
        git commit -m "add: %%i - %date%"
    )
)

git push origin main
