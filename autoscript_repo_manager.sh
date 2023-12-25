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

#---------------------------------------------------------------------------------------------------------------
# @brief Script for switch between projects
# @details Provides project selection menu and functions to switch between
# pre-configured projects by managing environment exports and aliases.
# @var projects List of available projects

# **************************************************************************************************************
# **************************************CUSTOMIZATION BY USER SECTION ******************************************

# List of projects
projects=("PERSONAL" "PROJECT_1" "PROJECT_2")  # CUSTOMIZATION BY USER
AUTOSCRIPT_DIR="$HOME/Documents/4-AUTO SCRIPT" # CUSTOMIZATION BY USER
WORK_DIR="$HOME/Documents/3-WORK/"             # CUSTOMIZATION BY USER

project_1_config() { # CUSTOMIZATION BY USER
    export rp1=$AUTOSCRIPT_DIR/workspace/RM1/repos_management
    export rp2=$AUTOSCRIPT_DIR/workspace/RM2/repos_management
    export rp3=$AUTOSCRIPT_DIR/workspace/RM3/repos_management
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'
    alias 3-='cd $rp3 && autoscript_show_todo'
}

project_2_config() {     # CUSTOMIZATION BY USER
    export rp1=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp2=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp3=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp4=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp5=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp6=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp7=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'
    alias 3-='cd $rp3 && autoscript_show_todo'
    alias 4-='cd $rp4 && autoscript_show_todo'
    alias 5-='cd $rp5 && autoscript_show_todo'
    alias 6-='cd $rp6 && autoscript_show_todo'
    alias 7-='cd $rp7 && autoscript_show_todo'
}

project_3_config() {     # CUSTOMIZATION BY USER
    export rp1=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    export rp2=$WORK_DIR #</Your/Path/To/Your/Work/Git/Repo>
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'
}

# Feel free to add more projects here..
# **************************************************************************************************************
# **********************************END OF CUSTOMIZATION BY USER SECTION ***************************************

# Set default project if not already set
if [ -z "$ACTIVE_PROJECT" ]; then
    ACTIVE_PROJECT=0
fi

# @fn autoscript_project_switch
# @brief Presents project selection menu
# @details Presents select menu with projects. Calls function to perform
# project switch if valid selection made, else prints error.
autoscript_project_switch() {
    select project in "${projects[@]}"; do
        case $REPLY in
        1)
            autoscript_project_switch_operation 1
            break
            ;;
        2)
            autoscript_project_switch_operation 2
            break
            ;;
        3)
            autoscript_project_switch_operation 3
            break
            ;;
        *)
            echo -e "${RED}Invalid project selection${NC}"
            return 1
            ;;
        esac
    done
}

# @fn autoscript_show_todo
# @brief Displays or creates todo list
# @details Checks if todo list file exists & displays contents if present,
# else creates new file by prompting for new todo item.
autoscript_project_switch_operation() {
    unset rp1 rp2 rp3 rp4 rp5 rp6 rp7 rp8 rp9 rp10 # Unset existing exports
    case $1 in
    1)
        echo -e "${GREEN}Switching to ${projects[1]} PROJECT${NC}"
        ACTIVE_PROJECT=1
        ;;
    2)
        echo -e "${GREEN}Switching to ${projects[2]} PROJECT${NC}"
        ACTIVE_PROJECT=2
        ;;
    3)
        echo -e "${GREEN}Switching to ${projects[3]} PROJECT${NC}"
        ACTIVE_PROJECT=3
        ;;
    *)
        echo -e "${RED}Invalid project selection${NC}"
        return 1
        ;;
    esac
    print_repo_count=true
    # Store project selection and refresh environment
    echo $ACTIVE_PROJECT >$AUTOSCRIPT_DIR/.autoscript_active_project
    echo -e "${GREEN}Project switch successful!${NC}"
    source $AUTOSCRIPT_DIR/autoscript_repo_manager.sh
}

# @brief Initialize active project on shell start
# Checks if the autoscript_active_project file exists, and if so sets the
# ACTIVE_PROJECT variable to the saved selection. This ensures the previously
# active project is restored when opening a new shell session.
if [ -f $AUTOSCRIPT_DIR/.autoscript_active_project ]; then
    ACTIVE_PROJECT=$(cat $AUTOSCRIPT_DIR/.autoscript_active_project)
fi

# @fn get_num_rps
# @brief Get number of defined rp export variables
# @details Loops through rp export variables rp1 to rpN
# and returns number of defined variables.
# @return Number of defined rp export variables
get_num_rps() {
    num=1
    while [[ -v rp$num ]]; do
        num=$((num + 1))
    done

    echo $((num - 1))
}

# @fn generate_repos_array
# @brief Generate repos array from rp exports
# @details Loops through defined rp exports, extracts the
# file paths, and populates repos array with paths.
# @return repos Array containing repository paths
generate_repos_array() {
    repos=()
    num_rps=$(get_num_rps)
    for ((i = 1; i <= num_rps; i++)); do
        repo="rp${i}"
        repo_path=$(eval echo \$$repo)
        if [ -n "$repo_path" ]; then
            repos+=("$repo_path")
        fi
    done
}

# Set project config based on selection
if [ $ACTIVE_PROJECT = 1 ]; then
    project_1_config
    num_rps=$(get_num_rps)
    generate_repos_array
    if [ "$print_repo_count" = true ]; then
        echo "Detected Clone Repos: $num_rps"
    else
    fi
elif [ $ACTIVE_PROJECT = 2 ]; then
    project_2_config
    num_rps=$(get_num_rps)
    generate_repos_array
    if [ "$print_repo_count" = true ]; then
        echo "Detected Clone Repos: $num_rps"
    else
    fi
elif [ $ACTIVE_PROJECT = 3 ]; then
    project_3_config
    num_rps=$(get_num_rps)
    generate_repos_array
    if [ "$print_repo_count" = true ]; then
        echo "Detected Clone Repos: $num_rps"
    else
    fi
fi

#---------------------------------------------------------------------------------------------------------------
# @brief Aliases for convenience in executing specific script functions
# @details These aliases simplify the execution of specific functions within the script:
#          - 'todoreset' is an alias for 'autoscript_reset_todo()' to reset the todo list.
#          - 'todoinsert' is an alias for 'autoscript_insert_todo()' to add new items to the todo list.
#          - 'repocheck' changes the directory to the script location and executes 'autoscript_repo_check()'
#          - 'repoupdate' changes the directory to the script location and executes 'autoscript_repo_update()'
#          - 'projectswitch' switchs between projects (calls autoscript_project_switch())
# @note Utilize these aliases in the terminal for easier execution of corresponding script functions.
alias todoreset='autoscript_reset_todo'
alias todoinsert='autoscript_insert_todo'
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
    echo -e "${YELLOW}Enter your TODO description and press Enter when finished:${NC}"

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
        echo -e "${RED}Empty TODO description. Please enter a description.${NC}"
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
    echo -e "${NC}           Hi $username! Here is the current status of your repository.${NC}"
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
            echo -e "${count} - ${YELLOW}$repo is empty, skipping${NC}"
            continue
        fi

        echo -e "${count} - ${LBLUE}$repo${NC}"

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
    echo -e "${NC}      Hi $username! I'm currently updating your repositories. Kindly await completion.${NC}"
    echo
    index=1
    for repo in "${repos[@]}"; do
        sleep 0.5
        print_line1
        echo -e "\n${LBLUE}Repo $index: $repo${NC}\n"
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
                    echo -e "${YELLOW}Resetting to origin/main${NC}"
                    git reset --hard origin/main
                elif [ "$branch" = "development" ]; then
                    echo -e "${YELLOW}Reset HARD to origin/development${NC}"
                    git reset --hard origin/development
                fi
                sleep 0.5
                echo -e "${YELLOW}Updating $repo${NC}"

                timeout_seconds=20
                start_time=$(date +%s)
                end_time=$((start_time + timeout_seconds))
                echo "Fetching and pulling..."
                while ! { timeout $timeout_seconds bash -c 'git fetch && git pull'; }; do
                    current_time=$(date +%s)
                    time_left=$((end_time - current_time))
                    if [ $time_left -le 0 ]; then
                        echo -e "\n${RED}Timeout reached!${NC}"
                        echo -e "${RED}$repo not updated${NC}"
                        break
                    fi
                    if [ $? -eq 0 ] && [ -n "$access" ]; then
                        END_TIME=$(date +%s)
                        echo -e "\n${GREEN}$repo updated${NC}"
                        echo "Time left to reach timeout=$time_left"
                        break
                    else
                        echo -e "\n${RED}Fatal error occurred. Please check your internet connection.${NC}"
                        break
                    fi
                done
            else
                echo -e "${RED}$repo does not need update: Uncommitted work detected${NC}"
                echo -e "${RED}Skipping $repo - Currently on $branch branch${NC}"
            fi
        else
            echo -e "${RED}Skipping $repo - Currently not on origin/main OR origin/development${NC}"
            echo -e "${RED}Skipping $repo - Currently on $branch branch${NC}"
        fi
    done
    print_line1
}
