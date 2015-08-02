<#
    This function publishes Sitecore content, layout and templates for the given $SiteUrl.
    
    Valid values for the optional $PublishMode argument are 'full', 'smart' and 'incremental'.
    If $PublishMode is empty it will default to 'smart'.
    
    Valid values for the optional $Languages is a comma delimited string with Sitecore language names. 
    If $Languages is empty it will default to 'en'.
    
    If $TimeOutInSeconds is empty it will default to 900.

    Example usage:
    .\publish-sitecore-site.ps1 -SiteUrl mysite.dev -PublishMode smart -Languages 'en, nl-NL'
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

#Write-Output "INFO: Starting Invoke-Expression: $curlCommand"

Invoke-Expression $curlCommand
#Invoke-WebRequest $latestVersionUrl -UseBasicParsing -TimeoutSec $ConnectionTimeOutInSeconds