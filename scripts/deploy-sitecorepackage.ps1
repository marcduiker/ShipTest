<#
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
# fileName must adhere to the ItemNameValidation setting in the web.config because a content item is made for each package in the master database.
# Therefore only the filename without extension is used since a dot (.) is not allowed.
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($UpdatePackagePath)
$curlPath = .\get-curlpath.ps1
$curlCommand= "$curlPath --show-error --silent --connect-timeout $ConnectionTimeOutInSeconds --max-time $MaxTimeOutInSeconds --form ""filename=@$UpdatePackagePath"" $fileUploadUrl -F ""packageId=$fileName"" -F ""description=description"""

Write-Output "INFO: Starting Invoke-Expression: $curlCommand"

Invoke-Expression $curlCommand

