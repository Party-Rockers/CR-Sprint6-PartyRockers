
#!/bin/bash

# All of the branches and remote repositories
# that the last commit will be pushed to.
current_branch=$(git rev-parse --abbrev-ref HEAD)
push_branch_origin=(
    "origin:main"
    "origin:feature/github-pipeline"
    "origin:feature/aws-pipeline"
    "bitbucket:main"
)

# Add all files to the commit.
git add -A

# Verify changes
echo "Are you sure you want to push the following changes?"
echo "----------------------------------------------------"
echo $(git diff --cached --name-only)
echo "----------------------------------------------------"

# Ask for confirmation.
read -p "Press [Enter] key to continue..."

# Enter your commit message.
echo 
echo "----------------------------------------------------"
echo "Enter your commit message for these changes."
echo "----------------------------------------------------"
read commit_message

# Commit the changes.
git commit -m "$commit_message"

echo "----------------------------------------------------"
echo "Are you sure you want to push to the following branches?"
echo "${push_branch_origin[@]}"
echo "----------------------------------------------------"

# Ask for confirmation.
read -p "Press [Enter] key to continue..."

echo "----------------------------------------------------"
echo "Pushing to branches..."
echo

# Push the changes to the remote repositories.
for remote_branch in "${push_branch_origin[@]}"; do
    remote=${remote_branch%:*}
    branch=${remote_branch#*:}

    random_number=$(( ( RANDOM % 100000000 )  + 1 ))
    git checkout -b $random_number "$remote"/"$branch"
    git cherry-pick "$current_branch" -m 1

    echo "Pushing to $remote/$branch..."
    git push "$remote" "$random_number":"$branch"
    echo "Pushed to $remote/$branch!"

    git checkout "$current_branch"
    git branch -D $random_number
done

echo
echo "Pushed to all branches!"