#!/bin/zsh

# Description: Monitor system monitoring information including CPU usage,
# memory usage, disk usage, and network traffic
mon() {
    echo ""
    # Check CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "CPU Usage: $cpu_usage%"

    # Check memory usage
    memory_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
    echo "Memory Usage: $memory_usage"

    # Check disk usage
    disk_usage=$(df -h | awk '$NF=="/"{printf "%s", $5}')
    echo "Disk Usage: $disk_usage"

    # Check network traffic using ss command
    network_traffic=$(ss -s | awk '/TCP/{print "TCP: " $2 " established connections, " ($3 == "" ? "0" : $3) " segments received, " ($4 == "" ? "0" : $4) " segments sent"}')
    echo "Network Traffic: $network_traffic"

    echo ""
}

# Output list of available networks, network types,
# authentication types, encryption modes, and signal band
# strengths
nwsn(){
    if [ -n "$WSL_DISTRO_NAME" ]; then
        powershell.exe -Command "netsh wlan show networks mode=Bssid"
    else
        iw dev wlan0 scan
    fi
}

# Function to list processes and PIDs of specified commands
lp() {
    # Define an array of commands to search for
    local commands=("python" "node" "shell" "bash" "sql" "ps" "grep" "cat" "echo" \
                "tail" "nano" "vim" "npm" "webpack" "ls" "cd" "mkdir" "rm" "mv" \
                "cp" "chmod" "chown" "sed" "awk" "find" "tar" "gzip" "curl" \
                "wget" "ssh" "scp" "git" "docker" "kubectl" "java" "gcc" "make" \
                "perl" "ruby" "php")

    # Iterate over each command and list its processes
    for cmd in "${commands[@]}"; do
        # pids=$(pgrep -d',' -f "$cmd")  # Get PIDs of processes matching the command
        # pids=$(pgrep -d',' -f "$cmd" | awk -v cmd="$cmd" '$0 ~ ("(^| )" cmd "( |$)") && index($0, "/") != 1 {print}')
        pids=$(pgrep -d',' -f "$cmd")
        filtered_pids=""
        for pid in $(echo "$pids" | tr ',' ' '); do
             if ps -p $pid -o cmd= | grep -q "$cmd\( \)"; then
                filtered_pids="$filtered_pids,$pid"
            fi
        done
        pids=${filtered_pids:1} 

        if [ -n "$pids" ]; then
            for pid in $(echo "$pids" | tr ',' '\n'); do
                echo "Command: $cmd"
                read -r pid ppid user cpu mem stat <<< $(ps -p $pid -o pid=,ppid=,user=,%cpu=,%mem=,stat= --no-headers)
                
                start=$(ps -p $pid -o start= --no-headers)
                cmd_output=$(ps -p $pid -o cmd= --no-headers)

                printf "%-8s %-8s %-10s %-6s %-6s %-6s %-10s %-s\n" "PID" "PPID" "USER" "%CPU" "%MEM" "STAT" "START" "COMMAND"
                printf "%-8s %-8s %-10s %-6s %-6s %-4s %-12s %-s\n" "$pid" "$ppid" "$user" "$cpu" "$mem" "$stat" "$start" "$cmd_output"
                echo
            done
        fi
    done
}

# Analyze a file and provide a word count report
# Argument:
#   Input file:  file to generate report for
#   Report file: file to write report to
anfi() {
    local input_file="$1"
    local report_file="${2:-'report.txt'}"
    
    # Check if the input file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: Input file not found."
        return 1
    fi
    
    # Perform text analysis on the input file
    cat "$input_file" | tr -s '[:space:]' '\n' | tr '[:upper:]' '[:lower:]' | \
    grep -oE '\w+' | sort | uniq -c | sort -rn > "$report_file"
}

