#!/bin/zsh

if [[ -z "$weather_scripts_file_sourced" ]]; then
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
fi

weather_scripts_file_sourced=true