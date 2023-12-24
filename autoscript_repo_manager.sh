#!/bin/bash

################################################################################################################
# @file           autoscript_repo_manager.sh
# @brief          A script for managing repositories
# @details        This script manages multiple repositories and provides functionality to swap projects
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
#                 source "/home/isz/Documents/4-AUTO SCRIPT/autoscript_repo_manager.sh"
#
#                 make sure to RUN source ~/.bashrc or ~/.zshrc after making changes
################################################################################################################

#---------------------------------------------------------------------------------------------------------------
# @brief Script for swapping between projects
# Provides project selection menu and functions to swap between a set of
# pre-configured projects by managing environment exports and aliases.
# Restores last active project when starting a new shell session.

# Set default project if not already set
if [ -z "$ACTIVE_PROJECT" ]; then
    ACTIVE_PROJECT=0
fi

# @brief Presents project selection menu and swaps project
# Presents a select menu with project choices.
# Calls autoscript_project_swap_operation() to perform the project swap if a valid
# selection is made, or prints an error message if invalid.
#
autoscript_project_swap() {
    select project_num in "PERSONAL" "WORK_PROJECT_A" "WORK_PROJECT_B"; do
        if [ "$project_num" = "PERSONAL" ]; then
            autoscript_project_swap_operation 1
            return
        elif [ "$project_num" = "WORK_PROJECT_A" ]; then
            autoscript_project_swap_operation 2
            return
        elif [ "$project_num" = "WORK_PROJECT_B" ]; then
            autoscript_project_swap_operation 3
            return
        else
            echo "Invalid selection"
        fi
    done
}

# @brief Swaps to the selected project
# Performs project swap by unsetting repo exports, resetting aliases, storing
# the new selection, exporting project directories, and setting aliases.
autoscript_project_swap_operation() {
    unset rp1 rp2 rp3 rp4 rp5 rp6 rp7 # Unset existing exports
    unalias 1- 2- 3- 4- 5- 6- 7-      # Reset aliases
    case $1 in
    1)
        echo "Switching to PERSONAL PROJECT"
        ACTIVE_PROJECT=1
        ;;
    2)
        echo "Switching to WORK PROJECT A"
        ACTIVE_PROJECT=2
        ;;
    3)
        echo "Switching to WORK PROJECT B"
        ACTIVE_PROJECT=3
        ;;
    *)
        echo "Invalid project selection"
        return 1
        ;;
    esac

    # Store project selection and refresh environment
    echo $ACTIVE_PROJECT >~/Documents/4-AUTO\ SCRIPT/autoscript_active_project
    echo "Project switch successful!"
    source ~/Documents/4-AUTO\ SCRIPT/autoscript_repo_manager.sh
}

# @brief Initialize active project on shell start
# Checks if the autoscript_active_project file exists, and if so sets the
# ACTIVE_PROJECT variable to the saved selection. This ensures the previously
# active project is restored when opening a new shell session.
if [ -f ~/Documents/4-AUTO\ SCRIPT/autoscript_active_project ]; then
    ACTIVE_PROJECT=$(cat ~/Documents/4-AUTO\ SCRIPT/autoscript_active_project)
fi

# @brief Set project repo exports and aliases
# Exports the directory paths for the selected project's repos and creates
# shortcut aliases to navigate to them
if [ $ACTIVE_PROJECT = 1 ]; then
    export rp1=~/Documents/4-AUTO\ SCRIPT/workspace/RM1/repos_management
    export rp2=~/Documents/4-AUTO\ SCRIPT/workspace/RM2/repos_management
    export rp3=~/Documents/4-AUTO\ SCRIPT/workspace/RM3/repos_management
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'
    alias 3-='cd $rp3 && autoscript_show_todo'

elif [ $ACTIVE_PROJECT = 2 ]; then
    export rp1=~/Documents/ # <Put your next project repo path here...>
    export rp2=~/Documents/ # <Put your next project repo path here...>
    export rp3=~/Documents/ # <Put your next project repo path here...>
    export rp4=~/Documents/ # <Put your next project repo path here...>
    export rp5=~/Documents/ # <Put your next project repo path here...>
    export rp6=~/Documents/ # <Put your next project repo path here...>
    export rp7=~/Documents/ # <Put your next project repo path here...>
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'
    alias 3-='cd $rp3 && autoscript_show_todo'
    alias 4-='cd $rp4 && autoscript_show_todo'
    alias 5-='cd $rp5 && autoscript_show_todo'
    alias 6-='cd $rp6 && autoscript_show_todo'
    alias 7-='cd $rp7 && autoscript_show_todo'

elif [ $ACTIVE_PROJECT = 3 ]; then
    export rp1=~/Documents/ # <Put your next project repo path here...>
    export rp2=~/Documents/ # <Put your next project repo path here...>
    alias 1-='cd $rp1 && autoscript_show_todo'
    alias 2-='cd $rp2 && autoscript_show_todo'

# Add additional project repo exports and aliases here...
fi

#---------------------------------------------------------------------------------------------------------------
# @brief Aliases for convenience in executing specific script functions
# @details These aliases simplify the execution of specific functions within the script:
#          - 'todoreset' is an alias for 'autoscript_reset_todo()' to reset the todo list.
#          - 'todoinsert' is an alias for 'autoscript_insert_todo()' to add new items to the todo list.
#          - 'repocheck' changes the directory to the script location and executes 'autoscript_repo_check()'
#          - 'repoupdate' changes the directory to the script location and executes 'autoscript_repo_update()'
#          - 'projectswap' Swaps between projects (calls autoscript_project_swap())
# @note Utilize these aliases in the terminal for easier execution of corresponding script functions.
alias todoreset='autoscript_reset_todo'
alias todoinsert='autoscript_insert_todo'
alias repocheck='autoscript_repo_check'
alias repoupdate='autoscript_repo_update'
alias projectswap='autoscript_project_swap'

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

# @brief Array containing paths to multiple repositories
# @details This array stores the paths to multiple repositories for management purposes.
#          Each element (index) in the array represents the path to a specific repository.
#          Modify or add elements to include paths to additional repositories as needed.
repos=(
    "$rp1"
    "$rp2"
    "$rp3"
    "$rp4"
    "$rp5"
    "$rp6"
    "$rp7"
)

# @brief Prints separator lines for visual formatting
# @details These functions generate separator lines with different designs for visual distinction.
#          - 'print_line1()' generates a line of equal signs for a clear division.
#          - 'print_line2()' generates a line with block characters for a unique separation.
# @note These functions aid in visual organization and separation of sections within the output.
#       Modify the design elements within the functions for different visual styles if needed.
print_line1() {
    echo -e "${GREY}=====================================================================================${NC}"
}
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
    cd "/home/isz/Documents/4-AUTO SCRIPT"
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
