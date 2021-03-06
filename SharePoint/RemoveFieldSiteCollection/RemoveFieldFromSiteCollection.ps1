## get the staging environment argument
param([String] $e) 
if(-not($e)) { 
    Write-Host -ForegroundColor Red " The -e switch (staging environment) is required. E.g. -e DEV, -e FT, -e UAT, -e PROD]."
	break
}

# check to ensure Microsoft.SharePoint.PowerShell is loaded if not using the SharePoint Management Shell 
$snapin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.Powershell'} 
if ($snapin -eq $null) 
{    
	Write-Host "Loading SharePoint Powershell Snapin"    
	Add-PSSnapin "Microsoft.SharePoint.Powershell" 
}

## get the the node Config in the configuration file
$xmlPath = ".\Config.%.xml" -replace "%", $e
$xmlinput = [xml] (Get-Content -Path $xmlPath)

## read parameters
$item = $xmlinput.Config.AutoDeployment
$SiteCollection = $item.SiteCollection

$site = Get-SPSite $SiteCollection.url

#Declare the name of the Field/Column to be deleted
$FieldTobeDeleted = "MyCustomField1"
#Iterating webs....
foreach($web in $site.AllWebs)
{ 
	#Iterates through all the Lists                      
	for ($i = 0; $i -lt $web.Lists.Count; $i++) 
	{ 
		#If you want to filter some specific lists like only Document libraries, you could use if($list.BaseTemplate -eq 101). I am going through all the lists
		$list = $web.Lists[$i]; 										
		try
		{		
			#printing the list name for debugging purposes
			$listName = $list.Title.ToString();
			Write-Host "Now checking the list"  $list.Title.ToString();
			#Stage 1: Getting the content types collections and look for the field...
			$MyListContentTypes = $list.ContentTypes
			foreach($ct in $MyListContentTypes)
			{
				if ($ct -ne $null)
				{	
					$field = $ct.Fields[$FieldTobeDeleted]
					if ($field -ne $null)
					{
						Write-Host "Field Found in stage 1: printing the field ID and deleting the field"  $ct.Fields[$FieldTobeDeleted].Id;
						$ct.FieldLinks.Delete($ct.Fields[$FieldTobeDeleted].Id)		
						$ct.Update()	
					}
																				
				}	
			}

			#Stage 2: Maybe field is not within Content Types, and is added as a independent column, hidden, readonly?					
			$field = $list.Fields[$FieldTobeDeleted]
			if ($field -ne $null)
			{	
				Write-Host "Field Found in stage 2: printing the field ID and deleting the field"  $list.Fields[$FieldTobeDeleted].Id;
				$field.ReadOnlyField = $false
				$field.Hidden = $false					
				$field.Update()
				$list.Fields.Delete($field)
				$list.Update()
			}
			
		}									
		catch [Net.WebException] {
			Write-Host $_.Exception.ToString()
		}						   			
	}
	#Stage 3: Removing Field from Site collection's Content types
	if ($web.IsRootWeb)
	{																								
		
		foreach($ct in $web.ContentTypes) 
		{
			$field = $ct.FieldLinks[$FieldTobeDeleted]			
			if($field -ne $null) {	
				Write-Host "Field Found in stage 3: printing the field ID and deleting the field"  $ct.FieldLinks[$FieldTobeDeleted].Id;			
				$ct.FieldLinks.Delete($FieldTobeDeleted)
				$ct.Update()
			}
		}
		#Stage 4: Removing Field from Site columns
		if($web.Fields.ContainsFieldWithStaticName($FieldTobeDeleted)) 
		{
			Write-Host "Field Found in stage 4: printing the field ID and deleting the field"  $web.FieldLinks[$FieldTobeDeleted].Id;		
			$web.Fields.Delete($FieldTobeDeleted)
		}
	}	

	$web.Dispose();
}
$site.CatchAccessDeniedException = $true; 
$site.Dispose();  




     

 


