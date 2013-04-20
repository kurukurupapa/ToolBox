@echo off

rem かなり個人的なシステム開発の道具箱
rem 2013/04/04 新規作成

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
echo PowerShellスクリプトの実行で、エラーが発生する場合は、管理者権限で次の操作をしてみてください。
echo １．「powershell.exe」を管理者として実行し、PowerShellのコンソールを起動する。
echo ２．PowerShellのコンソールで、「Set-ExecutionPolicy RemoteSigned」を実行する。
echo ３．問い合わせプロンプトが表示されたら、"y"を入力する。
cd %basedir%
powershell.exe %basedir%clean_all.ps1

:END
echo 正常終了です。
exit /b 0

:ERROR
echo エラー終了です。
exit /b -1

:EOF
