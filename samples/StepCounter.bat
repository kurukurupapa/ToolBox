@echo off

rem �\�[�X�t�@�C���̃X�e�b�v�����v������T���v���ł��B

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
echo �o�b�`���� Start

:MAIN
set stepcounterpath=%TOOLBOX_HOME%\stepcounter-3.0.1\eclipse-plugin\jp.sf.amateras.stepcounter\lib\stepcounter-3.0.1-jar-with-dependencies.jar
set beforedir=%baseDir%\testdata\stepcounter\before
set afterdir=%baseDir%\testdata\stepcounter\after
set outname=StepCounterBat

rem �S�̃J�E���g
java -cp %stepcounterpath% jp.sf.amateras.stepcounter.Main %afterdir% -showDirectory=true -output=%outname%_Step.txt
type %outname%_Step.txt
java -cp %stepcounterpath% jp.sf.amateras.stepcounter.Main %afterdir% -showDirectory=true -format=csv -output=%outname%_Step.csv
java -cp %stepcounterpath% jp.sf.amateras.stepcounter.Main %afterdir% -showDirectory=true -format=excel -output=%outname%_Step.xls

rem �����J�E���g
java -cp %stepcounterpath% jp.sf.amateras.stepcounter.diffcount.Main %afterdir% %beforedir% -format=csv -output=%outname%_DiffStep.csv
java -cp %stepcounterpath% jp.sf.amateras.stepcounter.diffcount.Main %afterdir% %beforedir% -format=excel -output=%outname%_DiffStep.xls

:END
echo �o�b�`�t�@�C�� End
rem pause
exit /b 0

:USAGE
echo �g�����F%batname%
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
