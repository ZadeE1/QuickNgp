@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0
cd %batch%

goto GETOPTS

:Help
echo sumit
pause
exit 0

:GETOPTS
if /I "%1" == "-h" call :Help 
if /I "%1" == "--conda" set useconda=%2 & shift & shift
if /I "%1" == "--colmapforcuda" set colmapcuda=%2 & shift & shift
if  "%1" == "" goto continue else goto GETOPTS
:continue


if defined useconda call :TRIM %useconda% useconda 
if defined colmapcuda call :TRIM %colmapcuda% colmapcuda 

set versionngp=Instant-NGP-for-RTX-3000-and-4000
set config=%batch%config.txt

if not exist %config% (
    echo - config.txt doesnt exist
    echo - creating config.txt 
    (echo NgpPath= && echo ProjectDir= ) > config.txt
)


rem asks the user if they want to use conda and if already declared using the cmdline arg it activates the declared env
if defined useconda (
    echo - activating %useconda% 
    call conda activate "%useconda%" 
    goto afteraskconda
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
rem checks if instant ngp doenst exist and installs it
if exist %batch%%versionngp% (
    echo - instant ngp is already downloaded
) else (
    echo - downloading instant ngp
    echo - #####################################################
    call certutil -urlcache -split -f "https://github.com/NVlabs/instant-ngp/releases/download/continuous/%versionngp%.zip" instant-ngp.zip
    call tar -xvf instant-ngp.zip
    echo - #####################################################
)


rem loads the config file and updates it
echo - reconfiguring config.txt to make NgpPath to: %batch%%versionngp%
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a
(echo NgpPath=%batch%%versionngp% && echo ProjectDir=%ProjectDir%) > config.txt

rem loads new config vars and trims ngppath so no errors happen
for /f "eol=; delims=;+" %%a in (%config%) do set %%a
CALL :TRIM %NgpPath% NgpPath

echo - attempting to install required python packages
echo - #####################################################

rem installs required python packages
cd %NgpPath%
call pip install -r requirements.txt
echo - #####################################################

rem changes to script path in order to install colmap
echo - changing dir to %NgpPath%\scripts
cd %NgpPath%\scripts



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

echo - install completed successfully
cd %batch%
pause
exit 0

:TRIM
SET %2=%1
GOTO :EOF