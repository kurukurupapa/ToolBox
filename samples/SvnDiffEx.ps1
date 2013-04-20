# Windows PowerShell
# �e���v���[�g

param($url, $outDir, $beforeRev, $afterRev, $envPattern)

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
    Write-Output "�g�����F$psName SVN��URL �o�̓f�B���N�g�� [-BeforeRev �ύX�O���r�W����] [-AfterRev �ύX�ナ�r�W����] [-EnvPattern ���ˑ�������p�^�[��]"
    Write-Output "���ˑ�������p�^�[�� - ���ˑ��t�@�C������肷��ۂɎg�p���鐳�K�\��"
}

# �又�������s����B
# return - �Ȃ�
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
    Write-Verbose "�`�F�b�N�A�E�g�J�n ${url}@${afterRev}"
    Invoke-Expression "svn co ${url}@${afterRev} $afterDir"
    
    if ($beforeRev -ne $null) {
        Write-Verbose "�`�F�b�N�A�E�g�J�n ${url}@${beforeRev}"
        Invoke-Expression "svn co ${url}@${beforeRev} $beforeDir"
    }
}

function U-Create-DiffList() {
    Write-Verbose "�������X�g�쐬�J�n ${url}@${beforeRev}:${afterRev}"
    
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
                    # �o�͕s�v
                } else {
                    Write-Output "# Warning ��͎��s $_"
                    Write-Warning "Warning ��͎��s $_"
                }
            } else {
                Write-Output "# Warning ��͎��s $_"
                Write-Warning "Warning ��͎��s $_"
            }
        } | Set-Content -Encoding String $listPath
    }
}

function U-Copy-DiffFile() {
    Write-Verbose "�����t�@�C���R�s�[�J�n ${url}@${beforeRev}:${afterRev}"
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
                    Write-Debug "�t�@�C���R�s�[�i���ˑ��j $_"
                    $path = "$afterEnvDir\$_"
                }
            }
            if ($path -eq $null) {
                Write-Debug "�t�@�C���R�s�[ $_"
                $path = $afterDiffPath
            }
            New-Item -Force -ItemType File $path | Out-Null
            Copy-Item $afterPath $path
        } elseif (Test-Path -PathType Container $afterPath) {
            Write-Debug "�f�B���N�g���쐬 $_"
            New-Item -Force -ItemType Directory $afterDiffPath | Out-Null
        } else {
            Write-Warning "�X�L�b�v $_"
        }
    }
}

function U-Count-Step() {
    Write-Verbose "�\�[�X�X�e�b�v�v���J�n ${url}@${beforeRev}:${afterRev}"
    
    New-Item -Force -ItemType Directory $stepDir | Out-Null
    
    # �S�̃J�E���g
    #Write-Verbose "�ύX��\�[�X�J�E���g�i�e�L�X�g�`���j"
    #java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true "-output=${outDir}\AfterStep.txt"
    #Get-Content "${outDir}\AfterStep.txt" | Write-Debug
    Write-Verbose "�ύX��\�[�X�J�E���g�iCSV�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=csv "-output=${stepDir}\AfterStep.csv"
    Write-Verbose "�ύX��\�[�X�J�E���g�iExcel�`���j"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=excel "-output=${stepDir}\AfterStep.xls"

    # �����J�E���g
    if ($beforeRev -ne $null) {
        Write-Verbose "�����\�[�X�J�E���g�iCSV�`���j"
        java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=csv "-output=${stepDir}\DiffStep.csv"
        Write-Verbose "�����\�[�X�J�E���g�iExcel�`���j"
        java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=excel "-output=${stepDir}\DiffStep.xls"
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
$beforeDir = "${outDir}\before"
$afterDir = "${outDir}\after"
$afterDiffDir = "${outDir}\afterDiff"
$afterEnvDir = "${outDir}\afterEnv"
$stepDir = "${outDir}\step"
$listPath = "${outDir}\DiffList.txt"
$jarPath = "$baseDir\..\stepcounter-3.0.1\eclipse-plugin\jp.sf.amateras.stepcounter\lib\stepcounter-3.0.1-jar-with-dependencies.jar"

Write-Debug "$psName Start"

###
### �又��
###

if ($outDir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### �㏈��
###

Write-Debug "$psName End"
