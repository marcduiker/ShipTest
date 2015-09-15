<#
    This script will upload a Sitecore packages ($packages variable) to the Sitecore instances defined in the $siteNameArray variable.
    
    This script depends on:
    - Several Sitecore instances which must be up and running (see $siteNameArray).
    - The deploy-sitecorepackage.ps1 script which is expected to be located in the same folder.
    - The publish-sitecoresite.ps1 script which is expected to be located in the same folder.
    - 01-ShipTest.update package and 02-ShipTest.zip package which are expected to be located in the ..\resources folder.
 #>
 
function DeployPackagesAndPublish
{
    Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $SiteNameArray,
    [Parameter(Position=1, Mandatory=$true)]
    [string[]] $Packages
    )

    foreach ($siteName in $SiteNameArray)
    {
        $physicalSitePath = Get-Website $siteName | Select -ExpandProperty PhysicalPath
    
        $shipConfigFile = "ship.config"
        $appConfigFolder = Get-ChildItem -Path "$physicalSitePath" -Filter 'App_Config' | Where-Object { $_.PSIsContainer } | Select -ExpandProperty FullName
        $shipConfigFileInfo = Get-ChildItem -Path "$appConfigFolder" -File -Recurse -Filter $shipConfigFile
    
        if (-not "$shipConfigFileInfo")
        {
            Write-Error "ERROR: $shipConfigFile not found. Is Sitecore.Ship installed in $siteName ?"
            Exit
        }

        $site = "http://$siteName"

        foreach ($package in $Packages)
        {
            if (-not (Test-Path "$package"))
            {
                Write-Error "ERROR: $package not found."
                Exit
            }

            Write-Host "Calling deploy script for $site..."
            .\deploy-sitecorepackage.ps1 -SiteUrl $site -UpdatePackagePath "$package" -ConnectionTimeOutInSeconds 120 -MaxTimeOutInSeconds 600

            Write-Host "Calling get-latestversion script for $site..."
            .\get-latestversion.ps1 -SiteUrl $site -ConnectionTimeOutInSeconds 120 -MaxTimeOutInSeconds 600
        }

        Write-Host "Calling publish script for $site..."
            .\publish-sitecoresite.ps1 -SiteUrl $site -PublishMode smart -Languages 'en, nl-NL' -ConnectionTimeOutInSeconds 120 -MaxTimeOutInSeconds 600
    }

    Write-Host "INFO: Done."
}

 
# These Sitecore sites should be up and running:
[string[]] $siteNameArray=@(
    'shipsc75rev150212'#,
    #'shipsc80rev140922',
    #'shipsc80rev141212',
    #'shipsc80rev150223',
    #'shipsc80rev150427',
    #'shipsc80rev150621',
    #'shipsc80rev150812'
    )

# These are the packages that will be installed in all sites:
$package1 = Resolve-Path "$PSScriptRoot\..\resources\1-ShipTest.update" | Select -ExpandProperty Path
$package2 = Resolve-Path "$PSScriptRoot\..\resources\2-ShipTest.zip" | Select -ExpandProperty Path
$packages = @(
    $package1,
    $package2
    )

DeployPackagesAndPublish -SiteNameArray $siteNameArray -Packages $packages

