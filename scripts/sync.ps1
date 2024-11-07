# Set the working directory to the repository location
Set-Location -Path "..\your-repo-path"

# Pull only the main branch
git fetch origin main
git checkout main
git pull origin main

# Open Typora with the docs directory
Start-Process "typora" "..\docs"

# Stage all changes
git add .

# Get the status of changed files
$changedFiles = git status --porcelain | Select-String "^\s*[AM]\s+" | ForEach-Object { $_.Line.Trim() -replace "^\s*[AM]\s+", "" }
$addedFiles = git status --porcelain | Select-String "^\s*??\s+" | ForEach-Object { $_.Line.Trim() -replace "^\s*??\s+", "" }

# Commit changes with appropriate messages
foreach ($file in $changedFiles) {
    git commit -m "update: $file - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

foreach ($file in $addedFiles) {
    git commit -m "add: $file - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

# Push the changes
git push

# Hide the PowerShell window
$ps = [System.Diagnostics.Process]::GetCurrentProcess()
$ps.MainWindowHandle = 0