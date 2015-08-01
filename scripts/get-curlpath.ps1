<# 
    This script returns the full path of the curl.exe.
#>

$curlExe = 'curl.exe'
$curlPath = Resolve-Path "$PSScriptRoot\..\tools\curl-7.33.0-win64-nossl\$curlExe" # This is the local path.
if (-not (Test-Path $curlPath))
{
    # Fall-back to use curl.exe located in the same location as the script.
    if (Test-Path "$PSScriptRoot\$curlExe")
    {
        $curlPath = "$PSScriptRoot\$curlExe"
    }
    else
    {
        Write-Error "ERROR: $curlPath not found."
        Exit
    }
}

$curlPath