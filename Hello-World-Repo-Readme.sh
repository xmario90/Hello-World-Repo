#!/bin/bash

# ==============================================================================
# --- Hello-World-Repo MASTER SETUP & GUIDE ---
#
# PURPOSE: # This script transforms a local Arista lab into a clean GitHub repository 
# and ensures the user ends up inside the (venv) workstation.
#
# GITHUB REPOSITORY CREATION STEPS:
# 1. Log in to GitHub.com.
# 2. Click the '+' icon in the top right and select 'New repository'.
# 3. Repository name: 'Hello-World-Repo'.
# 4. Set visibility to 'Public'.
# 5. IMPORTANT: Do NOT check 'Initialize this repository with a README, .gitignore, or license'.
# 6. Click 'Create repository'.
#
# WHY A TOKEN IS NEEDED:
# GitHub requires a Personal Access Token (PAT) to verify your identity when 
# pushing code from a terminal. It is more secure than a password because you 
# can limit what it can do and delete it at any time without changing your 
# main GitHub password.
#
# GITHUB TOKEN GENERATION STEPS:
# 1. Click your profile picture (top right) > Settings.
# 2. On the left sidebar, scroll to the bottom > Developer settings.
# 3. Personal access tokens > Tokens (classic).
# 4. Generate new token > Generate new token (classic).
# 5. Note: 'Lab-Sync-Token' | Expiration: 30 or 90 days.
# 6. Scopes: Check the box for 'repo' (Full control of private repositories).
# 7. Click 'Generate token' and COPY it immediately.
#
# TERMINAL TOKEN USAGE:
# Before running this script, you must paste your token into your terminal memory:
# Run: export TOKEN=ghp_your_copied_token_here
#
# EXPECTED OUTCOME:
# 1. (venv) ACTIVATION: The script shifts focus to the Python Virtual Env.
# 2. DOCUMENTATION: A 'requirements.txt' is made using the venv's libraries.
# 3. GITHUB SYNC: Local code is pushed to 'xmario90/Hello-World-Repo'.
# 4. PERSISTENCE: You remain in the (venv) terminal after the script ends.
# ------------------------------------------------------------------------------
# --- VENV EXPLANATION SECTION ---
# WHAT IS (venv)?
# It is your private "spice rack" for Python. It keeps Arista AVD libraries 
# isolated so they don't break your system or other projects.
#
# WHY WE IGNORE IT IN GIT:
# We ignore the folder because it contains 8,000+ files that are specific 
# to THIS server. We share the 'requirements.txt' list instead of the files.
# ==============================================================================
#
# The Script will do the following
# Step - 0 # SELF-HEALING INFRASTRUCTURE CHECK:
# Checks for venv tools and builds the environment if it is missing.
#
# Step - 1 # PRE-SYNC CHECK: ENTERING THE WORKSTATION:
# Verifies the venv exists and activates it for the script's use.
#
# Step - 2 # IDENTITY SETUP: 
# Configures your name and email so GitHub can track who made the changes.
#
# Step - 3 
# GENERATE ENVIRONMENT LIST: 
# Uses 'pip freeze' to save a list of installed Arista spices to requirements.txt. 
#
# Step - 4 
# SETUP GIT IGNORE: 
# Tells Git to never upload the 8,000+ venv files or temporary Python cache files.
#
# Step - 5 
# REFRESH GIT HISTORY: 
# Deletes old hidden .git folder, starts a new history, and stages only the clean files.
#
# Step - 6 
# CONNECT AND PUSH TO GITHUB: 
# Links the local folder to your GitHub account using your saved $TOKEN variable.
#
# Step - 7 
# FINAL HANDOVER: 
# Uses 'exec' to force your current terminal window into the (venv) so you are ready to work.
## ==============================================================================

# Step - 0 # SELF-HEALING INFRASTRUCTURE CHECK: 
if [ ! -d "venv" ]; then
    echo "No virtual environment found. Checking for Python tools..."
    if ! python3 -m venv --help > /dev/null 2>&1; then
        echo "------------------------------------------------"
        echo "ERROR: The package 'python3-venv' is missing."
        echo "Run: sudo apt update && sudo apt install -y python3-venv"
        echo "------------------------------------------------"
        exit 1
    fi
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    if [ -f "requirements.txt" ]; then
        pip install --upgrade pip
        pip install -r requirements.txt
    else
        pip install ansible
    fi
fi

# Step - 1 # PRE-SYNC CHECK: ENTERING THE WORKSTATION: 
if [ -f "venv/bin/activate" ]; then
    echo "Activating Virtual Environment..."
    source venv/bin/activate
else
    echo "ERROR: venv/bin/activate not found!"
    exit 1
fi

echo "Starting Clean Git Sync..."

# Step - 2 # IDENTITY SETUP: 
git config --global user.email "xmario90@users.noreply.github.com"
git config --global user.name "xmario90"

# Step - 3 # GENERATE ENVIRONMENT LIST: 
pip freeze > requirements.txt
echo "Environment list updated."

# Step - 4 # SETUP GIT IGNORE: 
echo "venv/" > .gitignore
echo "*.pyc" >> .gitignore
echo "__pycache__/" >> .gitignore

# Step - 5 # REFRESH GIT HISTORY: 
rm -rf .git
git init
git branch -M main
git add .
git commit -m "Clean automated sync"

# Step - 6 # CONNECT AND PUSH TO GITHUB: 
if [ -z "$TOKEN" ]; then
    echo "ERROR: TOKEN variable is not set!"
else
    git remote add origin https://xmario90:$TOKEN@github.com/xmario90/Hello-World-Repo.git
    git push -u origin main --force
    echo "GitHub Sync Complete!"
fi

# Step - 7 # FINAL HANDOVER: 
echo "------------------------------------------------"
echo "SETUP COMPLETE. YOU ARE NOW IN THE (venv)."
echo "------------------------------------------------"
exec bash --rcfile <(echo "source ~/.bashrc; source venv/bin/activate")
