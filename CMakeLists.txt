cmake_minimum_required(VERSION 3.0)

project(nightskout VERSION 0.1)
 
set(QML_IMPORT_PATH "/usr/lib64/qt5/qml;package/contents/ui" CACHE STRING "" FORCE)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(KF5Plasma REQUIRED)

plasma_install_package(package com.github.dougfinl.knightscoutmonitor)
