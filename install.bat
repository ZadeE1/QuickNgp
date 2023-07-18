@echo off

rem batch var is refering to the folder that this bat file is sitting in
set batch=%~dp0


cd %batch%

set /p  condapause=" - use conda - recommended if you have it installed  (Y/N): "

if %condapause% == Y (
    set /p condaenv=" - which conda env you would like to use?: "
    echo - activating %condaenv%
    call conda activate %condaenv%
)



echo - downloading instant ngp

if exist %batch%instant-ngp (
    echo - instant ngp is already downloaded
    goto continue
)

wget -c https://github.com/NVlabs/instant-ngp.git -O instant-ngp.zip


:continue
rem loads the config file
echo - reconfiguring config.txt to make NgpPath to: %batch%instant-ngp
set config=%batch%config.txt
for /f "eol=; delims=;+" %%a in (%config%) do set %%a

(echo NgpPath=%batch%instant-ngp && echo ProjectDir=%ProjectDir% && echo UseConda=%UseConda%) > config.txt

echo - attempting to install required python packages
cd %batch%instant-ngp
call pip install -r requirements.txt

cd %batch%
pause
