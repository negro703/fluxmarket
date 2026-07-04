@echo off
echo Cleaning files forcefully...

:: Set JAVA_HOME for this session
set "JAVA_HOME=C:\Program Files\Java\jdk-23"

:: Prepend JDK 23 bin to PATH (this session only)
set "PATH=C:\Program Files\Java\jdk-23\bin;%PATH%"

:: Delete project directories
if exist "build" rmdir /s /q "build"
if exist ".dart_tool" rmdir /s /q ".dart_tool"
if exist "android\.gradle" rmdir /s /q "android\.gradle"
if exist "android\app\build" rmdir /s /q "android\app\build"

:: Delete corrupted Kotlin cache
if exist "%USERPROFILE%\.gradle\caches\kotlin-*" rmdir /s /q "%USERPROFILE%\.gradle\caches\kotlin-*"

echo Cleaning completed!
echo Now starting Flutter clean...
call flutter clean

echo Dependencies being re-downloaded...
call flutter pub get

echo Starting App...
call flutter run --debug
pause
