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

for ii in *.jpg *.png; do 
    if [[ -f $ii ]]
    then
        if [[ ${ii} =~ ~ipad ]]
        then
            x=${ii/@2x~ipad./.}
            x=${x/-/_}

            if [[ ${x} =~ ^[0-9] ]]
            then
                x="img_${x}"
            fi

            x=`echo $x | tr "[:upper:]" "[:lower:]"`
            echo $ii 
            convert -resize 37.5% $ii drawable-large-ldpi/$x
            convert -resize 50% $ii drawable-large-mdpi/$x
            convert -resize 75% $ii drawable-large-hdpi/$x
            convert -resize 112.5% $ii drawable-large-xhdpi/$x 

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
                convert -resize $ldpi% $ii drawable-ldpi/$x
                convert -resize $mdpi% $ii drawable-mdpi/$x
                convert -resize $hdpi% $ii drawable-hdpi/$x
                convert -resize $xhdpi% $ii drawable-xhdpi/$x 
                convert -resize $xxhdpi% $ii drawable-xxhdpi/$x 
            fi
        elif [[ ${ii} =~ @3x ]]
        then
            x=${ii/@3x./.}
            if [[ ${x} =~ -568h ]]
            then
                x=${x/-568h./.}
            fi

            x=${x//-/_}

            if [[ ${x} =~ ^[0-9] ]]
            then
                x="img_${x}"
            fi

            x=`echo $x | tr "[:upper:]" "[:lower:]"`
            echo $ii
            convert -resize 25% $ii drawable-ldpi/$x
            convert -resize 33% $ii drawable-mdpi/$x
            convert -resize 50% $ii drawable-hdpi/$x
            convert -resize 66.6% $ii drawable-xhdpi/$x
            cp $ii drawable-xxhdpi/$x
        else
            x=${ii/@2x./.}
            if [[ ${x} =~ -568h ]]
            then
                x=${x/-568h./.}
            fi
            x=${x//-/_}

            if [[ ${x} =~ ^[0-9] ]]
            then
                x="img_${x}"
            fi

            x=`echo $x | tr "[:upper:]" "[:lower:]"`
            echo $ii
            convert -resize 37.5% $ii drawable-ldpi/$x
            convert -resize 50% $ii drawable-mdpi/$x
            convert -resize 75% $ii drawable-hdpi/$x
            cp $ii drawable-xhdpi/$x 
        fi
    fi
done