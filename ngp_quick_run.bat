@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0


set nl=^&
set configboiler=ColmapTwoNerf=%nl%
NgpExePath=%nl%
Images=%nl%
ProjectDir=%nl%
UseConda=0

rem makes sure the config.txt exists and has the correct path "Names" being refrenced and if it doesnt it creates a boilerplate
set config=%batch%config.txt
if not exist %config% (
    echo config.txt doesnt exist
    echo creating config.txt 
    echo %configboiler% > config.txt
)

rem loads the config file
for /f "eol=; delims=;+" %%a in (%config%) do set %%a


rem loads conda 
if %UseConda% == 1 (call conda activate )

rem changes dir into the project folder which is where colmap will be run in and also making instant ngp work as intended
cd %ProjectDir%

rem checks with the user to see if they 
:AskUseColmap
set /p colmap_run="Use Colmap (Y/N): "
if not "%colmap_run%" equ "N" if not "%colmap_run%" equ "Y" goto AskUseColmap


:continue
rem runs colmap2nerf.py only with Y is selected
if %colmap_run% == Y (python %ColmapTwoNerf% --overwrite --run_colmap --images %images%) else (echo Not running colmap) 

rem runs instant ngp, opening automatically the colmap project 
echo Running instant ngp
%NgpExePath% %ProjectDir% 

pause
