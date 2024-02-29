#!/bin/zsh

# Uses configs to go through a website, type, click, and get content
# Arguments:
#   Config Path: path to the config to load [required]
#   ...args: any number of arguments to be used by the configs, seperated by spaces
selenium() {
    python $zsh_scripts_directories["selenium_scripts_dir"]'/selenium_script.py' $@
}

# Start xming server
# Used for wsl or headless environments
# that need a display for selenium
xming(){
    wsl.exe  "/mnt/c/Program Files (x86)/Xming/Xming.exe"  :0 -clipboard -screen 0 1000x800+125+100@1
}

install-chromedriver(){
    # Set metadata for Google Chrome repository...
    meta_data=$(curl 'https://googlechromelabs.github.io/chrome-for-testing/'\
    'last-known-good-versions-with-downloads.json')


    echo "Download the latest Chrome binary..."
    wget $(echo "$meta_data" | jq -r '.channels.Stable.downloads.chrome[0].url')

    echo "Install Chrome dependencies..."
    sudo apt install ca-certificates fonts-liberation \
        libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 \
        libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 \
        libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 \
        libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
        libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 \
        libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils -y


    echo "Unzip the binary file..."
    unzip chrome-linux64.zip

    echo "Downloading latest Chromedriver..."
    wget $(echo "$meta_data" | jq -r '.channels.Stable.downloads.chromedriver[0].url')

    echo "Unzip the binary file and make it executable..."
    unzip chromedriver-linux64.zip

    echo "Removing archive files"
    rm chrome-linux64.zip  chromedriver-linux64.zip
}

pyselinst(){
    pip install selenium==4.17.2
}

# Used to setup pathing
# Do not remove or script will not know how to find other scripts
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["selenium_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["selenium_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi

source  $zsh_scripts_directories["selenium_scripts_dir"]'/selenium-weather/selenium-weather.sh'

documentCommand "selenium" "bot" "automation" "web" "selenium" "Run a selenium config with passed arguments"
documentCommand "selenium" "server" "wsl" "graph" "xming" "Start Xming server in WSL if installed"
documentCommand "selenium" "bot" "install" "pyselinst" "Install Selenium==4.17.2 for Python"