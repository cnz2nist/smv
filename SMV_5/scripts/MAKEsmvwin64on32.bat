@echo off

Rem  Windows batch file to build a release Smokeview for Windows 64.

Rem setup environment variables (defining where repository resides etc) 

set envfile="%homedrive%\%homepath%"\fds_smv_env.bat
IF EXIST %envfile% GOTO endif_envexist
echo ***Fatal error.  The environment setup file %envfile% does not exist. 
echo Create a file named %envfile% and use SMV_5/scripts/fds_smv_env_template.bat
echo as an example.
echo.
echo Aborting now...
pause>NUL
goto:eof

:endif_envexist

call %envfile%
echo Using the environment variables:
echo.
echo Using SVN revision %smv_revision% to build a 64 bit Windows Smokeview

%svn_drive%
cd %svn_root%\smv_5\source\smokeview
svn -r %smv_revision% update

cd %svn_root%\smv_5\Build\INTEL_WIN_64
erase *.obj
make_smv64on32

echo.
echo compilation complete
pause
