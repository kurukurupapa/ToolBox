# Windows PowerShell
# �f�B���N�g�����폜����X�N���v�g�ł��B

param($dir)

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
    Write-Output "�g�����F$psName �폜�f�B���N�g��"
}

# �又�������s����B
# return - �Ȃ�
function U-Run-Main() {
    if (Test-Path -PathType Container $dir) {
        Remove-Item -Force -Recurse $dir
    }
    
    Write-Verbose "�폜�f�B���N�g��=$dir"
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

if ($dir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### �㏈��
###

Write-Verbose "$psName End"
