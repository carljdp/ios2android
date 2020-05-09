#!/bin/bash

#===========================================================
# F U N C T I O N   D E L A R A T I O N S

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

# Process image (all sizes)
function_processImageFile () {

    set -x -e

    typeset -r f_currentInputWorkingDir="$1"
    typeset -r f_currentOutputWorkingDir="$2"
    typeset -r f_existingFile="$3"

    if [[ -f "$f_currentInputWorkingDir/$f_existingFile" ]]  # exists and is a regular file
    then
        if [[ "$f_existingFile" =~ ~ipad ]]  # case-insensitive match
        then
            local f_newFile="${f_existingFile/'@2x~ipad.'/'.'}"  # remove @2x~ipad

            f_newFile="${f_newFile/-/_}"  # replace - with _
            if [[ "$f_newFile" =~ ^[0-9] ]]  # regex starts with digit
            then
                f_newFile="img_$f_newFile"  # prefix with img_
            fi

            f_newFile="$(echo "$f_newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case

            convert -resize 37.5% "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-large-ldpi/$f_newFile"
            convert -resize 50% "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-large-mdpi/$f_newFile"
            convert -resize 75% "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-large-hdpi/$f_newFile"
            convert -resize 112.5% "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-large-xhdpi/$f_newFile"

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
            #    convert -resize "$ldpi%" 
            #        "$f_currentInputWorkingDir/$f_existingFile" \
            #        "$f_currentOutputWorkingDir/drawable-ldpi/$f_newFile"
            #    convert -resize "$mdpi%" 
            #        "$f_currentInputWorkingDir/$f_existingFile" \
            #        "$f_currentOutputWorkingDir/drawable-mdpi/$f_newFile"
            #    convert -resize "$hdpi%" 
            #        "$f_currentInputWorkingDir/$f_existingFile" \
            #        "$f_currentOutputWorkingDir/drawable-hdpi/$f_newFile"
            #    convert -resize "$xhdpi%" 
            #        "$f_currentInputWorkingDir/$f_existingFile" \
            #        "$f_currentOutputWorkingDir/drawable-xhdpi/$f_newFile"
            #    convert -resize "$xxhdpi%" 
            #        "$f_currentInputWorkingDir/$f_existingFile" \
            #        "$f_currentOutputWorkingDir/drawable-xxhdpi/$f_newFile"
            # fi

        elif [[ "$f_existingFile" =~ @3x ]]  # case-sensitive match
        then
            local f_newFile="${f_existingFile/'@3x.'/'.'}"  # remove @3x

            if [[ "$f_newFile" =~ -568h ]]  # contains
            then
                f_newFile="${f_newFile/-568h./.}"  # remove -568h
            fi

            f_newFile="${f_newFile//-/_}"  # replace all - with _
            if [[ "$f_newFile" =~ ^[0-9] ]]  # starts with digit
            then
                f_newFile="img_$f_newFile"  # prefix with img_
            fi

            f_newFile="$(echo "$f_newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case

            convert -resize 25% \
                "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-ldpi/$f_newFile"
            convert -resize 33% \
                "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-mdpi/$f_newFile"
            convert -resize 50% \
                "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-hdpi/$f_newFile"
            convert -resize 66.6% \
                "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-xhdpi/$f_newFile"
            cp "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-xxhdpi/$f_newFile"  # copy original
        else
            local f_newFile="${f_existingFile/'@2x.'/'.'}"  # remove @2x

            if [[ "$f_newFile" =~ -568h ]]  # contains
            then
                f_newFile="${f_newFile/-568h./.}"  # remove -568h
            fi

            f_newFile="${f_newFile//-/_}"  # replace all - with _
            if [[ "$f_newFile" =~ ^[0-9] ]]  # starts with digit
            then
                f_newFile="img_$f_newFile"  # prefix with img_
            fi

            f_newFile="$(echo "$f_newFile" | tr "[:upper:]" "[:lower:]")"  # to lower-case
            convert -resize 37.5% \
            "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-ldpi/$f_newFile"
            convert -resize 50% \
            "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-mdpi/$f_newFile"
            convert -resize 75% \
            "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-hdpi/$f_newFile"
            cp "$f_currentInputWorkingDir/$f_existingFile" \
                "$f_currentOutputWorkingDir/drawable-xhdpi/$f_newFile"  # copy original
        fi
    fi

}

# Make pipe-able function
pipable_function_processImageFile () {

    if [[ "$#" -eq "2" ]] # stdin is 3rd arg
    then
        typeset stdinLine
        while IFS= read -es stdinLine
        do
            function_processImageFile "$@" "$stdinLine"
        done

    elif [[ "$#" -eq "3" ]] # ignore stdin
    then
        function_processImageFile "$@"

    else
        echo "$FUNCNAME expected 3 args (2 when piped)" >&2
        exit 1
    fi
}

