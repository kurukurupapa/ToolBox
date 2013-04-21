# Windows PowerShell
# 便利関数群を集めたスクリプトです。

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
#$VerbosePreference = "Continue"
#$DebugPreference = "Continue"

######################################################################
### 関数定義
######################################################################

function U-Remove-Dir() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string[]]$dirs
    )
    process {
        $dirs | %{
            if (Test-Path -PathType Container $_) {
                Remove-Item -Force -Recurse $_
            }
            Write-Verbose "削除ディレクトリ=$_"
        }
    }
}
