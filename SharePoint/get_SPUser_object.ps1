if (( Get-PSSnapin -Name "Microsoft.SharePoint.Powershell" -ErrorAction SilentlyContinue) -eq $null) { 
    Write-Host "[INIT] Loading SharePoint Powershell Snapin"
    Add-PSSnapin Microsoft.SharePoint.Powershell
}
## GET A SPUser object
## VARIABLE TO CHANGE
$webUrl = "http://my_site_collection"
$web = Get-SPWeb -Identity $webUrl
$web.AllowUnsafeUpdates = $true
Write-Host $web.title


$user = GetUsersByEmail $web "test@email.com"
if($user -ne $null)
{
    Write-Host $user.Name
}


function GetUsersByEmail([Microsoft.SharePoint.SPWeb]$web, [string]$email)
{
    $query = New-Object Microsoft.SharePoint.SPQuery;
    $query.RowLimit = 1;
    $query.Query = "<Where><Eq><FieldRef Name='EMail' /><Value Type='Text'>" + $email + "</Value></Eq></Where>"

    $siteUserInfoList = $web.SiteUserInfoList;
    
    $usersCollection = $siteUserInfoList.GetItems($query)
    return $usersCollection[0]
}