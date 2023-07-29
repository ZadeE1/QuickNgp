@echo off

rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd /d %batch%

set config=%batch%config.txt

if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating config.txt 
    (echo NgpPath= && echo ProjectDir= ) > %config%
)

rem installs instang-ngp from 



echo - installing instant-ngp
call git clone -q https://github.com/NVlabs/instant-ngp.git instant-ngp
cd /d instant-ngp
call git submodule update --init --recursive
cd /d %batch%

rem loads the config file and updates it
echo - reconfiguring config.txt to make NgpPath to: %batch%instant-ngp
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

(echo NgpPath=%batch%instant-ngp && echo ProjectDir=%ProjectDir%) > %config%
rem loads new config vars
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

CALL :TRIM %NgpPath% NgpPath

cd /d %NgpPath%
call cmake . -B build
call cmake --build build --config RelWithDebInfo -j


pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF