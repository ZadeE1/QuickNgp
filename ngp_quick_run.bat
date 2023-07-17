@echo off


set config=%~dp0config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

if %UseConda% == 1 (conda activate base)
cd %ProjectParentDir%

:AskUseColmap
set /p colmap_run="Use Colmap (Y/N): "
if not "%colmap_run%" equ "N" if not "%colmap_run%" equ "Y" goto AskUseColmap


:continue
if %colmap_run% == Y (python %ColmapTwoNerf% --overwrite --run_colmap --images %images%) else (echo Not running colmap) 
echo Running instant ngp
%NgpExePath% %ProjectParentDir% 

pause
