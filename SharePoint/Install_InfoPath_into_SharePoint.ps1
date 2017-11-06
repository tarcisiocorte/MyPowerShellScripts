Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction "SilentlyContinue";

$currentPath = $(Get-Location).Path;
$infopathForm = "my_infopath_file.xsn";
$infoPathPath = $currentPath + "\" + $infopathForm;
$categoryFeesForm = "my_catetory";

Install-SPInfoPathFormTemplate -Path $infoPathPath -Confirm:$false

$infopathFormFeature = $null;
while($infopathFormFeature -eq $null)
{
	Start-Sleep 2
	$infopathFormFeature = Get-SPInfoPathFormTemplate -Identity $infopathForm
}
if($infopathFormFeature -ne $null)
{
	if($categoryFeesForm -ne $null)
	{
		Set-SPInfoPathFormTemplate -Identity $infopathForm -Category $categoryFeesForm
	}
	Write-Host "The '" + $infopathForm + "' file is successfully installed." -ForegroundColor Green                    
}
else
{
	Write-Host "Could not activate '" + $infopathForm + "' at site collection." -ForegroundColor Red                  
}