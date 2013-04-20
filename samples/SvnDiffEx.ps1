# Windows PowerShell
# テンプレート

param($url, $outDir, $beforeRev, $afterRev, $envPattern)

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
    Write-Output "使い方：$psName SVNのURL 出力ディレクトリ [-BeforeRev 変更前リビジョン] [-AfterRev 変更後リビジョン] [-EnvPattern 環境依存文字列パターン]"
    Write-Output "環境依存文字列パターン - 環境依存ファイルを特定する際に使用する正規表現"
}

# 主処理を実行する。
# return - なし
function U-Run-Main() {
    if ($afterRev -eq $null) {
        $afterRev = "HEAD"
    }
    
    if (Test-Path -PathType Container $afterDiffDir) {
        Remove-Item -Force -Recurse $afterDiffDir
    }
    if (Test-Path -PathType Container $afterEnvDir) {
        Remove-Item -Force -Recurse $afterEnvDir
    }
    if (Test-Path -PathType Container $stepDir) {
        Remove-Item -Force -Recurse $stepDir
    }
    
    U-Checkout-Source
    U-Create-DiffList
    U-Copy-DiffFile
    U-Count-Step
}

function U-Checkout-Source() {
    Write-Verbose "チェックアウト開始 ${url}@${afterRev}"
    Invoke-Expression "svn co ${url}@${afterRev} $afterDir"
    
    if ($beforeRev -ne $null) {
        Write-Verbose "チェックアウト開始 ${url}@${beforeRev}"
        Invoke-Expression "svn co ${url}@${beforeRev} $beforeDir"
    }
}

function U-Create-DiffList() {
    Write-Verbose "差分リスト作成開始 ${url}@${beforeRev}:${afterRev}"
    
    if ($beforeRev -eq $null) {
        Invoke-Expression "svn list --recursive -r $afterRev $url" | Set-Content -Encoding String $listPath
    } else {
        Invoke-Expression "svn diff -r ${beforeRev}:${afterRev} --summarize ${url}" | %{
            if ($_ -match "^(.+) +(.+)$") {
                $encodedUrl = $matches[2]
                $decodedUrl = [System.Uri]::UnescapeDataString($encodedUrl)
                if ($decodedUrl -match "${url}/(.+)$") {
                    Write-Output $matches[1]
                } elseif ($decodedUrl -match "${url}$") {
                    # 出力不要
                } else {
                    Write-Output "# Warning 解析失敗 $_"
                    Write-Warning "Warning 解析失敗 $_"
                }
            } else {
                Write-Output "# Warning 解析失敗 $_"
                Write-Warning "Warning 解析失敗 $_"
            }
        } | Set-Content -Encoding String $listPath
    }
}

function U-Copy-DiffFile() {
    Write-Verbose "差分ファイルコピー開始 ${url}@${beforeRev}:${afterRev}"
    Get-Content $listPath | ?{
        $_.Trim().Length -ne 0 -and
        $_.Trim() -notmatch "^#"
    } | %{
        $afterPath = "$afterDir\$_"
        $afterDiffPath = "$afterDiffDir\$_"
        if (Test-Path -PathType Leaf $afterPath) {
            $path = $null
            if ($envPattern -ne $null) {
                if (Get-Content $afterPath | Select-String -Quiet $envPattern) {
                    Write-Debug "ファイルコピー（環境依存） $_"
                    $path = "$afterEnvDir\$_"
                }
            }
            if ($path -eq $null) {
                Write-Debug "ファイルコピー $_"
                $path = $afterDiffPath
            }
            New-Item -Force -ItemType File $path | Out-Null
            Copy-Item $afterPath $path
        } elseif (Test-Path -PathType Container $afterPath) {
            Write-Debug "ディレクトリ作成 $_"
            New-Item -Force -ItemType Directory $afterDiffPath | Out-Null
        } else {
            Write-Warning "スキップ $_"
        }
    }
}

function U-Count-Step() {
    Write-Verbose "ソースステップ計測開始 ${url}@${beforeRev}:${afterRev}"
    
    New-Item -Force -ItemType Directory $stepDir | Out-Null
    
    # 全体カウント
    #Write-Verbose "変更後ソースカウント（テキスト形式）"
    #java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true "-output=${outDir}\AfterStep.txt"
    #Get-Content "${outDir}\AfterStep.txt" | Write-Debug
    Write-Verbose "変更後ソースカウント（CSV形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=csv "-output=${stepDir}\AfterStep.csv"
    Write-Verbose "変更後ソースカウント（Excel形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=excel "-output=${stepDir}\AfterStep.xls"

    # 差分カウント
    if ($beforeRev -ne $null) {
        Write-Verbose "差分ソースカウント（CSV形式）"
        java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=csv "-output=${stepDir}\DiffStep.csv"
        Write-Verbose "差分ソースカウント（Excel形式）"
        java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=excel "-output=${stepDir}\DiffStep.xls"
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
$beforeDir = "${outDir}\before"
$afterDir = "${outDir}\after"
$afterDiffDir = "${outDir}\afterDiff"
$afterEnvDir = "${outDir}\afterEnv"
$stepDir = "${outDir}\step"
$listPath = "${outDir}\DiffList.txt"
$jarPath = "$baseDir\..\stepcounter-3.0.1\eclipse-plugin\jp.sf.amateras.stepcounter\lib\stepcounter-3.0.1-jar-with-dependencies.jar"

Write-Debug "$psName Start"

###
### 主処理
###

if ($outDir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### 後処理
###

Write-Debug "$psName End"
