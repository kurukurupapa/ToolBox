# Windows PowerShell
# �e�L�X�g�t�@�C���̕����R�[�h��ϊ�����T���v���ł��B

param($inPath, $outDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### �֐���`
######################################################################

# �g�p���@���o�͂���B
# return - �Ȃ�
function U-Write-Usage() {
    Write-Output "�g�����F$psname ���̓t�@�C�� �o�̓f�B���N�g��"
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

Write-Verbose "$psName Start"

###
### �又��
###

if ($inPath -eq $null) {
    U-Write-Usage
} else {
    Get-Content $inpath | Set-Content "$outDir\CnvLang.SJIS.txt" -Encoding String
    Get-Content $inpath | Set-Content "$outDir\CnvLang.UTF8.txt" -Encoding UTF8
}

###
### �㏈��
###

Write-Verbose "$psName End"