# Analyze all files in a directory and provide a work count report for all files
# Argument:
#   Directory: directory to generate reports of
andir() {
    local directory="$1"
    
    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        echo "Error: Directory not found."
        return 1
    fi
    
    # Iterate over all files in the directory
    for file in "$directory"/*; do
        # Check if the file is a regular file (not a directory)
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local report_file="${filename%.*}_report.txt"
            
            # Analyze each file
            anfi "$file" "$report_file"
        fi
    done
}

# Function to parse text from a file and extract various types of information such as email addresses,
# phone numbers, URLs, dates, IP addresses, credit card numbers, hashtags, mentions, currency amounts,
# hexadecimal color codes, product codes, and social security numbers (SSN).
# Arguments:
#   Input File: The path to the file containing the text to be parsed.
pt() {
    local input_file="$1"

    # Extract email addresses
    echo ""
    echo "Email Addresses:"
    grep -o '\<[A-Za-z0-9._%+-]\+@[A-Za-z0-9.-]\+\.[A-Za-z]\{2,\}\>' "$input_file"
    echo ""

    # Extract phone numbers (various formats)
    echo "Phone Numbers:"
    grep -o '\(\+*\)\(\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{10\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)\)'  "$input_file"
    echo ""
    
    # Extract URLs (HTTP, HTTPS, and FTP)
    echo "URLs:"
    grep -o '\<\(https\{0,1\}\|ftp\|sftp\|file\|ssh\|telnet\|ldap\|dict\|irc\|ircs\|mailto\|news\|nntp\|gopher\|svn\|svn\+ssh\|git\|ssh\|rsync\|apt\|steam\|sip\|sips\|tel\|git\|afp\|smb\|cifs\|rtsp\|rtmp\|rtmpt\|webcal\|xmpp\|mysql\|postgresql\|mongodb\|sqlite\|redis\|rabbitmq\):\/\/[^ ]*\>' "$input_file"
    echo ""
    
    # Extract dates in MM/DD/YYYY and YYYY-MM-DD formats
    echo "Dates (MM/DD/YYYY and YYYY-MM-DD):"
    grep -o '\<[01][0-9]/[0-3][0-9]/[0-9]\{4\}\>' "$input_file"
    grep -o '\<[0-9]\{4\}-[01][0-9]-[0-3][0-9]\>' "$input_file"
    echo ""
    
    # Extract IPv4 addresses
    echo "IPv4 Addresses:"
    grep -o '\<[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\>' "$input_file"
    echo ""
    
    # Extract IPv6 addresses
    echo "IPv6 Addresses:"
    grep -o '\<[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}:[0-9a-fA-F]\{1,4\}\>' "$input_file"
    echo ""
    
    # Extract credit card numbers
    echo "Credit Card Numbers:"
    grep -o '\b\([0-9]\{1,\}[ -]*\)\{13,16\}\b' "$input_file"
    echo ""
    
    # Extract hashtags (words starting with #)
    echo "Hashtags:"
    grep -v '#[[:xdigit:]]\{3,6\}\b'  "$input_file" | grep -o '#[[:alnum:]_]\+' 
    echo ""
    
    # Extract mentions (words starting with @)
    echo "Mentions:"
    grep -o '@[[:alnum:]_]\+' "$input_file"
    echo ""
    
    # Extract currency amounts (USD, EUR, GBP, etc.)
    echo "Currency Amounts:"
    grep -o '[$€£¥₹₽₩₦฿₱₪₣₢₤₥₦₧₨₩₪][0-9]*\.*[0-9]*' "$input_file"
    echo ""
    
    # Extract hexadecimal color codes (including shorthand)
    echo "Hexadecimal Color Codes:"
    grep -o '#[[:xdigit:]]\{3,6\}\b' "$input_file"
    echo ""
    
    # Extract product codes (alphanumeric with optional hyphens)
    echo "Product Codes:"
    grep -v '\<[0-9]\{3\}-[0-9]\{2\}-[0-9]\{4\}\>' "$input_file" | 
    grep -v '\<[01][0-9]/[0-3][0-9]/[0-9]\{4\}\>' | 
    grep -v '\<[0-9]\{4\}-[01][0-9]-[0-3][0-9]\>' |
    grep -v '\b\([0-9]\{1,\}[ -]*\)\{13,16\}\b' |
    grep -v '\(\+*\)\(\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{10\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)\)' |
    grep -o '\<[A-Za-z0-9]*-[A-Za-z0-9_-]*\>'
    echo ""
    
    # Extract social security numbers (SSN) in XXX-XX-XXXX format
    echo "Social Security Numbers (SSN):"
    grep -o '\<[0-9]\{3\}-[0-9]\{2\}-[0-9]\{4\}\>' "$input_file"
    echo ""
}

# Used to setup pathing
# Do not remove or script will not know how to find other scripts
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi