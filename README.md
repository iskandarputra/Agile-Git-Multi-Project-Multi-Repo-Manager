# 🤖 Auto Script Repo Manager

This Bash script streamlines managing multiple Git repositories, facilitating project swapping, status checks, updates, TODO list management, and more.

## 🌟 Overview

- **Project Swap**: Easily switch between pre-configured projects via a selection menu.
- **Environment Restoration**: Restores the last active project when starting a new shell session.
- **Shortcut Aliases**: Quickly navigate to repositories using intuitive aliases.
- **Repository Status Check**:
  - Displays Git branch information.
  - Assesses the cleanliness of the working tree.
  - Highlights the presence of a TODO list and its priority.
- **Repository Updates**:
  - Resets repositories to `main` or `development` branches and fetches the latest changes.
  - Handles timeouts and errors during updates.
- **Persistent TODO List**: Maintains a persistent TODO list within repositories.
- **Enhanced Visual Formatting**: Provides clear and readable output.

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

1. **Project Swap**:

  ```bash
  projectswap
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
Feel free to customize the script according to your needs:

- **Projects**: Modify project names and associated directories.
- **Repository Cloning**: Add more repositories to manage.
- **Functionality Enhancement**: Extend functionality to suit specific requirements.

## 🤝 Contribution
Contributions, suggestions, or bug reports are welcome! Feel free to open issues or pull requests.
