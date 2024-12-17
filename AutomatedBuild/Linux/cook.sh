#!/bin/bash

set -e

BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<EOF
`basename $0` -p <project> -m <maps.txt> -t <type> [-d|-h]

Cook assets and package build

Options:
    -p: project
    -m: a text file containing the game levels to cook, one per line
    -d: debug using gdb
    -t: UE4 build configuration type, eg. Test, Debug, Development or Shipping
    -h: usage

EOF
}

readonly UE4_DIRECTORY=${UE4_PATH:-$BIN/../../../../UnrealEngine}
readonly PROJ="$BIN/../../"

cook() {
    project=$1
    maps=$2
    typ=$3 
    runner="$4"

    LD_LIBRARY_PATH=$UE4_DIRECTORY/Engine/Binaries/Linux:$PROJ/ThirdParty/Config/bin/linux/x64/release:$PROJ/ThirdParty/JsonCpp/bin/linux/x64/release \
        LC_ALL=C \
        LANGUAGE=en_US.UTF-8 \
        LANG=en_US.UTF-8 \
        $runner $UE4_DIRECTORY/Engine/Binaries/Linux/UnrealEditor-Cmd \
        ${project} \
        -run=Cook \
        -Map=$maps \
        -TargetPlatform=LinuxNoEditor \
        -fileopenlog \
        -unversioned \
        -abslog=$UE4_DIRECTORY/Engine/Programs/AutomationTool/Saved/Cook-$(date -u +"%Y.%m.%d-%H.%M.%S").txt \
        -stdout \
        -CrashForUAT \
        -unattended \
        -clientconfig=$typ
}

main() {
    [ $# -eq 0 ] && {
        usage
        exit 0
    }
    debug=0
    typ="Test"
    while getopts 'p:m:t:dh' c; do
        case $c in
            p) project=$OPTARG ;;
            m) mfile=$OPTARG ;;
            t) typ=$OPTARG ;;
            d) debug=1 ;;
            h) usage && exit 0 ;;
        esac
    done
    [ -z "$project" ] && {
        echo "ERROR: no project provided, aborting"
        exit 1
    }
    [ -z "$mfile" ] && {
        echo "ERROR: missing map file, require text file with maps to cook"
        exit 1
    }
    [ -s $mfile ] || {
        echo "ERROR: map file: $mfile is not accessible"
        exit 1
    }
    [ $debug -eq 1 ] && runner="gdb --args"
    [ "$typ" != "Test" ] && {
        [ "$typ" != "Development" -a "$typ" != "Debug" -a "$typ" != "DebugGame" -a "$typ" != "Shipping" -a "$typ" != "Test" ] && {
            echo "ERROR: Invalid UE4 build configuration type provided - $typ"
            exit 1
        }
    }
    
    cook $project $(cat $mfile | tr -s "\n" "+") $typ "$runner"
}

main "$@"
