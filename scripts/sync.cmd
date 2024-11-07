@echo off
setlocal

rem Fetch the latest changes from the remote repository
git fetch origin main

rem Checkout the main branch
git checkout main

rem Pull updates from main branch
git pull origin main

rem Open Typora with the specified path
start "" "typora" "../docs"

rem Stage all changes
git add .

rem Initialize variables for commit messages
set "commit_message="
set "timestamp=%date% %time%"

rem Check for modified and new files
for /f "tokens=*" %%f in ('git diff --name-status') do (
    set "status=%%~f"
    for %%s in (!status!) do (
        if "%%s"=="A" (
            set "commit_message=add: %%~f - %date%"
        ) else if "%%s"=="M" (
            set "commit_message=update: %%~f - %date%"
        )
    )
)

rem If no commit message was set, use a default message
if not defined commit_message (
    set "commit_message=update: files - %date%"
)

rem Commit with the generated message
git commit -m "!commit_message!"

rem Push changes to the remote repository
git push origin main

endlocal