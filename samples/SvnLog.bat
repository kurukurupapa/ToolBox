@echo off

rem Subversionで、コミットログ取得操作をするサンプルバッチファイルです。

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
svn log http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox

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
