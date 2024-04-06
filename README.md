## UE Box

Utility [UE](https://github.com/EpicGames/UnrealEngine) project

## Build

Generate project files on Linux

```
setup.sh - setup demo project files

  -u Unreal Engine installation directory
  -h help
```

Build with `cmake`

```
cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug .
cmake --build . --target UEBoxEditor
cmake --build . --target UEBox-Linux-Test
```

Run editor `./editor.sh`

## Package

```
<UE_DIRECTORY>/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun \
    -clean \
    -compile \
    -cook \
    -stage \
    -package \
    -pak \
    -nop4 \
    -ue4exe=UE4Editor-Cmd \
    -archive \
    -archivedirectory=Game \
    -clientconfig=Test \
    -targetplatform=Linux \
    -project=UEBox.uproject
```
