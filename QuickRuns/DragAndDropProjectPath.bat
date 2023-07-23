@echo off

rem batch var is refering to the folder that this bat file is sitting in
for %%i in ("%~dp0..") do set "folder=%%~fi"
call :TRIM %folder% folder
set batch=%folder%\

cd %batch%

rem config loading
set config=%batch%config.txt
call :TRIM %config% config
if not exist "%config%" (
    echo - config.txt doesnt exist
    echo - creating config.txt 
    (echo NgpPath= && echo ProjectDir= ) > config.txt
)

for /f "eol=; delims=;+" %%a in (%config%) do set %%a
(echo NgpPath=%NgpPath% && echo ProjectDir=%ProjectDir%) > config.txt

rem loads new config vars and trims ngppath so no errors happen
for /f "eol=; delims=;+" %%a in (%config%) do set %%a
CALL :TRIM %NgpPath% NgpPath

rem Get the path of all the dropped files.
set "droppedFiles=%*"
echo %~

rem Echo the path of each dropped file.
for %%f in (%droppedFiles%) do (
  echo The dropped file is: %%f
)

rem Pause the batch file so the user can see the output.
pause