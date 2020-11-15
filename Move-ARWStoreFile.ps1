[CmdletBinding()]
param (
    $rootName = "javanotes",
    $ext = "txt",
    $LogicalPath = "\Java",
    $Destination = "\Store",
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#If rootName contains esc char
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
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath='$($SQL_LogicalPath)' AND FileName='$($SQLFileName)' OR FileName like '$($SQLFileName).%' AND Ext='$($Ext)' AND Volume='$($Volume)';"
Write-Verbose "Move-ARWStoreFile: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query
$Files = $Files.Tables.Rows

if(!($Files)) {
    Write-Warning "Move-ARWStoreFile: $($rootName) does not exist on Volume: $($Volume)"
    return
}

#Get Folder entries from Folders table
$Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE Volume='$($Volume)';"
Write-Verbose "Move-ARWStoreFile: Executing SQL Query: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query
$Folders = $Folders.Tables.Rows

#Check if Destination Folder Exists
if($Folders.LogicalPath -notcontains $($Destination)) {        
    Write-Warning "Move-ARWStoreFile: Folder $($Destination) does not exist."
    return
}

#Update LogicalPath of each File entry
foreach ($File in $Files) {   
    Write-Verbose "Move-ARWStoreFile: Replacing $($File.LogicalPath) with $($Destination) on $($File.FileName) on $($File.ComputerName)"

    #If FileName contains esc char
    if(($File.LogicalPath).contains("'")) {
        $SQL_FileName = ($File.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_FileName = $File.LogicalPath
    }


    #Update File database entry
    $Query = "UPDATE [ARWStore].[dbo].[Files] SET LogicalPath = '$($Destination)' WHERE LogicalPath='$($SQL_LogicalPath)' AND FileID='$($File.FileID)' AND ComputerName='$($File.ComputerName)' AND Volume='$($Volume)';"
    Write-Verbose "Move-ARWStoreFile: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}
