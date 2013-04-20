# Windows PowerShell
# FTPで、ファイルを取得するサンプルです。

param($hostName, $user, $password, $listPath, $destDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### 関数定義
######################################################################

# 使用方法を出力する。
# return - なし
function U-Write-Usage() {
    Write-Output "使い方：$psName ホスト ユーザ パスワード リストファイル 保存先ディレクトリ"
    Write-Output "リストファイル - 1行に1つのパスを記述したファイルのパス"
    Write-Output "　例：/pub/sourceforge.jp/ffftp/58201/ffftp-1.98g.zip"
}

# 主処理を実行する。
# return - なし
function U-Run-Main() {
    # FTPコマンドを一時ファイルに書き込む
    Get-Content $listPath | U-Out-Command | U-Out-SjisFile
    
    # FTP実行
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
### 処理実行
######################################################################

###
### 前処理
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$tmpPath = "$destDir\FtpGetWithList.tmp"

Write-Verbose "$psName Start"

###
### 主処理
###

if ($hostName -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### 後処理
###
Write-Verbose "$psName End"
