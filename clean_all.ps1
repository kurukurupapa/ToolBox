# Windows PowerShell
# かなり個人的なシステム開発の道具箱
#
# 2013/04/04 新規作成

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$DebugPreference = "Continue"

###
### 定数定義
###
$baseDir = Convert-Path $(Split-Path -Path $MyInvocation.InvocationName -Parent)

###
### 処理実行
###

# カレントディレクトリ設定
Push-Location $baseDir

# 不要ファイル/ディレクトリ削除
Get-ChildItem $basedir | ?{$_.PSIsContainer} |
?{-not $($_.Name -eq "samples")} |
?{-not $($_.Name -eq "user")} |
%{
    Write-Debug "ディレクトリ削除 $_"
    Remove-Item -Force -Recurse $_
}

# PATH環境変数から不要な設定を削除
$items = $($env:Path.Split(";") | Select-String -NotMatch -SimpleMatch $baseDir)
$env:Path = $items -join ";"
[System.Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
Write-Output "-----------------------------------"
Write-Output "必要に応じて環境変数PATHから次のディレクトリを削除してください。"
Write-Output "$baseDir"
Write-Output "-----------------------------------"

# TOOLBOX_HOME環境変数
[System.Environment]::SetEnvironmentVariable("TOOLBOX_HOME", $null, [System.EnvironmentVariableTarget]::User)

exit 0
