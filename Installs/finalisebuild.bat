@echo off


rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd /d %batch%

rem asks user if they want to install colmap for cuda
:colmapask

rem if colmap has not been declared using the cmdline arguments it asks the user
if not defined colmapcuda set /p colmapcuda=" - install colmap for cuda ( Y/N ): "

if %colmapcuda% == Y (
    rem clears the eternal\colmap, this is because it removes an conflict when running colmap, possible running the non cuda instead of the cuda version
    @RD /S /Q "%NgpPath%\external\colmap"
    echo - Downloading COLMAP for cuda...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath ..\external\colmap -Force 
) else (
    if not %colmapcuda% == N (
        goto colmapask
    )
    rem clears the eternal\colmap, this is because it removes an conflict when running colmap, possible running the non cuda instead of the cuda version
    @RD /S /Q "%NgpPath%\external\colmap"
    echo - Downloading COLMAP...
    call powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/colmap/colmap/releases/download/3.7/COLMAP-3.7-windows-no-cuda.zip', 'colmap.zip')"

    echo - Unzipping...
    call powershell Expand-Archive colmap.zip -DestinationPath ..\external\colmap -Force 
)

rem installs ffmpeg
call download_ffmpeg.bat