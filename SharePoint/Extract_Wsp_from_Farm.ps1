if (( Get-PSSnapin -Name "Microsoft.SharePoint.Powershell" -ErrorAction SilentlyContinue) -eq $null) { 
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin Microsoft.SharePoint.Powershell
}

$farm = Get-SPFarm
$file = $farm.Solutions.Item("Pobal.PIP.ServiceHomepages.wsp").SolutionFile
$file.SaveAs("C:\Users\tcosta\Documents\tarcisio\Pobal.PIP.ServiceHomepages.wsp")