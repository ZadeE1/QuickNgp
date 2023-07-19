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

set /p  condapause=" - use conda - recommended if you have it installed  (Y/N): "

if %condapause% == Y (
    set /p condaenv=" - which conda env you would like to use?: "
    echo - activating %condaenv%
    call conda activate %condaenv%
)




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


echo - attempting to install required python packages
echo - #####################################################

cd %batch%Instant-NGP-for-RTX-3000-and-4000
call pip install -r requirements.txt

cd %batch%

echo - #####################################################
echo - install completed successfully
pause
exit 0