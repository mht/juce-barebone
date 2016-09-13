@ECHO OFF

SET JUCE_ROOT=third_party\juce
SET PROJUCER_ROOT=third_party\juce\extras\Projucer\Builds\VisualStudio2015
SET PROJUCER_SLN=Projucer.sln
SET PROJUCER_PROJECT=Projucer.vcxproj

SET BUILD_PLATFORM=x64
IF "%PROCESSOR_ARCHITECTURE%"=="x86" SET BUILD_PLATFORM=Win32

:: Determine if vsvars32.bat has been called. If YES, bypass to next step.
@WHERE devenv.com >NUL 2>NUL
IF %ERRORLEVEL% EQU 0 GOTO BUILD_PROJUCER

::
:: Initialize Visual Studio build environment.
::
IF "%VS140COMNTOOLS%"=="" GOTO VS2015_NOT_FOUND
ECHO.
ECHO   Initializing Visual Studio 2015 build environment...
PUSHD "%VS140COMNTOOLS%"
CALL vsvars32.bat
POPD

::
:: Build Projucer project
::
:BUILD_PROJUCER
ECHO.
ECHO   Building Projucer project...
PUSHD %PROJUCER_ROOT%
CALL devenv.com %PROJUCER_SLN% "Release|%BUILD_PLATFORM%" /Build
POPD

::
:: Copy Projucer.exe to JUCE root directory.
::
ECHO.
ECHO   Copying Projucer.exe to JUCE root directory...
COPY /Y "%PROJUCER_ROOT%\Release\Projucer.exe" "%JUCE_ROOT%"

::
:: Clean up Projucer project
::
:CLEAN_PROJUCER
ECHO.
ECHO   Cleaning Projucer project...
PUSHD %PROJUCER_ROOT%
CALL devenv.com %PROJUCER_SLN% "Release|%BUILD_PLATFORM%" /Clean
POPD

IF EXIST "%PROJUCER_ROOT%\Release" (
	ECHO.
	ECHO    Deleting folder: "%PROJUCER_ROOT%\Release\"
	DEL /F /Q /S "%PROJUCER_ROOT%\Release\*.*"
	RMDIR /S /Q "%PROJUCER_ROOT%\Release"
	DEL /F /Q /S "%PROJUCER_ROOT%\.vs\*.*"
	RMDIR /Q /S "%PROJUCER_ROOT%\.vs"
)

IF EXIST "%PROJUCER_ROOT%\Projucer.VC.db" (
	ECHO.
	ECHO    Deleting %PROJUCER_ROOT%\Projucer.VC.db
	DEL /F /Q %PROJUCER_ROOT%\Projucer.VC.db
)

GOTO EXIT

:VS2015_NOT_FOUND
ECHO.
ECHO   ERROR: Visual Studio 2015 not found!
ECHO.

:EXIT