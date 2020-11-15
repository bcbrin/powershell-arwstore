[CmdletBinding()]
param (       
    [string]$LogicalPath = "\Scripts\Test\Dink",
	$Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#If LogicalPath contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}


#Get Folder entries from Folders table
$Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE Volume='$($Volume)';"
Write-Verbose "New-ARWStoreFolder: Executing SQL Query: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query
$Folders = $Folders.Tables.Rows

#Check if folder already exists
if($Folders.LogicalPath -contains $LogicalPath) {
    Write-Warning "New-ARWStoreFolder: $($LogicalPath) already exists"
    return
}

#Create parents if they dont exist
while ($LogicalPath.LastIndexOf('\') -ne 0) {
    if($Folders.LogicalPath -notcontains $LogicalPath) { 
        #Create Folder in Folders Table
        $Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$($Volume)','$($LogicalPath)');"
        Write-Verbose "New-ARWStoreFolder: Executing SQL Query: $($Query)"
        Invoke-SQLQuery -Query $Query | Out-Null
    }
    
    #Set LogicalPath to Parent Directory
    $LogicalPath = $LogicalPath.SubString(0,$LogicalPath.LastIndexOf('\'))

    #Check if folder is in root
    if($LogicalPath.LastIndexOf('\') -eq 0) {
            if($Folders.ParentPath -notcontains $LogicalPath) { 
            #Create Folder in Folders Table
            $Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$($Volume)','$($LogicalPath)');"
            Write-Verbose "New-ARWStoreFolder: Executing SQL Query: $($Query)"
            Invoke-SQLQuery -Query $Query | Out-Null
        }
    }
}

#Create Folder in Folders Table
$Query = "INSERT INTO [ARWStore].[dbo].[Folders] (Volume,LogicalPath) VALUES ('$($Volume)','$($SQL_LogicalPath)');"
Write-Verbose "New-ARWStoreFolder: Executing SQL Query: $($Query)"
Invoke-SQLQuery -Query $Query | Out-Null









