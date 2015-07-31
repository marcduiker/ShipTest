<#
    This script will upload a Sitecore update package ($updatePackagePath variable) to the Sitecore instances defined in the $siteNameArray variable.
    
    This script depends on:
    - Several Sitecore instances which must be up and running (see $siteNameArray).
    - The deploy-sitecorepackage.ps1 script which is expected to be located in the same folder.
    - The 1-customitemsA1-A3.update package which is expected to be located in the ..\resources folder.
 #>
 
function DeployUpdatePackageToSites
{
    Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string[]] $SiteNameArray,
    [Parameter(Position=1, Mandatory=$true)]
    [string] $PackagePath
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

        Write-Host "Calling deploy script for $site..."
        .\deploy-sitecorepackage.ps1 -SiteUrl $site -UpdatePackagePath "$PackagePath" -ConnectionTimeOutInSeconds 120 -MaxTimeOutInSeconds 600    
    }

    Write-Host "INFO: Done."
}

# These Siteocre sites should be up and running:
[string[]] $siteNameArray =@(
    'shipsc75rev150212',
    'shipsc80rev140922',
    'shipsc80rev141212',
    'shipsc80rev150223',
    'shipsc80rev150427',
    'shipsc80rev150621'
    )

# This is the update package that will be installed in all sites:
$updatePackagePath = Resolve-Path "$PSScriptRoot\..\resources\1-customitemsA1-A3.update"

if (-not (Test-Path $updatePackagePath))
{
    Write-Error "ERROR: $updatePackagePath not found."
    Exit
}

DeployUpdatePackageToSites -SiteNameArray $siteNameArray -PackagePath $updatePackagePath