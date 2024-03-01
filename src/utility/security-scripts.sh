#!/bin/zsh

# Generate a password of a certain length
passgen() {
     echo ""
     LC_ALL=C awk '{gsub("[^A-Za-z0-9!@#$%^&*=+]", ""); printf "%s", $0}' < /dev/random | head -c "$1" && echo ""
     echo ""
}

# Find the checksum of a file
checksum() {
    sha256sum "$1"
}

# Checks the expiration date for a domain
sslCheck() {
    domain="$1"
    expiration_date=$(openssl s_client -servername "$domain" -connect "$domain":443 </dev/null 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
    echo "SSL certificate for $domain expires on $expiration_date"
}

# Used to setup pathing
# Do not remove or script will not know how to find other scripts
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi

source "$(dirname "${zsh_scripts_directories["utility_scripts_dir"]}")/shared/shared-scripts.sh"

documentCommand "security" "password" "encryption" "passgen" "Generate a password of a certain length"
documentCommand "security" "sha" "encryption" "integrity" "checksum" "Find the checksum of a file"
documentCommand "security" "sha" "encryption" "integrity" "ssl" "certificate" "expiration" "sslCheck" "Checks the expiration date for a domain"