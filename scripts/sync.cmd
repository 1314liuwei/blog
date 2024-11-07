@echo off
git fetch origin main:main
git merge origin/main
typora ../docs
git add .
for /f "tokens=*" %%a in ('git status --porcelain') do (
    set status=%%a
    set firstchar=!status:~0,1!
    if "!firstchar!"=="M" (
        set action=update
    ) else if "!firstchar!"=="A" (
        set action=add
    )
    set filename=!status:~3!
    git commit -m "!action!:!filename! - %date%"
)
git push