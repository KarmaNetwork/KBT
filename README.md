# KBT
> KBT is a build tool for Karma project based on cmake.

## Description
KBT supply a method to generate project based on cmake. It also can help us manage dependencies and make build progress easily.

## Dependencies
* Cmake
* unzip
* wget/curl

## Installation
Clone KBT:
```
git clone http://github.com/tiannian/KBT
```

Execute CMake script
```
cd KBT
sudo cmake .
```
Then you can delete KBT folder.

## Usage
### Create project
1. Create project folder and create CMakeLists.txt.
```
mkdir sample
touch CMakeLists.txt
```
2. Configure this project through CMakeLists.txt. You must include KBT module first in CMakeList.txt.
```
include(KBT)
KBT_PROJECT(sample)
# .... some other configuration ...
```
3. Create build folder and do first running.
```
mkdir build
cd build
cmake ..
```
4. The project structure will be founded automatically. KBT will download all dependencies from github.
```
-- .gitigrone
-- src/
-- include/
-- test/
-- dependencies/
-- build
-- CMakeLists.txt
-- sample.config
```

### Build 
According cmake suggestion, please build project in build folder.
```
cd build
cmake ..
make
```

## Example
```
INCLUDE (KBT)
KBT_PROJECT(sample)
KBT_SET_ARCH(xtensel)
KBT_SET_PLATFORM(esp8266)
KBT_SET_PROJECT_TYPE(lib)
KBT_CONFIG()
```

## Reference
### KBT_SET_ARCH
This function will set  `KBT_ARCH` variable. KBT is according to this variable to decide compiler. It will be download related toolchain automatically.

You can choose the following `KBT_ARCH` value.
- x86
- arm
- avr
- mips
- xtensel

If this value is `*`, KBT will fill this variable by current architecture.

### KBT_SET_PLATFORM
This function will set  `KBT_PLATFORM` variable. KBT is according to this variable to set some dependencies.

You can choose the following `KBT_PLATFORM` value.
- General
- Mingw
- Linux
- Macos
- Android
- Arduino
- ESP8266
- ESP32

If this value is `*`, KBT will fill this variable by current system.

### KBT_SET_PROJECT_TYPE
This function will set `KBT_PROJECT_TYPE` variable. You can choose the following `KBT_PROJECT_TYPE` value.

- bin
- lib

If `KBT_PROJECT_TYPE` is `bin`, KBT will be link all dependencies in binary.

If `KBT_PROJECT_TYPE` is `lib`, KBT will not be link all dependencies in library.

### KBT_ADD_DEPENDENCIES
This function will add dependencies peoject and clone it from github.

The first arguments is `<auther>/<project-name>`

The second arguments is version. (Not available at this time).

### KBT_CONFIG
Execute this function in the end of CMakeLists.txt script.
