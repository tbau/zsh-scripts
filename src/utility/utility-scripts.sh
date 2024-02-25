#!/bin/zsh

# Gets the weather
# Refer to https://wttr.in/:help for more information
# Args: 
#   Location: location to find the weather for
#   Unit: m for metric or  f for fahrenheit
weather(){
    echo ""
    if [[ "$2" == "m" ]]; then    
        curl 'wttr.in/'$1'?mF'
    elif [[ "$2" == "f" ]]; then
        curl 'wttr.in/'$1'?uF'
    fi
    echo ""
}

# Gets the unit passed to the function and outputs help info
# Arguments
#   Function Name:  name of the function for the help info, i.e. 
#                   the function calling this function 
#   Unit:           argument from command line, either m for metric 
#                   or f for fahrenheit
#   Default Unit:   default value for the unit
get-unit(){
    unit="$3"
    if [[ -n "$2" ]]; then
        if [[ "$2" == "m" ]]; then
            unit="m"
        elif [[ "$2" == "f" ]]; then
            unit="f"
        else
            echo ""
            echo "Usage: "$1" [OPTION]..."
            echo ""
            echo -n "Arguments: m for metric or f for fahrenheit"
            unit=""
        fi;
    fi;
}

# Gets the weather in London
gwlouk(){
    get-unit $0 $1 "m"
    weather "London,%20England" "$unit"
}

# Gets the weather in Paris
gwpafr(){
    get-unit $0 $1 "m"
    weather "Paris,%20France" "$unit"
}

# Gets the weather in Tokyo
gwtoja(){
    get-unit $0 $1 "m"
    weather "Tokyo,%20Japan" "$unit"
}

# Gets the weather in Sydney
gwsyau(){
    get-unit $0 $1 "m"
    weather "Sydney,%20Australia" "$unit"
}

# Gets the weather in Berlin
gwbede(){
    get-unit $0 $1 "m"
    weather "Berlin,%20Germany" "$unit"
}

# Gets the weather in Rome
gwroit(){
    get-unit $0 $1 "m"
    weather "Rome,%20Italy" "$unit"
}

# Gets the weather in Moscow
gwmoru(){
    get-unit $0 $1 "m"
    weather "Moscow,%20Russia" "$unit"
}

# Gets the weather in Beijing
gwbjcn(){
    get-unit $0 $1 "m"
    weather "Beijing,%20China" "$unit"
}

# Gets the weather in Cairo
gwcaeg(){
    get-unit $0 $1 "m"
    weather "Cairo,%20Egypt" "$unit"
}

# Gets the weather in Rio de Janeiro
gwrdjbr(){
    get-unit $0 $1 "m"
    weather "Rio%20de%20Janeiro,%20Brazil" "$unit"
}

# US cities
# Gets the weather in New York, NY
gwnyny(){
    get-unit $0 $1 "f"
    weather "New%20York,%20NY" "$unit"
}

# Gets the weather in Chicago, IL
gwchil(){
    get-unit $0 $1 "f"
    weather "Chicago,%20IL" "$unit"
}

# Gets the weather in Phoenix, AZ
gwphaz(){
    get-unit $0 $1 "f"
    weather "Phoenix,%20AZ" "$unit"
}

# Gets the weather in Philadelphia, PA
gwphpa(){
    get-unit $0 $1 "f"
    weather "Philadelphia,%20PA""$unit"
}

# Gets the weather in Houston, TX
gwhotx(){
    get-unit $0 $1 "f"
    weather "Houston,%20TX" "$unit"
}

# Gets the weather in Dallas, TX
gwdatx(){
    get-unit $0 $1 "f"
    weather "Dallas,%20TX" "$unit"
}

# Gets the weather in San Antonio, TX
gwsatx(){
    get-unit $0 $1 "f"
    weather "San%20Antonio,%20TX" "$unit"
}

# Gets the weather in Los Angeles, CA
gwlaca(){
    get-unit $0 $1 "f"
    weather "Los%20Angeles,%20CA" "$unit"
}

# Gets the weather in San Diego, CA
gwsdca(){
    get-unit $0 $1 "f"
    weather "San%20Diego,%20CA" "$unit"
}

# Gets the weather in San Jose, CA
gwsjca(){
    get-unit $0 $1 "f"
    weather "San%20Jose,%20CA" "$unit"
}

# Gets the weather in Nashville, TN
gwnatn(){
    get-unit $0 $1 "f"
    weather "Nashville,%20TN" "$unit"
}

# Description: Display system monitoring information including CPU usage,
# memory usage, disk usage, and network traffic
monitor() {
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

# Analyze a file and provide a word count report
# Argument:
#   Input file:  file to generate report for
#   Report file: file to write report to
analyze_file() {
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
analyze_dir() {
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
            analyze_file "$file" "$report_file"
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