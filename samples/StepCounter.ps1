# Windows PowerShell
# �\�[�X�t�@�C���̃X�e�b�v�����v������X�N���v�g�ł��B
param($beforeDir, $afterDir, $outDir)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### �֐���`
######################################################################

# �g�p���@���o�͂���B
# return - �Ȃ�
function U-Write-Usage() {
    Write-Output "�g�����F$psName �ύX�O�\�[�X�f�B���N�g�� �ύX��\�[�X�f�B���N�g�� �o�̓f�B���N�g��"
}

# �X�e�b�v�����v������B
# $beforeDir - �ύX�O�\�[�X�̃f�B���N�g��
# $afterDir - �ύX��\�[�X�̃f�B���N�g��
# return - �Ȃ�
function U-Count-Step() {
    New-Item -Force -ItemType Directory $outDir | Out-Null
    
    # �S�̃J�E���g
    #Write-Verbose "�ύX��\�[�X�J�E���g�i�e�L�X�g�`���j"
    #java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true "-output=${outDir}\AfterStep.txt"
    #Get-Content "${outDir}\AfterStep.txt" | Write-Debug
    Write-Verbose "�ύX��\�[�X�J�E���g�iCSV�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=csv "-output=${outDir}\AfterStep.csv"
    Write-Verbose "�ύX��\�[�X�J�E���g�iExcel�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=excel "-output=${outDir}\AfterStep.xls"

    # �����J�E���g
    Write-Verbose "�����\�[�X�J�E���g�iCSV�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=csv "-output=${outDir}\DiffStep.csv"
    Write-Verbose "�����\�[�X�J�E���g�iExcel�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=excel "-output=${outDir}\DiffStep.xls"

    Write-Output "��������"
    Write-Output "�o�̓f�B���N�g��=$outDir"
}

######################################################################
### �������s
######################################################################

###
### �O����
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$jarPath = "$baseDir\..\stepcounter-3.0.1\eclipse-plugin\jp.sf.amateras.stepcounter\lib\stepcounter-3.0.1-jar-with-dependencies.jar"

Write-Verbose "$psName Start"

###
### �又��
###

if ($($beforeDir -eq $null) -or $($afterDir -eq $null)) {
    U-Write-Usage
} else {
	U-Count-Step
}

###
### �㏈��
###
Write-Verbose "$psName End"
