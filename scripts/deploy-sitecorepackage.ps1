﻿<#
    This function uploads & installs the specified Sitecore update package to the given $SiteUrl.
    It uses cURL (http://curl.haxx.se/) to post a request to a Sitecore website which has Sitecore Ship installed.

    Example usage: 
    .\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\1-mysite-templates.update" 60 300
#>

Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$SiteUrl,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$UpdatePackagePath,
    [Parameter(Position=2)]
    [ValidateRange(0, 9999999)]
    [int]$ConnectionTimeOutInSeconds = 300,
    [Parameter(Position=3)]
    [ValidateRange(0, 9999999)]
    [int]$MaxTimeOutInSeconds = 900
)

$fileUploadUrl = "$SiteUrl/services/package/install/fileupload"
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

$curlCommand= "$curlPath --show-error --silent --connect-timeout $ConnectionTimeOutInSeconds --max-time $MaxTimeOutInSeconds --form ""filename=@$UpdatePackagePath"" $fileUploadUrl"

Write-Output "INFO: Starting Invoke-Expression: $curlCommand"

Invoke-Expression $curlCommand

