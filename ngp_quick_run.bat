@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0


set nl=&echo.


rem makes sure the config.txt exists and has the correct path "Names" being refrenced and if it doesnt it creates a boilerplate
set config=%batch%config.txt
if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating/writing to config.txt 
    (echo NgpPath= && echo ProjectDir= && echo UseConda=) > config.txt
    echo - done
    echo - program will not work until config paths are set
    pause
    exit 1
)

rem loads the config file and checks to see if all config feilds are valid
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

if not defined %ProjectDir% (
    echo - checking config 1/3
) else (
    call cls
    echo - ProjectDir Must be reconfigured
    echo - #############################################################
    echo -   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING
    echo - #############################################################
    echo - Make sure that the project directory is EMPTY to avoid any problems
    pause
    exit 1
)
if not defined %NgpPath% (
    echo - checking config 2/3
) else (
    echo - NgpPath Must be reconfigured
    pause
    exit 1
)
if not defined %UseConda% (
    echo - checking config 3/3
) else (
    echo - UseConda Must be reconfigured
    pause
    exit 1
)

rem changes dir into the project folder which is where colmap will be run in and also making instant ngp work as intended
echo - changing directory to project folder: %ProjectDir%
echo - if you would like to change the project directory, please change it in config.txt
cd %ProjectDir%


set ColmapTwoNerf=%NgpPath%scripts\colmap2nerf.py
set Images=%ProjectDir%\images

if not exist %Images% (
    echo - Images folder is being created
    call mkdir images
    pause
    exit 1
)


rem loads conda 
if %UseConda% == 1 (call conda activate & echo - activating conda base)

rem checks with the user to see if they 
:AskUseColmap
set /p colmap_run="- use colmap to convert images for the nerf model to be able to use them - required on first run (Y/N): "
if not "%colmap_run%" equ "N" if not "%colmap_run%" equ "Y" goto AskUseColmap


:continue
rem runs colmap2nerf.py only with Y is selected
if %colmap_run% == Y (call python %ColmapTwoNerf% --overwrite --run_colmap --images %Images%) else (echo - not running colmap) 

rem runs instant ngp, opening automatically the colmap project 
echo - running instant ngp
%NgpPath%instant-ngp.exe %ProjectDir% 

pause
