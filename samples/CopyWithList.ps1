# Windows PowerShell
# �e�L�X�g�t�@�C���ɋL�q���ꂽ�t�@�C�����A�R�s�[����PowerShell�X�N���v�g�ł��B

param($listpath, $srcdir, $destdir, $include, $exclude)

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
    Write-Output "�g�����F$psname ���X�g�t�@�C�� �R�s�[���f�B���N�g�� �R�s�[��f�B���N�g�� [-Include �p�^�[��] [-Exclude �p�^�[��]"
    Write-Output "���X�g�t�@�C�� - 1�s��1�̃R�s�[�Ώۃt�@�C���p�X���L�q�����e�L�X�g�t�@�C��"
    Write-Output "�R�s�[���f�B���N�g�� - ���X�g�t�@�C���ɋL�q���ꂽ�t�@�C�����擾����f�B���N�g��"
    Write-Output "�R�s�[��f�B���N�g�� - �R�s�[��̃f�B���N�g��"
}

function U-Copy-All() {
    Get-Content $listpath | ?{
        $_.Trim().Length -ne 0 -and
        $_.Trim() -notmatch "^#" -and
        ($include -eq $null -or $_.Trim() -match $include) -and
        ($exclude -eq $null -or $_.Trim() -notmatch $exclude)
    } | %{
        $srcpath = "$srcdir\$_"
        $destpath = "$destdir\$_"
        if (Test-Path -PathType Leaf $srcpath) {
            Write-Debug "�t�@�C���R�s�[ $_"
            New-Item -Force -ItemType File $destpath | Out-Null
            Copy-Item $srcpath $destpath
        } elseif (Test-Path -PathType Container $srcpath) {
            Write-Debug "�f�B���N�g���쐬 $_"
            New-Item -Force -ItemType Directory $destpath | Out-Null
        } else {
            Write-Warning "�X�L�b�v $_"
        }
    }
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

if ($destdir -eq $null) {
    U-Write-Usage
} else {
    U-Copy-All
}

###
### �㏈��
###
Write-Verbose "$psName End"
