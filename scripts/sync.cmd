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

rem Commit with the current date
git commit -m "%date%"

rem Push changes to the remote repository
git push origin main

endlocal