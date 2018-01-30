if (( Get-PSSnapin -Name "Microsoft.SharePoint.Powershell" -ErrorAction SilentlyContinue) -eq $null) { 
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin Microsoft.SharePoint.Powershell
}

$fileName = "your_file.wsp"

# 1 - Uninstall the solution
Uninstall-SPSolution -identity $fileName

Remove-SPSolution -identity $fileName