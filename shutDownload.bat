@echo off
setlocal EnableDelayedExpansion
setlocal

echo Administrative permissions required. Detecting permissions...

net session > nul 2>&1
if %errorLevel% == 0 (
    echo Administrative permissions confirmed.
) else (
    echo Failure: Current permissions inadequate.
    echo Program finished unsuccessfully.
    goto :end
)

set input=N
set result=false
set directory=C:\Users\%USERNAME%\Downloads
set cr=\*.crdownload

:filePath
if exist %directory%%cr% (
    echo File exists^^! 
    echo Waiting for the download to finish...
    for /l %%x in () do (
        timeout 30 > nul
        if not exist %directory%%cr% (
            echo File has been downloaded. Terminating chrome.exe...
            taskkill /F /IM chrome.exe /T > nul
            
            echo System will shutdown in 10s.
            timeout 10
            shutdown -s -t 0 -f
        )
    )
) else (
    echo File doesn't exist in %directory%!
    echo Do you want to specify file directory? [Y/N]
    
    :invarg
    set /P input=

    if !input!==y (
        set result=true
    ) else if !input!==Y (
        set result=true
    ) else if !input!==n (
        set result=false
    ) else if !input!==N (
        set result=false
    ) else (
        echo Invalid argument, use Y or N^^!
        goto :invarg
    )

    if !result!==true (
        echo Enter full path to the directory:
        set /P directory=
        goto :filePath
    ) else (
        echo Program finished unsuccessfully - couldn't find your file.
    )
)

endlocal