#!/bin/bash

################################################################################################################
# @file           autoscript_repo_manager.sh
# @brief          A script for managing repositories
# @details        This script manages multiple repositories and provides functionality to switch projects
#                 check their status, update them, maintain todo lists, and more.
#                 Ensure you have necessary permissions and prerequisites before using these functions.
#
# @author         Mohd Iskandar Putra <iskandarputra1995@gmail.com>
# @date           December 24, 2023
# @version        1.0
#
# @note           This script requires Git to be installed and properly
#                 configured for the repositories it interacts with.
#
# @warning        Improper use of certain functions might result in data loss
#                 or unexpected behavior. Use with caution.
#
# @todo           - Add error handling for edge cases
#                 - Enhance user prompts for better interaction
#                 - Improve timeout handling in repo update function
#
# @note           Please put this in your ~/.bashrc or ~/.zshrc:
#                 source "<YOUR_AUTOSCRIPT_DIR>/autoscript_repo_manager.sh"
#
#                 Make sure to RUN `source ~/.bashrc` or `source ~/.zshrc` after making changes
# @custom         find `# CUSTOMIZATION BY USER` to customize this script
################################################################################################################

# **************************************************************************************************************
# **************************************CUSTOMIZATION BY USER SECTION ******************************************

projects=(PERSONAL WORK SIDE-HUSTLE) # List of projects name to be managed
projects_links=( # List of project links to be managed
    "https://github.com/username/personal_project.git"
    "https://github.com/username/work_project.git"
    "https://github.com/username/sidehustle_project.git"
)

AUTOSCRIPT_DIR="$HOME/Documents/4-AUTO SCRIPT" # Directory where this script is stored
PERSONAL_DIR="$HOME/Documents/1-PERSONAL"      # Directory where the personal project is stored
WORK_DIR="$HOME/Documents/2-WORK"              # Directory where the work projects are stored
SIDEHUSTLE_DIR="$HOME/Documents/3-SIDEHUSTLE"  # Directory where the side hustle projects are stored

project_1_config() {
    local PROJECT_DIR=$PERSONAL_DIR
    setup_project_config "$PROJECT_DIR" \
        "project_1/clone_repo_folder_1/your_git_repo" \
        "project_1/clone_repo_folder_2/your_git_repo" \
        "project_1/clone_repo_folder_3/your_git_repo"
}

project_2_config() {
    local PROJECT_DIR=$WORK_DIR
    setup_project_config "$PROJECT_DIR" \
        "project_2/clone_repo_folder_1/your_git_repo" \
        "project_2/clone_repo_folder_2/your_git_repo" \
        "project_2/clone_repo_folder_3/your_git_repo" \
        "project_2/clone_repo_folder_4/your_git_repo" \
        "project_2/clone_repo_folder_5/your_git_repo" \
        "project_2/clone_repo_folder_6/your_git_repo" \
        "project_2/clone_repo_folder_7/your_git_repo"
}

project_3_config() {
    local PROJECT_DIR=$SIDEHUSTLE_DIR
    setup_project_config "$PROJECT_DIR" \
        "project_3/clone_repo_folder_1/your_git_repo" \
        "project_3/clone_repo_folder_2/your_git_repo"

    : <<COMMENT
    SAMPLE:
    cd Documents && mkdir workspace && cd workspace
    mkdir -p project_3/clone_repo_folder_1 && cd project_3/clone_repo_folder_1 && git clone <YOUR_GIT_REPO>
    mkdir -p project_3/clone_repo_folder_2 && cd project_3/clone_repo_folder_2 && git clone <YOUR_GIT_REPO>
    mkdir -p project_3/clone_repo_folder_3 && cd project_3/clone_repo_folder_3 && git clone <YOUR_GIT_REPO>
    ...
    

    TREE STRUCTURE (OVERVIEW):
    Documents/
    └── workspace/
          └── project_3/
              └── clone_repo_folder_1/
                  └── [contents of your cloned Git repository]


    TREE STRUCTURE (DETAILS REAL EXAMPLE):
    Documents/              
    └── 3-SIDEHUSTLE/                   
        └── IOT_Project/
            ├── CloneRepo1/
            │   └── weather_station_iot
            ├── CloneRepo2/
            │   └── weather_station_iot
            └── CloneRepo3/
                └── weather_station_iot
COMMENT
}

