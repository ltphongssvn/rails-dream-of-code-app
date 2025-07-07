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

If you're collaborating with your classmate and want to see what they're working on, you can fetch their branches without affecting your work:

```bash
# Update your local repository with all remote branches
git fetch origin

# List all branches including your classmate's
git branch -a

# If you see your classmate's feature branch, you can peek at their work
# without switching to it
git log origin/feature/week1-YourClassmateName --oneline
```

Remember, the goal of this workflow is to keep everyone's work organized and prevent conflicts.


