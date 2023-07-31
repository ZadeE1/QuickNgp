@echo off

rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd /d %batch%

goto GETOPTS

:Help
echo sumit
pause
exit 0

:GETOPTS
if /I "%1" == "-h" call :Help 
if /I "%1" == "--video" set video=%2 & shift & shift
if /I "%1" == "--fps" set fps=%2 & shift & shift
if  "%1" == "" goto continue else goto GETOPTS
:continue


if defined video call :TRIM %video% video 
if defined fps call :TRIM %fps% fps 


rem makes sure the config.txt exists and has the correct path "Names" being refrenced and if it doesnt it creates a boilerplate
echo - checking if config.txt exists
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
rem path checking
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

echo - changing dir to %ProjectDir%
cd /d "%ProjectDir%"



rem setting path for images
set Images=%ProjectDir%\images
CALL :TRIM %Images% Images

echo "%Images%" %cd%


rem checks if images dir exists else it creates it
echo - checking if %Images% path exists
if not exist %Images% (
    echo - Images folder is being created inside %ProjectDir%
    cd /d %ProjectDir%
    call mkdir %Images%
)

echo - clearing %Images%
cd /d %ProjectDir%
RMDIR %Images% /S /Q
call mkdir %Images%

if not defined video set /p video=" - Name of video inside %ProjectDir%: "
set video=%ProjectDir%\%video%

if not defined fps set /p fps=" - Frames per second ( 5 recommended ): "
CALL :TRIM %fps% fps

echo - checking if the videos exists
if not exist %video% (
    echo - %video% does not exist
    pause
    exit 1
)
CALL :TRIM %ProjectDir% ProjectDir

echo - changing directory to %ProjectDir%\images
cd /d %ProjectDir%\images

echo - running ffmpeg
call %NgpPath%\external\ffmpeg\ffmpeg-5.1.2-essentials_build\bin\ffmpeg.exe -i %video% -vf fps=%fps% "frame_%%%%03d.png"

pause
exit 0




:TRIM
SET %2=%1
GOTO :EOF