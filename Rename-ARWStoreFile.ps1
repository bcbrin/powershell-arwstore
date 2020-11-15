[CmdletBinding()]
param (
    $rootName = "history",
    $ext = "txt",
    $LogicalPath = "\",
    $NewName = "history_renamed",
    $Volume = 0

)

#Import Functions.ps1 
. ".\Functions.ps1"

#If FileName contains esc char
if($rootName.contains("'")) {
    $SQLFileName = $rootName.Replace("'","''")
}
else {
    $SQLFileName = $rootName
}


#If LogicalPath contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}


#Get File entries from File Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE FileName='$($SQLFileName)' OR FileName LIKE '$($SQLFileName).%' AND LogicalPath='$($SQL_LogicalPath)' AND Ext='$($Ext)' AND Volume='$($Volume)';"
Write-Verbose "Rename-ARWStoreFile: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query
$Files = $Files.Tables.Rows

if(!($Files)) {
    Write-Warning "Rename-ARWStoreFile: $($rootName) does not exist on Volume: $($Volume)"
    return
}

foreach ($File in $Files) {
    $NewFileName = ($File.FileName).Replace("$($rootName)","$($NewName)")
    
    #If FileName contains esc char
    if($NewFileName.contains("'")) {
        $SQLFileName = $NewFileName.Replace("'","''")
    }
    else {
     $SQLFileName = $NewFileName
    }


    
    #If LogicalPath contains esc char
    if(($File.LogicalPath).contains("'")) {
        $SQL_LogicalPath = ($File.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_LogicalPath = $File.LogicalPath
    }

    #Update File database entry
    $Query = "UPDATE [ARWStore].[dbo].[Files] SET FileName = '$($SQLFileName)' WHERE LogicalPath='$($SQL_LogicalPath)' AND FileID='$($File.FileID)' AND ComputerName='$($File.ComputerName)' AND Volume='$($Volume)';"
    Write-Verbose "Rename-ARWStoreFile: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}