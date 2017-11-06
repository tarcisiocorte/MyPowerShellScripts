#SYSTEM SETTINGS
$wspName = "my_solution_file.wsp"

$snapin = Get-PSSnapin | Where-Object { $_.Name -eq "Microsoft.SharePoint.Powershell" }
if ($snapin -eq $null) {
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin "Microsoft.SharePoint.Powershell"
}

[string] $global:executionFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$wspLocation = $global:executionFolder + "\"

Write-Host "[INFO] ----------------------------------------"
Write-Host "[INFO] Upgrading $wspName"
Write-Host -NoNewLine "[INFO] Determining if $wspName is installed"

$isInstalled = Get-SPSolution | where { $_.Name -eq $wspName }
if ($isInstalled)
{
    Write-Host -ForegroundColor Yellow "...Yes!"

	$_wsp = $wspLocation + $wspName
	Update-SPSolution -Identity $wspName -LiteralPath $_wsp -GACDeployment
}
else { Write-Host -ForegroundColor Yellow "$wspName cannot be upgraded because it's not installed" }

Write-Host -NoNewline "[INFO] Upgrade of $wspName"
Write-Host -ForegroundColor Green "...Done!"
