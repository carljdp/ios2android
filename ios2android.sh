#!/bin/bash

# F U N C S

# Evaluate a floating point number expression.
float_eval () {
    local decimalPrecision=2
    local calcExitCode=0
    local calcResult=0.0

    if [[ $# -gt 0 ]] # count of args > 0 ?
    then
        calcResult=$(echo "scale=$decimalPrecision; $*" | bc -q 2>/dev/null)
        calcExitCode=$? # exit code of preceding statement
        if [[ $calcExitCode -eq 0  &&  -z "$calcResult" ]] # result was 0
        then
            calcExitCode=1
        fi
    fi
    echo $calcResult
    return $calcExitCode
}

# Original main script converting all images in current dir
ios2android () {

main () {

    echo "[ios2android] remove output directories"
    rm -rf drawable-ldpi
    rm -rf drawable-mdpi
    rm -rf drawable-hdpi
    rm -rf drawable-xhdpi
    rm -rf drawable-xxhdpi
    rm -rf drawable-large-ldpi
    rm -rf drawable-large-mdpi
    rm -rf drawable-large-hdpi
    rm -rf drawable-large-xhdpi

    echo "[ios2android] re-create output directories"
    mkdir drawable-ldpi
    mkdir drawable-mdpi
    mkdir drawable-hdpi
    mkdir drawable-xhdpi
    mkdir drawable-xxhdpi
    mkdir drawable-large-ldpi
    mkdir drawable-large-mdpi
    mkdir drawable-large-hdpi
    mkdir drawable-large-xhdpi

    for existingFile in *.jpg *.png  # any file or dir match
    do 
        if [[ -f "$existingFile" ]]  # exists and is a regular file
        then
            echo "[ios2android] processing ./$existingFile"
            if [[ "$existingFile" =~ ~ipad ]]  # case-insensitive match
            then
                newFile="${existingFile/@2x~ipad./.}"  # remove @2x~ipad

                newFile="${newFile/-/_}"  # replace - with _
                if [[ "$newFile" =~ ^[0-9] ]]  # regex starts with digit
                then
                    newFile="img_$newFile"  # prefix with img_
                fi

                newFile="$(echo "$newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case

                convert -resize 37.5% "$existingFile" "drawable-large-ldpi/$newFile"
                convert -resize 50% "$existingFile" "drawable-large-mdpi/$newFile"
                convert -resize 75% "$existingFile" "drawable-large-hdpi/$newFile"
                convert -resize 112.5% "$existingFile" "drawable-large-xhdpi/$newFile"

                # # TODO - refactor this to not rely on arg $1
                # if [[ $# -gt "0" ]]  # count of args > 0 ?
                # then
                #    # if a parameter is specified, use it as a 
                #    #  pre-scaling value to create images targeted 
                #    #  for phones
                #    ldpi="$( float_eval "37.5 * ${1}" )"
                #    mdpi="$( float_eval "50 * ${1}" )"
                #    hdpi="$( float_eval "75 * ${1}" )"
                #    xhdpi="$( float_eval "112.5 * ${1}" )"
                #    xxhdpi="$( float_eval "150 * ${1}" )"
                #    convert -resize "$ldpi%" "$existingFile" "drawable-ldpi/$newFile"
                #    convert -resize "$mdpi%" "$existingFile" "drawable-mdpi/$newFile"
                #    convert -resize "$hdpi%" "$existingFile" "drawable-hdpi/$newFile"
                #    convert -resize "$xhdpi%" "$existingFile" "drawable-xhdpi/$newFile"
                #    convert -resize "$xxhdpi%" "$existingFile" "drawable-xxhdpi/$newFile"
                # fi

            elif [[ "$existingFile" =~ @3x ]]  # case-sensitive match
            then
                newFile="${existingFile/@3x./.}"  # remove @3x

                if [[ "$newFile" =~ -568h ]]  # contains
                then
                    newFile="${newFile/-568h./.}"  # remove -568h
                fi

                newFile="${newFile//-/_}"  # replace - with _
                if [[ "$newFile" =~ ^[0-9] ]]  # starts with digit
                then
                    newFile="img_$newFile"  # prefix with img_
                fi

                newFile="$(echo "$newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case

                convert -resize 25% "$existingFile" "drawable-ldpi/$newFile"
                convert -resize 33% "$existingFile" "drawable-mdpi/$newFile"
                convert -resize 50% "$existingFile" "drawable-hdpi/$newFile"
                convert -resize 66.6% "$existingFile" "drawable-xhdpi/$newFile"
                cp "$existingFile" "drawable-xxhdpi/$newFile"  # copy original
            else
                newFile="${existingFile/@2x./.}"  # remove @2x

                if [[ "$newFile" =~ -568h ]]  # contains
                then
                    newFile="${newFile/-568h./.}"  # remove -568h
                fi

                newFile="${newFile//-/_}"  # replace - with _
                if [[ "$newFile" =~ ^[0-9] ]]  # starts with digit
                then
                    newFile="img_$newFile"  # prefix with img_
                fi

                newFile="$(echo "$newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case

                convert -resize 37.5% "$existingFile" "drawable-ldpi/$newFile"
                convert -resize 50% "$existingFile" "drawable-mdpi/$newFile"
                convert -resize 75% "$existingFile" "drawable-hdpi/$newFile"
                cp "$existingFile" "drawable-xhdpi/$newFile"  # copy original
            fi
        fi
    done
}

# M A I N 

if [[ -d "${1:-.}" ]]
then
    declare -g -r absInputDir="$( realpath "${1:-'.'}" )"
else
    echo "Invalid input dir: $1" && exit 1
fi

if [[ -d "${2:-.}" ]]
then
    declare -g -r absOutputDir="$( realpath "${2:-'.'}" )"
else
    echo "Invalid output dir: $2" && exit 1
fi

# R U N
echo -e "\n[ios2android] --- START ---"

ios2android

echo -e "[ios2android] ---- END ----\n"
