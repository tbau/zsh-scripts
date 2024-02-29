
#!/bin/zsh

# Uses the selenium weather.com config to get the weather
# Arguments:
#   location: argument to be used by the config, location to search
sgw(){
    dir=$(pwd)
    cd "$(dirname $(dirname "${zsh_scripts_directories["selenium_scripts_dir"]}"))"
    python $zsh_scripts_directories["selenium_scripts_dir"]'/start_selenium.py'  $zsh_scripts_directories["selenium_scripts_dir"]'/configs/weather.com/weather.com.json' $@
    cd $dir
}

# Gets the weather in London
sgwlouk(){
    sgw "London, England"
}

# Gets the weather in Paris
sgwpafr(){
    sgw "Paris, France"
}

# Gets the weather in Tokyo
sgwtoja(){
    sgw "Tokyo, Japan"
}

# Gets the weather in Sydney
sgwsyau(){
    sgw "Sydney, Australia"
}

# Gets the weather in Berlin
sgwbede(){
    sgw "Berlin, Germany"
}

# Gets the weather in Rome
sgwroit(){
    sgw "Rome, Italy"
}

# Gets the weather in Moscow
sgwmoru(){
    sgw "Moscow, Russia"
}

# Gets the weather in Beijing
sgwbjcn(){
    sgw "Beijing, China"
}

# Gets the weather in Cairo
sgwcaeg(){
    sgw "Cairo, Egypt"
}

# Gets the weather in Rio de Janeiro
sgwrdjbr(){
    sgw "Rio de Janeiro, Brazil"
}

# US cities
# Gets the weather in New York, NY
sgwnyny(){
    sgw "New York, NY"
}

# Gets the weather in Chicago, IL
sgwchil(){
    sgw "Chicago, IL"
}

# Gets the weather in Phoenix, AZ
sgwphaz(){
    sgw "Phoenix, AZ"
}

# Gets the weather in Philadelphia, PA
sgwphpa(){
    sgw "Philadelphia, PA"
}

# Gets the weather in Houston, TX
sgwhotx(){
    sgw "Houston, TX"
}

# Gets the weather in Dallas, TX
sgwdatx(){
    sgw "Dallas, TX"
}

# Gets the weather in San Antonio, TX
sgwsatx(){
    sgw "San Antonio, TX"
}

# Gets the weather in Los Angeles, CA
sgwlaca(){
    sgw "Los Angeles, CA"
}

# Gets the weather in San Diego, CA
sgwsdca(){
    sgw "San Diego, CA"
}

# Gets the weather in San Jose, CA
sgwsjca(){
    sgw "San Jose, CA"
}

# Gets the weather in Nashville, TN
sgwnatn(){
    sgw "Nashville, TN"
}
