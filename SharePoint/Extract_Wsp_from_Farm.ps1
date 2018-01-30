if (( Get-PSSnapin -Name "Microsoft.SharePoint.Powershell" -ErrorAction SilentlyContinue) -eq $null) { 
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin Microsoft.SharePoint.Powershell
}

$farm = Get-SPFarm
$file = $farm.Solutions.Item("your_file.wsp").SolutionFile
$file.SaveAs("c:\temp\your_file.wsp")