@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0

cd %batch%

rem using this var just because it is easier to type out 
set short=Instant-NGP-for-RTX-3000-and-4000

set config=%batch%config.txt

if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating config.txt 
    (echo NgpPath= && echo ProjectDir= ) > config.txt
)

:condaask
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



rem checks if instant ngp doenst exist and installs it
if exist %batch%Instant-NGP-for-RTX-3000-and-4000 (
    echo - instant ngp is already downloaded
    goto continue
) else (
    echo - downloading instant ngp
    echo - #####################################################
    call certutil -urlcache -split -f https://github.com/NVlabs/instant-ngp/releases/download/continuous/Instant-NGP-for-RTX-3000-and-4000.zip instant-ngp.zip
    call tar -xvf instant-ngp.zip
    echo - #####################################################
)


:continue
rem loads the config file and updates it
echo - reconfiguring config.txt to make NgpPath to: %batch%Instant-NGP-for-RTX-3000-and-4000
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

(echo NgpPath=%batch%Instant-NGP-for-RTX-3000-and-4000 && echo ProjectDir=%ProjectDir%) > config.txt
rem loads new config vars
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

CALL :TRIM %NgpPath% NgpPath

echo - attempting to install required python packages
echo - #####################################################

rem installs required python packages
cd %NgpPath%
call pip install -r requirements.txt
echo - #####################################################

echo - changing dir to %NgpPath%\scripts
cd %NgpPath%\scripts

rem clears the eternal\colmap, this is because it removes an conflict when running colmap, possible running the non cuda instead of the cuda version
@RD /S /Q "%NgpPath%\external\colmap"

rem asks user if they want to install colmap for cuda
:colmapask
set /p colmapcuda=" - install colmap for cuda ( Y/N ): "
if %colmapcuda% == Y (
    echo - Downloading COLMAP for cuda...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath ..\external\colmap -Force 
) else (
    if not %colmapcuda% == N (
        goto colmapask
    )
    echo - Downloading COLMAP...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-no-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath ..\external\colmap -Force 
)
rem installs ffmpeg
call download_ffmpeg.bat

echo - install completed successfully
cd %batch%
pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF