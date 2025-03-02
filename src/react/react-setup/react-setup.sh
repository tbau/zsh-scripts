#!/bin/bash


if [[ -z "$react_setup_file_sourced" ]]; then
    cur_dir="${zsh_scripts_directories["react_setup_scripts_dir"]}"
    setup-project(){
        while true; do
            echo "Setup Project:"
            echo "1. Frontend"
            echo "2. Backend"
            read -r choice
            case $choice in
                1) setup_frontend; break ;;
                2) setup_backend; break ;;
                *) echo "Invalid choice. Please enter 1 or2" ;;
            esac
        done
    }

    setup_frontend(){
        while true; do
            echo "Select Frontend Framework:"
            echo "1. React"
            echo "2. Vue"
            echo "3. Svelte"
            echo "4. NextJs"
            echo "5. Angular"
            echo "6. No Framework"            
            read -r choice

            case $choice in
                1) setup_react; break ;;
                2) setup_vue; break ;;
                3) setup_svelte; break ;;
                4) setup_nextjs; break ;;
                5) setup_angular; break ;;
                6) setup_with_no_framework; break ;;
                *) echo "Invalid choice. Please enter 1 or2" ;;
            esac
        done
    }

    setup_backend(){
        echo "Setting up backend projects not implemented yet"
    }


    # Sets up a new react app from scratch configured for manual editing of configs
    setup_react(){
        # npm init -y
        # npm install react react-dom --save
        # npm install @babel/core @babel/preset-env @babel/preset-react --save-dev 
        # npm install webpack webpack-cli webpack-dev-server babel-loader css-loader style-loader html-webpack-plugin typescript @types/react @types/react-dom eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin --save-dev
        cp $cur_dir/webpack.config.js .
        cp $cur_dir/.babelrc .
        cp $cur_dir/tsconfig.json .
        cp $cur_dir/.eslintrc .
        cp $cur_dir/.eslintignore .

        setup_state_management

        setup_test_framework
    }

    setup_vue(){
        echo "Setting up vue not implemented yet"
    } 
    setup_svelte(){
        echo "Setting up svelte not implemented yet"
    }
    setup_nextjs(){
        echo "Setting up nextjs not implemented yet"
    }
    setup_angular(){
        echo "Setting up angular not implemented yet"
    }
    setup_with_no_framework(){
        setup_test_framework
    }
    # Function to setup Jest
    setup_jest() {
        echo "Setting up Jest..."
        # Add commands to set up Jest here
    }

    # Function to setup Mocha
    setup_mocha() {
        echo "Setting up Mocha..."
        # Add commands to set up Mocha here
    }

    # Function to display the menu and read user input
    setup_test_framework() {
       while true; do        
            echo "Select a test framework:"
            echo "1. Jest"
            echo "2. Mocha"
            echo "3. None"
            read -r choice
            case $choice in
                1) setup_jest; break ;;
                2) setup_mocha; break ;;
                3) echo "No test framework selected"; break ;;
                *) echo "Invalid choice. Please enter 1, 2, or 3" ;;
            esac
        done
    }

    setup_state_management(){
        while true; do        
            echo "Select a state management library:"
            echo "1. Redux"
            echo "2. Recoil"
            echo "3. None"
            read -r choice
            case $choice in
                1) setup_redux; break ;;
                2) setup_recoil; break ;;
                3) echo "No state management framework selected"; break ;;
                *) echo "Invalid choice. Please enter 1, 2, or 3" ;;
            esac
        done
    }

    setup_redux(){
        cp -r $cur_dir/redux/src src
    }

    setup_recoil(){        
        npm install recoil
        cp -r $cur_dir/recoil/src src
    }

    # Used to setup pathing
    # Do not remove or script will not know how to find other scripts
    declare -A zsh_scripts_directories
    if [ -n "$ZSH_VERSION" ]; then
        zsh_scripts_directories["react_setup_scripts_dir"]=$(dirname "${(%):-%x}")
    elif [ -n "$BASH_VERSION" ]; then
        zsh_scripts_directories["react_setup_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
    fi

    source "$(dirname "$(dirname "${zsh_scripts_directories["react_setup_scripts_dir"]}")")/shared/shared-scripts.sh"

    documentCommand "development" "commands" "setup" "new" "project" "configure" "setup-project" "Sets up a new project from scratch and setups various frameworks for both frontend and backend"
fi

react_setup_file_sourced=true