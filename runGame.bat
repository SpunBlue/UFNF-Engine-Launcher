@echo off
set gameFolder=%1
set gameName=%2
cd downloads
cd %gameFolder%
start %gameName%.exe
exit 0
@echo on