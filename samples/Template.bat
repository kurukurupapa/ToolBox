@echo off
rem 
rem Windows�o�b�`�t�@�C���p�e���v���[�g
rem 

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="" goto USAGE
set /p input=�J�n���Ă�낵���ł����H (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" goto EOF

:MAIN
echo �����J�n���܂��B
rem <<< �����ɏ����������܂� >>>

:END
echo ����I���ł��B
pause
exit /b 0

:USAGE
echo �g�����F%batname%
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
