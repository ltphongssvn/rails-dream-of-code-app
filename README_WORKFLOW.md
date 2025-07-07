Every time you sit down to code, start with this routine:
```bash
# Update your local repository with any changes from GitHub
git fetch origin

# Switch to develop and update it
git checkout develop
git pull origin develop

# Create or switch to your feature branch
git checkout -b feature/week1-ThanhPhongLe  # if creating new
# or
git checkout feature/week1-ThanhPhongLe     # if it already exists

# Check your status to see where you are
git status
```
