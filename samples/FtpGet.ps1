# Windows PowerShell
# FTP�ŁA�t�@�C�����擾����T���v���ł��B

param($srcUrl, $destPath)

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
    Write-Output "�g�����F$psname �擾��URL �ۑ���p�X"
    Write-Output "�擾��URL - ��Fftp://�`/aaa/xxx.zip"
    Write-Output "�ۑ���p�X - �ۑ���t�@�C���̐�΃p�X�\�L"
}

# �又�������s����B
# return - �Ȃ�
function U-Run-Main() {
    $webClient = New-Object System.Net.WebClient
    #$webClient.Credentials = New-Object System.Net.NetworkCredential("username", "password")
    $webClient.DownloadFile($srcUrl, $destPath)
    $webClient.Dispose()
    
    Get-ChildItem $destPath
    Write-Output ""
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

if ($srcUrl -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### �㏈��
###

Write-Verbose "$psName End"
