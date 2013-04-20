@echo off

rem Jenkinsを起動するサンプルです。

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
echo 正常終了です。
rem pause
exit /b 0

:USAGE
echo 使い方：%batname%
exit /b 0

:ERROR
echo エラー終了です。
exit /b -1

:EOF
