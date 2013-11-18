# Windows PowerShell
# ���Ȃ�l�I�ȃV�X�e���J���̓��
#
# 2013/04/04 �V�K�쐬

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$DebugPreference = "Continue"

###
### �萔��`
###
$baseDir = Convert-Path $(Split-Path -Path $MyInvocation.InvocationName -Parent)

###
### �������s
###

# �J�����g�f�B���N�g���ݒ�
Push-Location $baseDir

# �s�v�t�@�C��/�f�B���N�g���폜
Get-ChildItem $basedir | ?{$_.PSIsContainer} |
?{-not $($_.Name -eq "samples")} |
?{-not $($_.Name -eq "user")} |
%{
    Write-Debug "�f�B���N�g���폜 $_"
    Remove-Item -Force -Recurse $_
}

# PATH���ϐ�����s�v�Ȑݒ���폜
$items = $($env:Path.Split(";") | Select-String -NotMatch -SimpleMatch $baseDir)
$env:Path = $items -join ";"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
Write-Output "-----------------------------------"
Write-Output "�K�v�ɉ����Ċ��ϐ�PATH���玟�̃f�B���N�g�����폜���Ă��������B"
Write-Output "$baseDir"
Write-Output "-----------------------------------"

# TOOLBOX_HOME���ϐ�
[System.Environment]::SetEnvironmentVariable("TOOLBOX_HOME", $null, [System.EnvironmentVariableTarget]::User)

exit 0
