#!/bin/zsh

# Prints a list of useful cheat sheets for development
resources() {
    printf "-------------------------------------------------------Resources-------------------------------------------------------\n"
    printf "1.  Git Cheat Sheet              - https://education.github.com/git-cheat-sheet-education.pdf\n"
    printf "2.  GitHub Actions Cheat Sheet   - https://docs.github.com/en/actions/learn-github-actions\n"
    printf "3.  Linux Cheat Sheet            - https://www.loggly.com/wp-content/uploads/2015/05/Linux-Cheat-Sheet-Sponsored-By-Loggly.pdf\n"
    printf "4.  Shell Scripting Cheat Sheet  - https://devhints.io/bash\n"
    printf "5.  Docker Documentation         - https://docs.docker.com/\n"
    printf "6.  SQL Cheat Sheet              - https://www.w3schools.com/sql/\n"
    printf "7.  Postgresql Cheat Sheet       - https://www.w3schools.com/postgresql/index.php\n"
    printf "8.  CSS 3 Cheat Sheet            - https://www.w3schools.com/css/default.asp\n"
    printf "9.  HTML 5 Cheat Sheet           - https://www.w3schools.com/html/default.asp\n"
    printf "10. React Cheat Sheet            - https://www.w3schools.com/react/default.asp\n"
    printf "11. NodeJS Cheat Sheet           - https://www.w3schools.com/nodejs/default.asp\n"
    printf "12. JavaScript Documentation     - https://developer.mozilla.org/en-US/docs/Web/JavaScript\n"
    printf "13. JavaScript Cheat Sheet       - https://devhints.io/es6\n"
    printf "14. TypeScript Cheat Sheet       - https://www.w3schools.com/typescript/index.php\n"
    printf "15. Python Cheat Sheet           - https://www.w3schools.com/python/default.asp\n"
    printf "16. Flask Cheat Sheet            - https://www.tutorialspoint.com/flask/flask_quick_guide.htm\n"
    printf "17. Java Documentation           - https://docs.oracle.com/en/java/\n"
    printf "18. Java Cheat Sheet             - https://www.w3schools.com/java/default.asp\n"
    printf "19. C# Programming Guide         - https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/\n"
    printf "20. MacOS Shortcuts              - https://support.apple.com/en-us/HT201236\n"
    printf "21. Webpack Cheat Sheet          - https://devhints.io/webpack\n"
    printf "22. ESLint Cheat Sheet           - https://eslint.org/docs/user-guide/configuring\n"
    printf "23. Docker Compose Cheat Sheet   - https://devhints.io/docker-compose\n"
    printf "24. CORS Cheat Sheet             - https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS\n"
    printf "25. SQLAlchemy Cheat Sheet       - https://flask-sqlalchemy.palletsprojects.com/en/3.1.x/\n"
}

# Used to setup pathing
declare -A zsh_scripts_directories
if [ -n "$ZSH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${(%):-%x}")
elif [ -n "$BASH_VERSION" ]; then
    zsh_scripts_directories["utility_scripts_dir"]=$(dirname "${BASH_SOURCE[0]}")
fi

source "$(dirname "${zsh_scripts_directories["utility_scripts_dir"]}")/shared/shared-scripts.sh"

documentCommand "help" "links" "development" "resources" "Prints a list of useful cheat sheets for development"