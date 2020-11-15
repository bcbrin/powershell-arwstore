[CmdletBinding()]
param (       
    [string]$LogicalPath = "\Java\Stuff",
    [string]$NewName = "\Store",
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Setup Original Folder Name
$Start = $LogicalPath.LastIndexOf("\")
$End = $LogicalPath.Length - $Start
$OldName = $LogicalPath.Substring($Start,$End)

#If LogicalPath contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}

#Get Folder entries from Folders table
$Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath LIKE '$($SQL_LogicalPath)%' AND Volume='$($Volume)';"
Write-Verbose "Rename-ARWStoreFolder: Executing SQL Query: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query
$Folders = $Folders.Tables.Rows

#Get Files entries from Files table
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath LIKE '$($SQL_LogicalPath)%' AND Volume='$($Volume)';"
Write-Verbose "Rename-ARWStoreFolder: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query
$Files = $Files.Tables.Rows


#Update Folder name in Folders table
foreach ($Folder in $Folders) {    
    $NewPath = ($Folder.LogicalPath).Replace("$OldName","$NewName")

    #If NewPath contains esc char
    if($NewPath.contains("'")) {
        $SQL_NewPath = $NewPath.Replace("'","''")
    }
    else {
        $SQL_NewPath = $NewPath
    }


    #If LogicalPath contains esc char
    if(($Folder.LogicalPath).contains("'")) {
        $SQL_LogicalPath = ($Folder.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_LogicalPath = $Folder.LogicalPath
    }
    
    #Update Folder database entry
    $Query = "UPDATE [ARWStore].[dbo].[Folders] SET LogicalPath = '$($SQL_NewPath)' WHERE LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"
    Write-Verbose "Rename-ARWStoreFolder: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}

#Update file logical paths to new folder name
foreach ($File in $Files) {
    $NewPath = ($File.LogicalPath).Replace("$OldName","$NewName")

    #If NewPath contains esc char
    if($NewPath.contains("'")) {
        $SQL_NewPath = $NewPath.Replace("'","''")
    }
    else {
        $SQL_NewPath = $NewPath
    }

    #If FileName contains esc char
    if(($File.LogicalPath).contains("'")) {
        $SQL_LogicalPath = ($File.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_LogicalPath = $File.LogicalPath
    }

    #Update File database entry
    $Query = "UPDATE [ARWStore].[dbo].[Files] SET LogicalPath = '$($SQL_NewPath)' WHERE LogicalPath='$($SQL_LogicalPath)' AND FileID='$($File.FileID)' AND ComputerName='$($File.ComputerName)' AND Volume='$($Volume)';"
    Write-Verbose "Rename-ARWStoreFolder: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}

