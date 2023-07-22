@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0

cd %batch%

set config=%batch%config.txt

if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating config.txt 
    (echo NgpPath= && echo ProjectDir= ) > config.txt
)

rem installs instang-ngp from 



echo - installing instant-ngp
call git clone -q https://github.com/NVlabs/instant-ngp.git instant-ngp
cd instant-ngp
call git submodule update --init --recursive


rem loads the config file and updates it
echo - reconfiguring config.txt to make NgpPath to: %batch%instant-ngp
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

(echo NgpPath=%batch%instant-ngp && echo ProjectDir=%ProjectDir%) > config.txt
rem loads new config vars
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

CALL :TRIM %NgpPath% NgpPath

cd %NgpPath%
call cmake . -B build
call cmake --build build --config RelWithDebInfo -j


pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF