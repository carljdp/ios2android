#!/bin/bash

# ios2android - a simple script to port iOS retina images to
#  the appropriate Android density buckets

# For more information: 
#  https://github.com/Ninjanetic/ios2android

# Requires Imagemagick
#  To install on Mac: brew install imagemagick

# Floating point number functions from: 
#  http://www.linuxjournal.com/content/floating-point-math-bash

############################################################
# Default scale used by float functions.

float_scale=2


############################################################
# Evaluate a floating point number expression.

function float_eval()
{
    local stat=0
    local result=0.0
    if [[ $# -gt 0 ]]
    then
        result=$(echo "scale=$float_scale; $*" | bc -q 2>/dev/null)
        stat=$?
        if [[ $stat -eq 0  &&  -z "$result" ]]
        then
            stat=1
        fi
    fi
    echo $result
    return $stat
}

############################################################
# Process images.

rm -rf drawable-ldpi
rm -rf drawable-mdpi
rm -rf drawable-hdpi
rm -rf drawable-xhdpi
rm -rf drawable-xxhdpi
rm -rf drawable-large-ldpi
rm -rf drawable-large-mdpi
rm -rf drawable-large-hdpi
rm -rf drawable-large-xhdpi
mkdir drawable-ldpi
mkdir drawable-mdpi
mkdir drawable-hdpi
mkdir drawable-xhdpi
mkdir drawable-xxhdpi
mkdir drawable-large-ldpi
mkdir drawable-large-mdpi
mkdir drawable-large-hdpi
mkdir drawable-large-xhdpi

for existingFile in *.jpg *.png; do 
    if [[ -f $existingFile ]]
    then
        if [[ ${existingFile} =~ ~ipad ]]
        then
            newFile=${existingFile/@2x~ipad./.}
            newFile=${newFile/-/_}

            if [[ ${newFile} =~ ^[0-9] ]]
            then
                newFile="img_${newFile}"
            fi

            newFile=`echo $newFile | tr "[:upper:]" "[:lower:]"`
            echo $existingFile 
            convert -resize 37.5% $existingFile drawable-large-ldpi/$newFile
            convert -resize 50% $existingFile drawable-large-mdpi/$newFile
            convert -resize 75% $existingFile drawable-large-hdpi/$newFile
            convert -resize 112.5% $existingFile drawable-large-xhdpi/$newFile 

            if [[ $# -gt "0" ]]
            then
                # if a parameter is specified, use it as a 
                #  pre-scaling value to create images targeted 
                #  for phones
                ldpi=$(float_eval "37.5 * ${1}")
                mdpi=$(float_eval "50 * ${1}")
                hdpi=$(float_eval "75 * ${1}")
                xhdpi=$(float_eval "112.5 * ${1}")
                xxhdpi=$(float_eval "150 * ${1}")
                convert -resize $ldpi% $existingFile drawable-ldpi/$newFile
                convert -resize $mdpi% $existingFile drawable-mdpi/$newFile
                convert -resize $hdpi% $existingFile drawable-hdpi/$newFile
                convert -resize $xhdpi% $existingFile drawable-xhdpi/$newFile 
                convert -resize $xxhdpi% $existingFile drawable-xxhdpi/$newFile 
            fi
        elif [[ ${existingFile} =~ @3x ]]
        then
            newFile=${existingFile/@3x./.}
            if [[ ${newFile} =~ -568h ]]
            then
                newFile=${newFile/-568h./.}
            fi

            newFile=${newFile//-/_}

            if [[ ${newFile} =~ ^[0-9] ]]
            then
                newFile="img_${newFile}"
            fi

            newFile=`echo $newFile | tr "[:upper:]" "[:lower:]"`
            echo $existingFile
            convert -resize 25% $existingFile drawable-ldpi/$newFile
            convert -resize 33% $existingFile drawable-mdpi/$newFile
            convert -resize 50% $existingFile drawable-hdpi/$newFile
            convert -resize 66.6% $existingFile drawable-xhdpi/$newFile
            cp $existingFile drawable-xxhdpi/$newFile
        else
            newFile=${existingFile/@2x./.}
            if [[ ${newFile} =~ -568h ]]
            then
                newFile=${newFile/-568h./.}
            fi
            newFile=${newFile//-/_}

            if [[ ${newFile} =~ ^[0-9] ]]
            then
                newFile="img_${newFile}"
            fi

            newFile=`echo $newFile | tr "[:upper:]" "[:lower:]"`
            echo $existingFile
            convert -resize 37.5% $existingFile drawable-ldpi/$newFile
            convert -resize 50% $existingFile drawable-mdpi/$newFile
            convert -resize 75% $existingFile drawable-hdpi/$newFile
            cp $existingFile drawable-xhdpi/$newFile 
        fi
    fi
done