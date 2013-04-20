# Windows PowerShell
# テキストファイルに記述されたファイルを、コピーするPowerShellスクリプトです。

param($listpath, $srcdir, $destdir, $include, $exclude)

Set-StrictMode -Version Latest
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
    Write-Output "使い方：$psname リストファイル コピー元ディレクトリ コピー先ディレクトリ [-Include パターン] [-Exclude パターン]"
    Write-Output "リストファイル - 1行に1つのコピー対象ファイルパスを記述したテキストファイル"
    Write-Output "コピー元ディレクトリ - リストファイルに記述されたファイルを取得するディレクトリ"
    Write-Output "コピー先ディレクトリ - コピー先のディレクトリ"
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
            Write-Debug "ファイルコピー $_"
            New-Item -Force -ItemType File $destpath | Out-Null
            Copy-Item $srcpath $destpath
        } elseif (Test-Path -PathType Container $srcpath) {
            Write-Debug "ディレクトリ作成 $_"
            New-Item -Force -ItemType Directory $destpath | Out-Null
        } else {
            Write-Warning "スキップ $_"
        }
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
Write-Verbose "$psName Start"

###
### 主処理
###

if ($destdir -eq $null) {
    U-Write-Usage
} else {
    U-Copy-All
}

###
### 後処理
###
Write-Verbose "$psName End"
