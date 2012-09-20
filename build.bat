@echo off
REM Dependencies:
REM  WiX v3
REM    http://wix.sourceforge.net/downloadv3.html
REM  Visual C++ 2008 Runtime Redistributable Package
REM    http://www.microsoft.com/en-us/download/details.aspx?id=29
REM  .NET Framework Version 2
REM    http://download.microsoft.com/download/5/6/7/567758a3-759e-473e-bf8f-52154438565a/dotnetfx.exe
REM    http://www.microsoft.com/downloads/details.aspx?FamilyID=0856EACB-4362-4B0D-8EDD-AAB15C5E04F5&displaylang=en
REM  Imagicks convert.exe
REM    http://www.imagemagick.org/script/binary-releases.php#windows
REM  ReplaceVistaIcon.exe
REM    http://www.rw-designer.com/compile-vista-icon
REM  node.exe
REM    http://nodejs.org
REM  npm.exe
REM    http://nodejs.org
REM
REM Usage: build.bat

npm install
node_modules\brunch\bin\brunch build . 

set TSRC="C:\Users\...(your user account)...\AppData\Roaming\Titanium"
set TSDK=%TSRC%\sdk\win32\1.2.0.RC6
set PYTHON_DIR=%TSRC%\modules\win32\python\1.2.0.RC6
set DESTINATION=%1\dist\win32
 
%PYTHON_DIR%\python.exe %TSDK%\tibuild.py -rnv -i dist,.DS_Store,node_modules -o win32 -t bundle -s %TSRC% -a %TSDK% -d %DESTINATION% .
del Resources