################################### >>> TEST THE FUNCTION <<< ###################################
#Variables
$WebURL="http://intranet.crescent.com"
$ListName="Change Request"
 
#Array to hold column titles
$ColumnNames=@("Change Type","Approvers","Proposed Date and Time")
 
#Process each column
$ColumnNames | foreach { 
    #Call the function to remove column
    Remove-Column $WebURL $ListName $_
}
#################################################################################################


#Custom Function to delete a column with PowerShell
Function Remove-Column($WebURL, $ListName, $ColumnName)
{
 
    #Get Internal Name of the columns
    $web = Get-SPWeb $WebURL
 
    #Get the list
    $list = $web.Lists.TryGetList($ListName)
 
    if($List -ne $null)
    {
        #Get the column
        $column = $list.Fields[$ColumnName]
 
        if($column -ne $null)
        {
            #Reset column properties to allow delete
            $column.Hidden = $false
            $column.ReadOnlyField = $false
            $column.AllowDeletion = $true
            $column.Update()
 
            #Delete the column from list
            $list.Fields.Delete($column)
            write-host "Column '$ColumnName' has been deleted!" -f Green
        }
        else
        {
            write-host "Specified column name not found!" -ForegroundColor Red
        }
    }
    else
    {
        write-host "Specified List is not found!" -ForegroundColor Red
    }
}


#Read more: http://www.sharepointdiary.com/2015/04/how-to-remove-column-from-sharepoint-list-using-powershell.html#ixzz5L2fDyrJw