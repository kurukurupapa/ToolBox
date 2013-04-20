@echo off

rem FTPコマンドを実行するサンプルです。

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
ftp -s:FtpGetCmd.ftp
dir ffftp-1.98g.zip

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
