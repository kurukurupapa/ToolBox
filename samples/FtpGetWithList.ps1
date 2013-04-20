# Windows PowerShell
# FTP�ŁA�t�@�C�����擾����T���v���ł��B

param($hostName, $user, $password, $listPath, $destDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
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
    Write-Output "�g�����F$psName �z�X�g ���[�U �p�X���[�h ���X�g�t�@�C�� �ۑ���f�B���N�g��"
    Write-Output "���X�g�t�@�C�� - 1�s��1�̃p�X���L�q�����t�@�C���̃p�X"
    Write-Output "�@��F/pub/sourceforge.jp/ffftp/58201/ffftp-1.98g.zip"
}

# �又�������s����B
# return - �Ȃ�
function U-Run-Main() {
    # FTP�R�}���h���ꎞ�t�@�C���ɏ�������
    Get-Content $listPath | U-Out-Command | U-Out-SjisFile
    
    # FTP���s
    Write-Verbose "FTP Start"
    Invoke-Expression "ftp -s:$tmpPath"
    Write-Verbose "FTP End"
}

function U-Out-Command() {
    begin {
        Write-Output "open $hostName"
        Write-Output "$user"
        Write-Output "$password"
        Write-Output "bin"
    }
    process {
        $outPath = "$destDir\$_"
        New-Item -Force -ItemType File $outPath | Out-Null
        $outDir = Convert-Path (Split-Path $outPath -Parent)
        Write-Output "lcd $outDir"
        Write-Output "get $_"
    }
    end {
        Write-Output "quit"
    }
}

function U-Out-SjisFile() {
    begin {
        New-Item -Force -ItemType File $tmpPath | Out-Null
    }
    process {
        Write-Output $_ | Add-Content -Encoding String $tmpPath
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
$tmpPath = "$destDir\FtpGetWithList.tmp"

Write-Verbose "$psName Start"

###
### �又��
###

if ($hostName -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### �㏈��
###
Write-Verbose "$psName End"