# Feel free to add more projects here [example: project_4_config()]...

# **************************************************************************************************************
# **********************************END OF CUSTOMIZATION BY USER SECTION ***************************************
# **********************THE REST OF SECTIONS ARE NOT RECOMMENDED TO BE MODIFIED BY USER*************************
# **************************************************************************************************************

##
# Set up project configurations based on paths.
# @param PROJECT_DIR The directory for the project.
# @param paths Array of paths for the project.
# This function sets up environment variables and aliases for each path provided
# in the paths array. It exports variables like rp1, rp2, etc., representing
# the concatenated project directory and respective paths. Additionally, it creates
# aliases in the format of '1-', '2-', etc., enabling easy navigation to each path
# with associated actions using 'autoscript_show_todo'.
setup_project_config() {
    local PROJECT_DIR=$1
    shift              # Shift arguments to access the paths directly
    local paths=("$@") # Store remaining arguments as paths array
    local size=${#paths[@]}

    for ((i = 0; i < size; i++)); do
        local index=$((i + 1))
        export rp${index}="$PROJECT_DIR/${paths[i + 1]}"
        alias ${index}-="cd \$rp${index} && autoscript_show_todo"
    done
}

# Set default project if not already set
if [ -z "$ACTIVE_PROJECT" ]; then
    ACTIVE_PROJECT=0
fi

## @brief Handles project switching and configuration
# This function manages the switching between different projects and their configurations.
# It loops through discovered project configuration functions, unsets variables beyond the maximum number,
# prompts the user to select a project, sets the active project, and sources the repository manager script.
# @return This function does not explicitly return values but handles project switching and setup.
autoscript_project_switch() {
    local max_rp=0
    local config_functions=()
    config_functions=($(declare -F | awk '/^declare -f project_/ {print $3}'))
    # Loop through discovered project configuration functions
    for config_func in "${config_functions[@]}"; do
        "$config_func"
        config_vars=($(declare -F | grep -o "$config_func.*rp[0-9]*" | grep -o 'rp[0-9]*' | sort -u))
        for var in "${config_vars[@]}"; do
            num=${var#rp}
            ((num > max_rp)) && max_rp=$num
        done
    done
    # Unset rp variables beyond the maximum number
    for ((i = max_rp + 1; i <= 10; i++)); do
        unset "rp$i"
    done
    # Project selection menu and operation based on the selected project
    local selected_project
    select selected_project in "${projects[@]}"; do
        local index
        for ((index = 0; index < ${#projects[@]}; index++)); do
            if [ $REPLY -eq $((index + 1)) ]; then
                print_line1
                echo -e "${GREEN}Switching to        : ${NC}${LBLUE}${projects[$index + 1]} PROJECT${NC}"
                echo -e "${GREEN}GITHUB Project Link : ${NC}${LBLUE}"${projects_links[$index + 1]}"${NC}"
                print_line1
                ACTIVE_PROJECT=$REPLY
                print_repo_count=true
                echo $ACTIVE_PROJECT >$AUTOSCRIPT_DIR/.autoscript_active_project
                echo -e "${GREEN}Project switch accomplished flawlessly!${NC}"
                source $AUTOSCRIPT_DIR/autoscript_repo_manager.sh
                break 2
            fi
        done
        echo -e "${RED}Invalid project selection${NC}"
        return 1
    done
}

## @brief Initializes active project and performs project configuration if available
# This block checks for an active project saved in the '.autoscript_active_project' file.
# If the active project exists, it sets up the configuration function for that project,
# generates the repository array, and counts the number of repositories. If 'print_repo_count' is set to true,
# it prints the count of detected clone repositories.
# @note This code block handles the initialization of the active project and its associated configuration.
# @note It relies on the presence of the '.autoscript_active_project' file to determine the active project.
if [ -f $AUTOSCRIPT_DIR/.autoscript_active_project ]; then
    ACTIVE_PROJECT=$(cat $AUTOSCRIPT_DIR/.autoscript_active_project)
fi
if [ -n "$ACTIVE_PROJECT" ]; then
    config_function="project_${ACTIVE_PROJECT}_config"
    if declare -f "$config_function" >/dev/null; then
        "$config_function"
        num=1
        repos=()
        while [[ -v rp$num ]]; do
            repo="rp${num}"
            repo_path=$(eval echo \$$repo)
            if [ -n "$repo_path" ]; then
                repos+=("$repo_path")
            fi
            num=$((num + 1))
        done
        num_repos="${#repos[@]}"
        if [ "$print_repo_count" = true ]; then
            echo -e "${YELLOW}Number of Detected Clone Repositories: $num_repos${NC}"
            cd $AUTOSCRIPT_DIR
        fi
    else
        echo -e "${RED}Configuration function for active project not found${NC}"
    fi
fi

#---------------------------------------------------------------------------------------------------------------

# @brief Aliases for convenience in executing specific script functions
# @details These aliases simplify the execution of specific functions within the script:
#          - 'todoreset' is an alias for 'autoscript_reset_todo()' to reset the todo list.
#          - 'repocheck' changes the directory to the script location and executes 'autoscript_repo_check()'
#          - 'repoupdate' changes the directory to the script location and executes 'autoscript_repo_update()'
#          - 'projectswitch' switchs between projects (calls autoscript_project_switch())
# @note Utilize these aliases in the terminal for easier execution of corresponding script functions.
alias todoreset='autoscript_reset_todo'
alias repocheck='autoscript_repo_check'
alias repoupdate='autoscript_repo_update'
alias projectswitch='autoscript_project_switch'

#---------------------------------------------------------------------------------------------------------------

LBLUE='\033[1;34m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
PINK='\033[1;35m'
GREY='\033[1;38m'
NC='\033[0m'

username=$(whoami)

# @fn print_line1
# @brief Prints separator line of = characters
# @details Generates visual divider using = signs for formatting.
print_line1() {
    echo -e "${GREY}=====================================================================================${NC}"
}

# @fn print_line2
# @brief Prints separator line of block characters
# @details Generates visual divider using block chars for formatting.
print_line2() {
    echo -e "${GREY}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
}

# @brief Displays or creates a todo list
# @details This function checks if a todo list exists and displays its contents if present.
#          If no todo list is found, it creates a new 'todo.txt' file by prompting the user
#          to input a description and priority for a new todo item and displays the updated list.
# @note Ensure proper permission and file system access for creating and updating 'todo.txt'.
autoscript_show_todo() {
    if [ -s "todo.txt" ]; then
        cat todo.txt
    else
        echo -e "${RED}No todo list found. Creating a new todo.txt file...${NC}"
        autoscript_insert_todo
        cat todo.txt
    fi
}

# @brief Inserts a new item into the todo list
# @details This function prompts the user to input a description and priority for a new todo item:
#          - It reads multiline input for the description and ensures it's not empty.
#          - Prompts for a priority rating (1-5 stars) and validates the input.
#          - Saves the description and priority to 'todo.txt' in the specified format.
# @note Ensure valid inputs for both description and priority to correctly update the todo list.
#       Incorrect inputs may lead to an unsuccessful update or erroneous data in 'todo.txt'.
autoscript_insert_todo() {
    echo -e "${YELLOW}Enter your TODO desc. and [press Enter] when finished OR [double press Enter] to skip:${NC}"

    # Read multiline input for description
    IFS= read -r description

    # Check if the description is not empty
    if [ -n "$description" ]; then
        echo -e "${YELLOW}Enter priority (1-5 stars) and press Enter to save:${NC}"
        read -r priority

        # Validate priority input (ensure it's between 1-5)
        if ! [[ "$priority" =~ ^[1-5]$ ]]; then
            echo -e "${RED}Invalid priority input. Please enter a number between 1 and 5.${NC}"
            return 1
        fi

        # Save the description and priority to todo.txt
        echo "$description" >todo.txt
        echo "$(printf '★%.0s' $(seq 1 "$priority"))" >>todo.txt

        echo -e "${GREEN}Todo list set.${NC}"
    else
        echo -e "${RED}Empty TODO description. Operation aborted.${NC}"
        return 1
    fi
}

# @brief Resets the todo list based on user confirmation
# @details This function prompts the user for confirmation to reset the todo list.
#          If the user confirms ('y'), the 'todo.txt' file is deleted, effectively
#          resetting the todo list. Otherwise, the function cancels the reset operation.
# @note Ensure proper backup or caution before resetting the todo list as this action is irreversible.
autoscript_reset_todo() {
    echo -e "${YELLOW}Are you sure you want to reset the todo list? (y/n)${NC}"
    read -r answer

    if [ "$answer" = "y" ]; then
        rm -f todo.txt
        echo -e "${GREEN}Todo list reset.${NC}"
    else
        echo -e "${YELLOW}Todo list reset canceled.${NC}"
    fi
}

# @brief Checks and displays the status of multiple repositories
# @details This function iterates through a list of repositories and prints their current status including:
#           - Branch information (main, development, or other branches)
#           - Working tree cleanliness or presence of untracked/uncommitted changes
#           - Displays TODO list and its priority (if 'todo.txt' exists in the repository)
#           - Handles errors for non-Git repositories or access issues
# @note Ensure 'todo.txt' is properly formatted in repositories for accurate TODO list display.
autoscript_repo_check() {
    print_line1
    print_line2
    print_line1
    echo
    echo -e "${WHITE}          Hello, ${GREEN}$username!${NC}${WHITE} Here's the current status of your repositories.${NC}"
    echo -e "${WHITE}          Project Repository: ${GREEN}${projects[$ACTIVE_PROJECT]}${NC}"

    echo
    echo
    count=0

    for repo in "${repos[@]}"; do
        ((count++))
        # Check if repo variable is empty
        if [ -z "$repo" ]; then
            echo -e "${YELLOW}${count} - No repo set, skipping${NC}"
            continue
        fi

        # Check if repo dir exists and is empty
        if [ ! "$(ls -A "$repo" 2>/dev/null)" ]; then
            echo -e "${count} - ${YELLOW}$(basename "$(dirname "$repo")")/$(basename "$repo") is empty, skipping${NC}"
            continue
        fi

        echo -e "${count}       - ${LBLUE}$(basename "$(dirname "$repo")")/$(basename "$repo")${NC}"

        if cd "$repo"; then
            branch=$(git symbolic-ref --short HEAD 2>/dev/null)

            if [ -z "$branch" ]; then
                echo -e "${RED}Error: Not a git repository${NC}"
            else
                if [[ "$branch" == "main" || "$branch" == "development" ]]; then
                    printf "${YELLOW}BRANCH  : %-30s${NC}\n" "$branch"
                else
                    printf "${WHITE}BRANCH  : %-30s${NC}\n" "$branch"
                fi

                if git diff --quiet --exit-code; then
                    untracked=$(git ls-files --others --exclude-standard)
                    if [ -z "$(echo "$untracked" | grep -v 'todo.txt')" ]; then
                        printf "${YELLOW}STATUS  : Working tree clean${NC}\n"
                    else
                        printf "${RED}STATUS  : Untracked files present | Uncommitted changes present${NC}\n"
                    fi
                else
                    printf "${RED}STATUS  : Uncommitted changes present${NC}\n"
                fi

                if [ -e "todo.txt" ]; then
                    todo_array=()
                    while IFS= read -r line || [[ -n "$line" ]]; do
                        todo_array+=("$line")
                    done <"todo.txt"
                    todo=${todo_array[1]}
                    priority=${todo_array[2]}

                    printf "${GREEN}TODO    : %-30s${NC}\n" "$todo"
                    printf "${GREEN}PRIORITY: %-30s${NC}\n" "$priority"
                else
                    echo -e "${PINK}TODO    : N/A${NC}"
                    echo -e "${PINK}PRIORITY: N/A${NC}"
                fi
            fi
            echo
        else
            echo -e "${RED}Error: Unable to access repository${NC}"
        fi
    done

    print_line1
    print_line2
    print_line1
    cd $AUTOSCRIPT_DIR
}

# @brief Updates multiple repositories based on specified branches
# @details This function iterates through a list of repositories, checks their branch status, and updates
# them if conditions are met. It performs the following tasks:
#           - Resets repository to 'origin/main' or 'origin/development' branch (if required)
#           - Performs a hard reset and update for the repository
#           - Monitors and handles timeouts during fetch and pull operations
#           - Provides status messages for each repository update
autoscript_repo_update() {

    print_line1
    print_line2
    print_line1
    echo
    echo -e "${WHITE}   Hello, ${GREEN}$username!${NC}${WHITE} I'm currently updating your repositories. Kindly await completion.${NC}"
    echo -e "${WHITE}   Project Repository: ${GREEN}${projects[$ACTIVE_PROJECT]}${NC}"
    echo
    index=1
    for repo in "${repos[@]}"; do
        sleep 0.5
        print_line1
        echo -e "\n${LBLUE}$index : $(basename "$(dirname "$repo")")/$(basename "$repo")${NC}\n"
        ((index++))
        cd "$repo" || continue

        branch=$(git symbolic-ref --short HEAD)

        if [[ "$branch" == "main" || "$branch" == "development" ]]; then
            git_status=$(git status)
            upToDate=$(echo "$git_status" | grep "Your branch is up to date")
            nothingToCommit=$(echo "$git_status" | grep "nothing to commit")

            if [ -n "$upToDate" ] && [ -n "$nothingToCommit" ]; then
                sleep 0.5

                if [ "$branch" = "main" ]; then
                    echo -e "${YELLOW}Resetting to [origin/main]${NC}"
                    git reset --hard origin/main
                elif [ "$branch" = "development" ]; then
                    echo -e "${YELLOW}Reset HARD to [origin/development]${NC}"
                    git reset --hard origin/development
                fi
                sleep 0.5
                echo -e "${YELLOW}Updating $(basename "$(dirname "$repo")")/$(basename "$repo")${NC}"

                timeout_seconds=30 # CUSTOMIZE BY USER : TIMEOUT (SECONDS) HERE
                start_time=$(date +%s)
                end_time=$((start_time + timeout_seconds))
                echo -e "${GREEN}Fetching and pulling...${NC}"
                while ! { timeout $timeout_seconds bash -c 'git fetch && git pull'; }; do
                    current_time=$(date +%s)
                    time_left=$((end_time - current_time))
                    if [ $time_left -le 0 ]; then
                        echo -e "\n${RED}Timeout reached!${NC}"
                        echo -e "${RED}$(basename "$(dirname "$repo")")/$(basename "$repo") not updated${NC}"
                        break
                    fi
                    if [ $? -eq 0 ] && [ -n "$access" ]; then
                        END_TIME=$(date +%s)
                        echo -e "\n${GREEN}$(basename "$(dirname "$repo")")/$(basename "$repo") updated${NC}"
                        echo "Time left to reach timeout=$time_left"
                        break
                    else
                        echo -e "\n${RED}Fatal error occurred. Please check your internet connection.${NC}"
                        break
                    fi
                done
            else
                echo -e "${RED}$(basename "$(dirname "$repo")")/$(basename "$repo") does not need update: Uncommitted work detected${NC}"
                echo -e "${RED}Skipping $(basename "$(dirname "$repo")")/$(basename "$repo") - Currently on $branch branch${NC}"
            fi
        else
            echo -e "${RED}Skipping $(basename "$(dirname "$repo")")/$(basename "$repo") - Currently not on origin/main OR origin/development${NC}"
            echo -e "${RED}Skipping $(basename "$(dirname "$repo")")/$(basename "$repo") - Currently on $branch branch${NC}"
        fi
    done
    print_line1
}
