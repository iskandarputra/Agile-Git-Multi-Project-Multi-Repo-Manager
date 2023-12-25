# 🤖 Auto Script Repo Manager

This comprehensive Bash script is engineered to streamline the management of multiple Git repositories. It offers an array of functionalities for project switching, status checks, updates, TODO list management, and more.

## 🌟 Overview

- **Project Switch**: Easily switch between pre-configured projects via a selection menu, ensuring a smooth shift between projects.
- **Environment Restoration**: Restore the most recent active project upon initiating a new shell session, ensuring continuity and ease for frequent project switches.
- **Shortcut Aliases**: Efficiently navigate to repositories using intuitive aliases, reducing manual directory traversal and enhancing productivity.
- **Repository Status Check**:
  - Display comprehensive Git branch information.
  - Assess the cleanliness of the working tree, indicating untracked/uncommitted changes.
  - Highlight persistent TODO lists within repositories, along with their priority, facilitating task management within project spaces.
- **Repository Updates**:
  - Resets repositories to `main` or `development` branches and fetches the latest changes.
  - Handle timeouts and errors during updates, ensuring reliable and robust repository updates.
- **Persistent TODO List**: Maintain persistent TODO lists within repositories, enabling effective task management within project environments.
- **Enhanced Visual Formatting**: Provides clear and readable output for an enhanced user experience.


## 🚀 Installation

### Prerequisites

- Git is required for using this script.

### Steps

1. **Clone this repository**:

   ```bash
   git clone https://github.com/your-username/auto-script-repo-manager.git
   ```
2. **Add the following line to your ~/.bashrc or ~/.zshrc**:

   ```bash
    source "/path/to/autoscript_repo_manager.sh"
   ```
   Remember to execute source ~/.bashrc or source ~/.zshrc after making changes.

## 👨‍💻 Usage

1. **Project Switch**:

  ```bash
  projectswitch
  ```

2. **Check Repository Status**:
   
  ```bash
  repocheck
  ```

3. **Update Repositories**:

  ```bash
  repoupdate
  ```

4. **Manage TODO List**:
     - To view TODO list:

      ```bash
      1-  # Navigate to the first repository
      ```
     - To reset the TODO list:

     ```bash
      todoreset
      ```
## 🛠️ Customization
Tailor the script to your needs:

- **Projects**: Modify project names and associated directories.
- **Repository Cloning**: Add more repositories to manage.
- **Functionality Enhancement**: Extend functionality to suit specific requirements.

### Projects Configuration & Repository Management
Adjust project names and their associated directories to align with your project structure. Add or remove projects as needed:

```bash
# Modify project names and directories
projects=("Project1" "Project2" "Project3")
AUTOSCRIPT_DIR="$HOME/Documents/autoscript"
WORK_DIR="$HOME/Documents/work/"

# Define configurations for each project
project_1_config() {
    export rp1=$AUTOSCRIPT_DIR/projects/Project1
    export rp2=$AUTOSCRIPT_DIR/projects/Project2
    # Add more repositories for Project1 configuration
}

project_2_config() {
    export rp1=$WORK_DIR/Project2
    export rp2=$WORK_DIR/AnotherProject2
    # Add more repositories for Project2 configuration
}

# Add more project configurations as required
```

## 🤝 Contribution
Contributions, suggestions, or bug reports are welcome! Feel free to open issues or pull requests.
