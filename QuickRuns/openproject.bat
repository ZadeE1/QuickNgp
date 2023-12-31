
@echo off

rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd /d %batch%

rem trim function is used to remove trailing whitespaces when reading from the config.txt



rem makes sure the config.txt exists and has the correct path "Names" being refrenced and if it doesnt it creates a boilerplate
set config=%batch%config.txt
if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating/writing to config.txt 
    (echo NgpPath= && echo ProjectDir= ) > %config%
    echo - done
    echo - program will not work until config paths are set
    pause
    exit 1
)

rem loads the config file and checks to see if all config feilds are valid
for /f "eol=; delims=;+" %%a in (%config%) do set "%%a"

echo - if ''The syntax of the command is incorrect.'' error message shows up, 
echo - it usually means that there is something that has not been configured in config.txt 
if not defined %ProjectDir% (
    echo - checking config 1/2
    if not exist %ProjectDir% (
        echo - ProjectDir Must be reconfigured since it doesnt exist
        echo - they could be a sneaky space at the end of the filepath that you inputted
        echo - make sure to delete that space
        pause
        exit 1
    )
) 

if not defined %NgpPath% (
    echo - checking config 2/2
    if not exist %NgpPath% (
        echo - NgpPath Must be reconfigured since it doesnt exist
        pause
        exit 1
    )
) 


rem this removes trailing white spaces so that windows can properly determine the projectdir
CALL :TRIM %ProjectDir% ProjectDir
CALL :TRIM %NgpPath% NgpPath

rem runs instant ngp, opening automatically the colmap project 
echo - running instant ngp
cd /d %NgpPath%
call instant-ngp.exe %ProjectDir% --no-train

cd /d %batch%
pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF