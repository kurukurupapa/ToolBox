@echo off

rem ���Ȃ�l�I�ȃV�X�e���J���̓��
rem 2013/04/04 �V�K�쐬

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
echo PowerShell�X�N���v�g�̎��s�ŁA�G���[����������ꍇ�́A�Ǘ��Ҍ����Ŏ��̑�������Ă݂Ă��������B
echo �P�D�upowershell.exe�v���Ǘ��҂Ƃ��Ď��s���APowerShell�̃R���\�[�����N������B
echo �Q�DPowerShell�̃R���\�[���ŁA�uSet-ExecutionPolicy RemoteSigned�v�����s����B
echo �R�D�₢���킹�v�����v�g���\�����ꂽ��A"y"����͂���B
cd %basedir%
powershell.exe %basedir%clean_all.ps1

:END
echo ����I���ł��B
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
