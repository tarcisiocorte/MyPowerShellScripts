#######SYSTEM SETTINGS
$wspName = "my_solution.wsp"
$recyclewarningminutes = 3;

$snapin = Get-PSSnapin | Where-Object { $_.Name -eq "Microsoft.SharePoint.Powershell" }
if ($snapin -eq $null) {
    Write-Host "Loading SharePoint Powershell"
    Add-PSSnapin "Microsoft.SharePoint.Powershell"
}

[string] $global:executionFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$wspLocation = $global:executionFolder

$isInstalled = Get-SPSolution | where { $_.Name -eq $wspName }
if ($isInstalled)
{
	$_wsp = $wspLocation + "\" + $wspName
	Update-SPSolution -Identity $wspName -LiteralPath $_wsp -GACDeployment
	Write-Host '[SOLUTION UPGRADE]' $wspName
}
else { Write-Host -ForegroundColor Yellow "$wspName cannot be upgraded because it's not installed" }

(RequestTimerServiceRecycle $recyclewarningminutes)

Write-Host -NoNewline "Upgrade of $wspName"
Write-Host -ForegroundColor Green "...Completed!"
