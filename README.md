# 🚀 New Server Setup Guide

Follow these steps to deploy this Ansible Arista Lab on a fresh server.

### 1. Clone the Repository
First, get your code onto the new server:

git clone https://github.com/xmario90/Hello-World-Repo.git
cd Hello-World-Repo

### 2. Prepare the System
The setup script handles the virtual environment, but the server needs the base Python tools first. Run this once:

sudo apt update && sudo apt install -y python3-venv python3-pip

### 3. Set Your Authentication Token
You must provide your GitHub Personal Access Token (PAT) so the script can sync your changes back to the cloud:

export TOKEN=ghp_your_token_here

### 4. Run the Master Setup Script
Execute the script to build the virtual environment, install all Ansible/Arista requirements, and verify the sync:

bash Hello-World-Repo-Readme.sh

### 📦 What this script automates:
* Self-Healing: Creates the venv folder if it is missing.
* Dependency Install: Automatically runs pip install -r requirements.txt.
* Clean Sync: Resets the local Git history to keep your repo small and fast.
* Handover: Drops you directly into the activated (venv) so you can run playbooks immediately.

---
*Maintained by xmario90*
