#!/bin/bash
#
set -eo pipefail
BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $BIN/logging.sh

usage() {
    cat <<EOF
build.sh - build and packages app

  -u Unreal Engine installation directory
  -h help

EOF
}

build() {
    info "Building app"
    cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug .
    cmake --build . --target UEBoxEditor
    cmake --build . --target UEBox-Linux-Test

}

package() {
    local ueDir=$1

    info "Packaging app"
    $ueDir/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun \
        -clean \
        -compile \
        -cook \
        -stage \
        -package \
        -pak \
        -nop4 \
        -unrealexe=UnrealEditor-Cmd \
        -archive \
        -archivedirectory=$BIN/Packaged \
        -clientconfig=Test \
        -targetplatform=Linux \
        -project=$BIN/UEBox.uproject
}

main() {
    while getopts 'u:h' c; do
        case $c in
            u) ueDir=$OPTARG ;;
            h) usage && exit 0 ;;
        esac
    done

    [ -n "$ueDir" -a -d "$ueDir" ] || {
        error "provide a valid Unreal Engine installation directory"
        usage
        exit 1
    }
    build
    package $ueDir
}

main "$@"
