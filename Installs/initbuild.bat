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
:condaask
if not defined condapause set /p  condapause=" - use conda - recommended if you have it installed  (Y/N): "
    if %condapause% == Y (
        set /p condaenv=" - which conda env you would like to use?: "
        echo - activating %condaenv%
        call conda activate %condaenv%
    ) else (
        if not %condapause% == N (
            goto condaask
        )
    )



echo - installing instant-ngp
call git submodule update --init --recursive
cd /d %batch%

rem loads the config file and updates it
echo - reconfiguring config.txt to make NgpPath to: %batch%instant-ngp
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

(echo NgpPath=%batch%Installs\instant-ngp && echo ProjectDir=%ProjectDir%) > %config%
rem loads new config vars
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

CALL :TRIM %NgpPath% NgpPath
echo %NgpPath%
cd /d %batch%Installs\instant-ngp


call git submodule update --init --recursive
pip install -r requirements.txt



:colmapask

rem if colmap has not been declared using the cmdline arguments it asks the user
if not defined colmapcuda set /p colmapcuda=" - install colmap for cuda ( Y/N ): "

if %colmapcuda% == Y (
    rem clears the eternal\colmap, this is because it removes an conflict when running colmap, possible running the non cuda instead of the cuda version
    @RD /S /Q "%NgpPath%\external\colmap"
    echo - Downloading COLMAP for cuda...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath %NgpPath%\external\colmap -Force 
) else (
    if not %colmapcuda% == N (
        goto colmapask
    )
    rem clears the eternal\colmap, this is because it removes an conflict when running colmap, possible running the non cuda instead of the cuda version
    @RD /S /Q "%NgpPath%\external\colmap"
    echo - Downloading COLMAP...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-no-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath %NgpPath%\external\colmap -Force 
)

rem installs ffmpeg
call download_ffmpeg.bat


pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF