# Windows PowerShell
# かなり個人的なシステム開発の道具箱
#
# 2013/04/04 新規作成

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
#$DebugPreference = "Continue"
$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

######################################################################
### 定数定義
######################################################################
$tmpDir = Join-Path $baseDir "tmp"
$arcDir = Join-Path $tmpDir "archives"
$unarcDir = Join-Path $tmpDir "unarchive"
$toolDir = $baseDir
$userDir = Join-Path $baseDir "user"

$unzipPath = Join-Path $toolDir "gnuwin32\bin\unzip.exe"
$is64bit = -not $($env:PROCESSOR_ARCHITECTURE -eq "x86")

######################################################################
### 関数定義
######################################################################

# ツールを準備する。
# $srcUrl - アーカイブファイルのURL
# $destDir - アーカイブ展開先ディレクトリ
# return - なし
function U-Setup-Archive($srcUrl, $destDir, $fname = $null, $destCheck = $null) {
    # ダウンロードファイル保存時のパス設定
    if ($fname -eq $null) {
        $fname = U-Get-Name -url $srcUrl
    }
    $tmpPath = Join-Path $arcDir $fname
    
    # 展開済みチェックのパス設定
    if ($destCheck -eq $null) {
        $destCheck = $destDir
    }
    
    # 既に、展開先済みの場合、何もしない。
    if (-not $(Test-Path $destCheck)) {
        # アーカイブファイルをダウンロードする
        if (-not $(Test-Path $tmpPath)) {
            U-Download-File -srcUrl $srcUrl -destPath $tmpPath
        }
        
        # アーカイブファイルを展開する
        U-Unarchive-File -srcPath $tmpPath -destDir $destDir
        
        # binディレクトリがあればパスを通す
        $binDir = Join-Path $destDir "bin"
        if (Test-Path $binDir) {
            U-AddTo-PathEnv $binDir
        }
    } else {
        echo "スキップ $srcUrl"
    }
    return
}

# ツールを準備する。
# $srcUrl - ファイルのURL
# $destDir - 配置先ディレクトリ
# return - なし
function U-Setup-File($srcUrl, $destDir) {
    $fname = U-Get-Name -url $srcUrl
    $destPath = Join-Path $destDir $fname
    if (-not $(Test-Path $destPath)) {
        New-Item -ItemType directory -Force $destDir | Out-Null
        U-Download-File -srcUrl $srcUrl -destPath $destPath
    }
    return
}

# アーカイブファイルをダウンロードする。
# $srcUrl - ダウンロードするURL
# $destPath - 保存するパス
# return - なし
function U-Download-File($srcUrl, $destPath) {
    $webClient = New-Object System.Net.WebClient
    Write-Output "ダウンロード開始 $srcUrl"
    try {
        #$webClient.Proxy = New-Object System.Net.WebProxy("proxyserver.co.jp:8080")
        #$webClient.Proxy.Credentials = New-Object System.Net.NetworkCredential("username", "password")
        $webClient.DownloadFile($srcUrl, $destPath)
    }
    catch {
        Write-Error $_
        exit 1
    }
    #Write-Output "終了"
    return
}

# 作業ディレクトリのアーカイブファイルを展開する。
# $srcPath - アーカイブファイル
# $destDir - 展開先ディレクトリ
# return - なし
function U-Unarchive-File($srcPath, $destDir) {
    Write-Output "アーカイブファイル展開開始 $srcPath"
    if (Test-Path $unzipPath) {
        # 展開先ディレクトリの調整
        $dirs = @(
            .\gnuwin32\bin\unzip.exe -l -qq $srcPath | %{
                $columns = $_ -split " +"
                $dirs = $columns[6] -split "/"
                $dirs[0]
            } | sort | Get-Unique
        )
        if ($dirs.Length -eq 1) {
            $destDir = Split-Path -Parent $destDir
        }
        
        # GnuWin32のunzip.exeを使って展開する
        # ・上書き
        # ・処理が終わるまで待機
        #Start-Process $unzipPath -ArgumentList -o, $srcPath, -d, $destDir -Wait -WindowStyle Minimized
        Invoke-Expression "$unzipPath -o $srcPath -d $destDir"
    } else {
        New-Item -ItemType directory -Force $destDir | Out-Null
        
        # Windows標準機能で展開する
        $sh = New-Object -ComObject Shell.Application
        $srcPathObj = $sh.NameSpace($srcPath)
        $destDirObj = $sh.NameSpace($destDir)
        $destDirObj.CopyHere($srcPathObj.Items())
    }
    #Write-Output "終了"
    return
}

# URLからファイルの名前を取得する。
# $url - URL
# return - ファイル名
function U-Get-Name($url) {
    return [System.IO.Path]::GetFileName($url)
}

# ディレクトリを削除する。
# $dir - 削除対象ディレクトリ
# return - なし
function U-Remove-Dir($dir) {
    if (Test-Path $dir) {
        Remove-Item -Force -Recurse $dir
    }
    return
}

# 環境変数PATHにツールの実行ディレクトリを追加する。
# $dir - 追加するディレクトリ
# return - なし
function U-AddTo-PathEnv($dir) {
    $pathEnv = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
    Write-Debug "環境変数Path変更前=[$pathEnv]"
    if ($pathEnv -notlike $("*" + $dir + "*")) {
        #$pathEnv = $pathEnv + ";" + $dir
        #[System.Environment]::SetEnvironmentVariable("Path", $pathEnv, [System.EnvironmentVariableTarget]::User)
        #Write-Debug "環境変数Path変更後=[$pathEnv]"
        Write-Output "-----------------------------------"
        Write-Output "必要に応じて環境変数PATHへ次のディレクトリを追加してください。"
        Write-Output "$dir"
        Write-Output "-----------------------------------"
    }
    return
}

######################################################################
### 処理実行
######################################################################

###
### 前処理
###

# カレントディレクトリ設定
Push-Location $baseDir

# 作業ディレクトリなど作成
New-Item -ItemType directory -Force $arcDir | Out-Null
New-Item -ItemType directory -Force $toolDir | Out-Null
New-Item -ItemType directory -Force $userDir | Out-Null

###
### コマンド・言語
###

# GnuWin32
# ・unzipを始めに実施し、以降の処理では、unzip.exeを使用する。
# ・依存ファイルのZIP（xxx-dep.zip）が必要な場合、実行ファイルのZIP（xxx-bin.zip）よりも先に記述すること。
$destDir = Join-Path $toolDir "gnuwin32"
$gnuwinList = @( `
    @("http://sourceforge.net/projects/gnuwin32/files/unzip/5.51-1/unzip-5.51-1-bin.zip", $(Join-Path $destDir "bin\unzip.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/coreutils/5.3.0/coreutils-5.3.0-dep.zip", $(Join-Path $destDir "bin\cat.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/coreutils/5.3.0/coreutils-5.3.0-bin.zip", $(Join-Path $destDir "bin\cat.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/diffutils/2.8.7-1/diffutils-2.8.7-1-dep.zip", $(Join-Path $destDir "bin\diff.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/diffutils/2.8.7-1/diffutils-2.8.7-1-bin.zip", $(Join-Path $destDir "bin\diff.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/findutils/4.2.20-2/findutils-4.2.20-2-dep.zip", $(Join-Path $destDir "bin\find.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/findutils/4.2.20-2/findutils-4.2.20-2-bin.zip", $(Join-Path $destDir "bin\find.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/gawk/3.1.6-1/gawk-3.1.6-1-bin.zip", $(Join-Path $destDir "bin\gawk.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/grep/2.5.4/grep-2.5.4-dep.zip", $(Join-Path $destDir "bin\grep.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/grep/2.5.4/grep-2.5.4-bin.zip", $(Join-Path $destDir "bin\grep.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/gzip/1.3.12-1/gzip-1.3.12-1-bin.zip", $(Join-Path $destDir "bin\gzip.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/sed/4.2.1/sed-4.2.1-dep.zip", $(Join-Path $destDir "bin\sed.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/sed/4.2.1/sed-4.2.1-bin.zip", $(Join-Path $destDir "bin\sed.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/tar/1.13-1/tar-1.13-1-dep.zip", $(Join-Path $destDir "bin\tar.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/tar/1.13-1/tar-1.13-1-bin.zip", $(Join-Path $destDir "bin\tar.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/wget/1.11.4-1/wget-1.11.4-1-dep.zip", $(Join-Path $destDir "bin\wget.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/wget/1.11.4-1/wget-1.11.4-1-bin.zip", $(Join-Path $destDir "bin\wget.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/zip/3.0/zip-3.0-dep.zip", $(Join-Path $destDir "bin\zip.exe")),
    @("http://sourceforge.net/projects/gnuwin32/files/zip/3.0/zip-3.0-bin.zip", $(Join-Path $destDir "bin\zip.exe")))
#"http://sourceforge.net/projects/gnuwin32/files/coreutils/5.3.0/coreutils-5.3.0-bin.zip"
#"http://sourceforge.net/projects/gnuwin32/files/coreutils/5.3.0/coreutils-5.3.0-dep.zip"
foreach($gnuwin in $gnuwinList) {
    U-Setup-Archive -srcUrl $gnuwin[0] -destDir $destDir -destCheck $gnuwin[1]
}

# GnuWin32のcoreutilsに含まれるコマンドのいくつかは、Windowsのコマンド名と重複する。
# Windows側に影響を与えないよう、GnuWin32の重複するコマンド名を変更する。
$targetList = @( `
    "date.exe",
    "dir.exe"
    "echo.exe",
    "expand.exe",
    "hostname.exe",
    "mkdir.exe",
    "rmdir.exe",
    "sort.exe",
    "whoami.exe")
foreach($target in $targetList) {
    if (Test-Path "${destDir}\bin\${target}") {
        Rename-Item "${destDir}\bin\${target}" "${destDir}\bin\_${target}"
    }
}

# Ruby
if ($is64bit) {
    U-Setup-Archive `
        -srcUrl "ftp://ftp.ruby-lang.org/pub/ruby/binaries/mswin32/ruby-1.9.2-p0-x64-mswin64_80.zip" `
        -destDir $(Join-Path $toolDir "ruby-1.9.2-p0-x64-mswin64_80")
} else {
    U-Setup-Archive `
        -srcUrl "ftp://ftp.ruby-lang.org/pub/ruby/binaries/mswin32/ruby-1.9.2-p136-i386-mswin32.zip" `
        -destDir $(Join-Path $toolDir "ruby-1.9.2-p136-i386-mswin32")
}

# Subversion
U-Setup-Archive `
    -srcUrl "http://subversion.tigris.org/files/documents/15/47914/svn-win32-1.6.6.zip" `
    -destDir $(Join-Path $toolDir "svn-win32-1.6.6")

###
### Java関連
###

# Ant
$antDir = Join-Path $toolDir "apache-ant-1.9.2"
U-Setup-Archive `
    -srcUrl "http://ftp.kddilabs.jp/infosystems/apache/ant/binaries/apache-ant-1.9.2-bin.zip" `
    -destDir $antDir

# Jakarta ORO
# http://jakarta.apache.org/oro/
$destDir = Join-Path $toolDir "jakarta-oro-2.0.8"
U-Setup-Archive `
    -srcUrl "http://archive.apache.org/dist/jakarta/oro/binaries/jakarta-oro-2.0.8.zip" `
    -destDir $destDir
copy $(Join-Path $destDir "jakarta-oro-2.0.8.jar") $(Join-Path $antDir "lib\")

# Apache Maven
# http://maven.apache.org/
$mavenDir = Join-Path $toolDir "apache-maven-3.0.5"
U-Setup-Archive `
    -srcUrl "http://ftp.jaist.ac.jp/pub/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.zip" `
    -destDir $mavenDir

# StepCounter
# https://github.com/takezoe/stepcounter
U-Setup-Archive `
    -srcUrl "https://github.com/takezoe/stepcounter/archive/3.0.1.zip" `
    -destDir $(Join-Path $toolDir "stepcounter-3.0.1")

###
### 色々
###

## Jenkins
#U-Setup-File `
#    -srcUrl "http://mirrors.jenkins-ci.org/war/latest/jenkins.war" `
#    -destDir $(Join-Path $toolDir "jenkins")

## FastStone Capture 5.3（フリーウェア版の最新）
## http://www.faststone.org/FSCaptureDetail.htm
#$destDir = Join-Path $toolDir "fscapture"
#U-Setup-Archive `
#    -srcUrl "http://www.aplusfreeware.com/categories/mmedia/files/fscapture.zip" `
#    -destDir $destDir
#U-AddTo-PathEnv $destDir

# RubyMiniCmd
# http://sourceforge.jp/projects/rubyminicmd/releases/?package_id=6370
U-Setup-Archive `
    -srcUrl "http://sourceforge.jp/frs/redir.php?m=jaist&f=/rubyminicmd/27373/rubyminicmd-20070930.zip" `
    -destDir $(Join-Path $toolDir "rubyminicmd-20070930")

## C#.NET MiniCmd
## http://sourceforge.jp/projects/rubyminicmd/releases/?package_id=9727
#$destDir = Join-Path $toolDir "vcsminicmd-0.4.2"
#U-Setup-Archive `
#    -srcUrl "http://sourceforge.jp/frs/redir.php?m=jaist&f=/rubyminicmd/50052/vcsminicmd-0.4.2.zip" `
#    -destDir $destDir
#U-AddTo-PathEnv $destDir

###
### 後片付けなど
###
$env:TOOLBOX_HOME = $baseDir
[System.Environment]::SetEnvironmentVariable("TOOLBOX_HOME", $env:TOOLBOX_HOME, [System.EnvironmentVariableTarget]::User)

# カレントディレクトリを戻す
Pop-Location

echo "正常終了"
exit 0
