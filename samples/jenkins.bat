@echo off

rem Jenkins���N������T���v���ł��B

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
set warpath=%TOOLBOX_HOME%\jenkins\jenkins.war
set JENKINS_HOME=%basedir%jenkins_home
rem java -jar %warpath% --help
java -jar %warpath% --httpPort=8082

:END
echo ����I���ł��B
rem pause
exit /b 0

:USAGE
echo �g�����F%batname%
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
