$snapin = Get-PSSnapin | Where-Object { $_.Name -eq "Microsoft.SharePoint.Powershell" }
if ($snapin -eq $null) {
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin "Microsoft.SharePoint.Powershell"
}

[SPFarm]$spFarm = Get-SPFarm

foreach($web in $spFarm.WebApplication)
{
    Write-Host $web.Title
}