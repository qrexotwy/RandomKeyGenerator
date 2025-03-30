@echo off
title Simple UUIDKeyGenerator - by @qrexotwy
setlocal enabledelayedexpansion

:: Get the user's Downloads directory using PowerShell
for /f "delims=" %%D in ('powershell -command "[System.IO.Path]::Combine([System.Environment]::GetFolderPath('UserProfile'), 'Downloads')"') do set "downloadsPath=%%D"

:: Define the folder where keys will be stored
set "keysFolder=%downloadsPath%\Generated Keys"

:: Create the folder if it doesn't exist
if not exist "%keysFolder%" mkdir "%keysFolder%"

:: Get the current date and time formatted as YYYY-MM-DD_HH-MM-SS
for /f "tokens=2 delims==" %%T in ('wmic os get localdatetime /value ^| find "="') do set datetime=%%T
set "datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%"

:: Create a unique filename
set "filePath=%keysFolder%\Generated_%datetime%.txt"

:: Ask user for number of keys
set /p numKeys=Enter the number of keys to generate: 

:: Display loading message
echo Generating %numKeys% keys... Please wait.
echo.

:: Add a slight delay to make the loading message visible
timeout /t 2 /nobreak >nul

:: Generate UUIDs and save them to the file in numbered format
(for /l %%i in (1,1,%numKeys%) do (
    for /f "delims=" %%U in ('powershell -command "[guid]::NewGuid().ToString()"') do set uuid=%%U
    echo %%i. !uuid!
)) > "%filePath%"

:: Wait 1 second before opening the file
timeout /t 1 /nobreak >nul

:: Open the generated keys file
start "" notepad "%filePath%"

echo.
echo %numKeys% keys generated and saved in "%filePath%"
pause
