<#
    This function returns the latest package information that has been installed using Ship.

    Prerequisites:
    - The SitecoreShip.zip content package is installed on the master database.
    - The recordInstallationHistory attribute in the packageInstallation element 
    in the web.config was set to true during the package installation.
    
    Example usage:
    .\get-latestversion.ps1 -SiteUrl mysite.dev -ConnectionTimeOutInSeconds 60 -MaxTimeOutInSeconds 300
#>

Param(
        [Parameter(Position=0, Mandatory=$true)]
        [string] $SiteUrl,
        [Parameter(Position=1)]
        [ValidateRange(0, 9999999)]
        [int] $ConnectionTimeOutInSeconds = 300,
        [Parameter(Position=2)]
        [ValidateRange(0, 9999999)]
        [int] $MaxTimeOutInSeconds = 900
    )


$latestVersionUrl = "$SiteUrl/services/package/latestversion"
$curlPath = .\get-curlpath.ps1
$curlCommand= "$curlPath --show-error --silent --connect-timeout $ConnectionTimeOutInSeconds --max-time $MaxTimeOutInSeconds $latestVersionUrl"

Write-Output "INFO: Starting Invoke-Expression: $curlCommand"

Invoke-Expression $curlCommand