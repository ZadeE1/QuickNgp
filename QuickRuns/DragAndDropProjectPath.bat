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

rem Get the path of the dropped file.
set "droppedPath=%~1"

rem Check if the file was dropped.
if not defined droppedPath (
  echo No path was dropped.
  pause
  exit 0
)

for /f "eol=; delims=;+" %%a in (%config%) do set %%a
(echo NgpPath=%NgpPath% && echo ProjectDir=%droppedPath%) > config.txt

rem Pause the batch file so the user can see the output.
pause