@echo off
setlocal

rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd /d%batch%

goto GETOPTS

:Help
echo sumit
pause
exit 0

:GETOPTS
if /I "%1" == "-h" call :Help 
if /I "%1" == "--conda" set useconda=%2 & shift & shift 
if /I "%1" == "--colmaprun" set "colmap_run=Y" & shift 
if /I "%1" == "--highdetail" set "highdetail=Y" & shift 
if  "%1" == "" goto continue else goto GETOPTS
:continue

if defined useconda call :TRIM %useconda% useconda 
if defined colmap_run call :TRIM %colmap_run% colmap_run 
if defined highdetail call :TRIM %highdetail% highdetail 


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

rem changes dir into the project folder which is where colmap will be run in and also making instant ngp work as intended
echo - changing directory to project folder: %ProjectDir%
echo - if you would like to change the project directory, please change it in config.txt
cd /d%ProjectDir%


set ColmapTwoNerf=%NgpPath%\scripts\colmap2nerf.py
set Images=%ProjectDir%\images
rem checks if images dir exists else it creates them
if not exist %Images% (
    echo - Images folder is being created
    echo - remember: if this has no images inside, colmap wont work as you intend
    call mkdir images
    pause
    exit 1
)




if "%useconda%" == 0 goto afteraskconda
:condaask
if defined useconda (
    if not useconda == 0 (
        echo - activating %useconda% 
        call conda activate "%useconda%" 
        goto afteraskconda)
)  
    set /p  condapause=" - use conda - recommended if you have it installed  (Y/N): "
    if %condapause% == Y (
        set /p condaenv=" - which conda env you would like to use?: "
        echo - activating %condaenv%
        call conda activate %condaenv%
    ) else (
        if not %condapause% == N (
            goto condaask
        )
    )



:afteraskconda

rem checks with the user to see if they 
:AskUseColmap
if not defined colmap_run set /p colmap_run="- use colmap to convert images for the nerf model to be able to use them - required at least once (Y/N): "
if not "%colmap_run%" equ "N" if not "%colmap_run%" equ "Y" goto AskUseColmap


:continue
rem runs colmap2nerf.py only with Y is selected

set colmap_command = ""

cd /d%ProjectDir%
echo - %cd%
if %colmap_run% == Y (
    if "%highdetail%" == Y (
        call python %ColmapTwoNerf% --overwrite --run_colmap --images %Images% --colmap_matcher exhaustive
    ) else (
        call python %ColmapTwoNerf% --overwrite --run_colmap --images %Images%
    )
    
) else (
        echo - not running colmap
) 

rem runs instant ngp, opening automatically the colmap project 
echo - running instant ngp
cd /d%NgpPath%
call instant-ngp.exe %ProjectDir% 

cd /d%batch%
pause
endlocal
:TRIM
SET %2=%1
GOTO :EOF