# Process directory (all images)
function_processImageDir () {
    # function args to local vars; remove trailing slash
    typeset -r f_absInputTopDir="${1%/}"
    typeset -r f_absOutputTopDir="${2%/}"
    typeset -r f_relativeWorkingDir="${3%/}"

    typeset -r f_currentInputWorkingDir="$f_absInputTopDir/$f_relativeWorkingDir"
    typeset -r f_currentOutputWorkingDir="$f_absOutputTopDir/$f_relativeWorkingDir"

    # remove all output dirs, in case the input changed
    #  since the previous run time this script ran
    rm -rf "$f_currentOutputWorkingDir/drawable-ldpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-mdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-hdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-xhdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-xxhdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-large-ldpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-large-mdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-large-hdpi"
    rm -rf "$f_currentOutputWorkingDir/drawable-large-xhdpi"
    # re-create all output dirs, in case the input changed
    #  since the previous run time this script ran
    mkdir -p "$f_currentOutputWorkingDir/drawable-ldpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-mdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-hdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-xhdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-xxhdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-large-ldpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-large-mdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-large-hdpi"
    mkdir -p "$f_currentOutputWorkingDir/drawable-large-xhdpi"

    # find images and process
    echo "$( find "$f_currentInputWorkingDir" -type f -maxdepth 1 -printf '%P\n' )" \
        | egrep -i '\.(png|jpg)$' \
        | pipable_function_processImageFile "$f_currentInputWorkingDir" "$f_currentOutputWorkingDir"

}

# Make pipe-able function
pipable_function_processImageDir () {

    if [[ "$#" -eq "2" ]] # stdin is 3rd arg
    then
        typeset stdinLine
        while IFS= read -es stdinLine
        do
            function_processImageDir "$@" "$stdinLine"
        done

    elif [[ "$#" -eq "3" ]] # ignore stdin
    then
        function_processImageDir "$@"

    else
        echo "$FUNCNAME expected 3 args (2 when piped)" >&2
        exit 1
    fi
}

# Print all comments from this file containing 3 hashes
printTripleHashComments () {
    typeset -r tab='    '
    echo -e "$( cat "$0" | egrep -o "#{3}.*" \
        | sed -E "s/#{3}//g" \
        | sed -E "s/_/$tab/g" \
    )"
}

#===========================================================
# M A I N   S C R I P T


echo -e "[ios2android] > INIT"


# TripleHashComment for help file
###\n ios2android [OPT OPTARG] [FILE]\n


# ARGUMENTS passed to this script (defaults)
typeset -g ARG_inputDir="./input"
typeset -g ARG_outputDir="./output"
typeset errCount=0


OPTERR=0  # don't let getopts handle errors
OPTIND=1  # reset getopt index incase it was already used
while getopts ":hli:o:" opt
do
    case $opt in
        l ) ### _-l_List input directories containing images 
            echo "-l NOT IMPLEMENTED" >&2
            ;;
        i ) ### _-i_Input root directory (trailing slash optional).
            ARG_inputDir="$OPTARG"
            ;;
        o ) ### _-o_Output root directory (trailing slash optional).
            ARG_outputDir="$OPTARG"
            ;;
        v ) ### _-v_Verbose logging.
            echo "-l NOT IMPLEMENTED" >&2
            ;;
        h ) ### _-h_Display help.
            printTripleHashComments
            exit 0
            ;;
        \?)
            echo "Invalid option: $OPTARG" >&2
            errCount=$((errCount+1))
            ;;
        : )
            echo "Required argument not found: $OPTARG " >&2
            errCount=$((errCount+1))
            ;;
    esac
done
# `getopts` does not autoshift like `getopt`
# Discard all options and sentinel `--`
shift "$((OPTIND-1))"
# Now "$@" contains only args


# TripleHashComment ###\n End of help file.\n


# Exit if preceding OPTS checks failed
if [[ "$errCount" -gt 0 ]]
then
    echo "  ..for help run $0 -h"
    exit 1
fi


# TODO - move into a validator function
if [[ -d "$ARG_inputDir" ]]
then
    echo "[ debug-log ] Input directory: $ARG_inputDir"
else
    echo "Can't find output directory: $ARG_inputDir" >&2
    errCount=$((errCount+1))
fi


# TODO - move into a validator function
if [[ -d "$ARG_outputDir" ]]
then
    echo "[ debug-log ] Output directory: $ARG_outputDir"
else
    echo "Can't find output directory: $ARG_outputDir" >&2
    errCount=$((errCount+1))
fi


# Exit if preceding ARGS checks failed
if [[ "$errCount" -gt 0 ]]
then
    echo "  ..for help run $0 -h"
    exit 1
fi


echo -e "[ios2android] > START processing of files"


typeset -g -r GLO_absInputTopDir="$( realpath "$ARG_inputDir")"
echo "[ debug-log ] GLO_absInputTopDir: $GLO_absInputTopDir"
typeset -g -r GLO_absOutputTopDir="$( realpath "$ARG_outputDir")"
echo "[ debug-log ] GLO_absOutputTopDir: $GLO_absOutputTopDir"


# print all sub dirs containing jpg or png files
echo "$( find "$ARG_inputDir" -type f -printf '%P\n' )" \
    | egrep -i "\.(jpg|png)$" \
    | sed -E "s/^(.*\/).*\.(jpg|png)$/\\1/" \
    | sort -u \
    | uniq -u \
    | pipable_function_processImageDir "$GLO_absInputTopDir" "$GLO_absOutputTopDir"


echo -e "[ios2android] > FINISHED processing of files"
