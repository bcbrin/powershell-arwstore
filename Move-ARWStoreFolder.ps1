[CmdletBinding()]
param (       
    [string]$LogicalPath = "\Java\Stuff",
    [string]$Destination = "\Store",
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Setup Original Folder Name
$Start = $LogicalPath.LastIndexOf("\")
$End = $LogicalPath.Length - $Start
$FolderName = $LogicalPath.Substring($Start,$End)

#Setup Parent Path
if($FolderName -eq $LogicalPath) {
    $ParentPath = "\"
}
else {
    $ParentPath = $LogicalPath.Substring(0,$LogicalPath.LastIndexOf("$($FolderName)"))
}

#If LogicalPath contains esc char
if($LogicalPath.contains("'")) {
    $SQL_LogicalPath = $LogicalPath.Replace("'","''")
}
else {
    $SQL_LogicalPath = $LogicalPath
}

#Get Folder and SubFolders from Folder Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath LIKE '$($SQL_LogicalPath)%' AND Volume='$($Volume)';"
Write-Verbose "Move-ARWStoreFolder: Executing SQL Query: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query
$Folders = $Folders.Tables.Rows

#Get Files from Folder and Subfolders from Files Table
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath LIKE '$($SQL_LogicalPath)%' AND Volume='$($Volume)';"
Write-Verbose "Move-ARWStoreFolder: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query
$Files = $Files.Tables.Rows


#Update Folder and SubFolder LogicalPaths
foreach ($Folder in $Folders) {
    
    if($ParentPath -eq "\") {
        $NewLogicalPath = "{0}{1}" -f ($Destination,$Folder.LogicalPath)
    }
    else {
        $NewLogicalPath = ($Folder.LogicalPath).Replace("$($ParentPath)",$($Destination))
    }
    

    #If NewLogicalPath contains esc char
    if($NewLogicalPath.contains("'")) {
        $SQL_NewLogicalPath = $NewLogicalPath.Replace("'","''")
    }
    else {
        $SQL_NewLogicalPath = $NewLogicalPath
    }

    
    #If LogicalPath contains esc char
    if(($Folder.LogicalPath).contains("'")) {
        $SQL_LogicalPath = ($Folder.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_LogicalPath = $Folder.LogicalPath
    }

    Write-Verbose "Move-ARWStoreFolder: Replacing $($Folder.LogicalPath) with $($NewLogicalPath)"

    
    #Update Folder database entry
    $Query = "UPDATE [ARWStore].[dbo].[Folders] SET LogicalPath = '$($SQL_NewLogicalPath)' WHERE LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"
    Write-Verbose "Move-ARWStoreFolder: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}

#Update File and SubFolder File LogicalPaths
foreach ($File in $Files) {
    if($ParentPath -eq "\") {
        $NewLogicalPath = "{0}{1}" -f ($Destination,$Folder.LogicalPath)
    }
    else {
        $NewLogicalPath = ($Folder.LogicalPath).Replace("$($ParentPath)",$($Destination))
    }

    #If LogicalPath contains esc char
    if(($Folder.LogicalPath).contains("'")) {
        $SQL_LogicalPath = ($Folder.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_LogicalPath = $Folder.LogicalPath
    }


    #If File.LogicalPath contains esc char
    if(($File.LogicalPath).contains("'")) {
        $SQL_FileLogicalPath = ($File.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_FileLogicalPath = $File.LogicalPath
    }
   
    Write-Verbose "Move-ARWStoreFolder: Replacing $($File.LogicalPath) with $($NewLogicalPath) on $($File.FileName) on $($File.ComputerName)"

    #Update File database entry
    $Query = "UPDATE [ARWStore].[dbo].[Files] SET LogicalPath = '$($SQL_NewLogicalPath)' WHERE LogicalPath='$($SQL_FileLogicalPath)' AND FileID='$($File.FileID)' AND ComputerName='$($File.ComputerName)' AND Volume='$($Volume)';"
    Write-Verbose "Move-ARWStoreFolder: Executing SQL Query: $($Query)"
    Invoke-SQLQuery -Query $Query | Out-Null
}
