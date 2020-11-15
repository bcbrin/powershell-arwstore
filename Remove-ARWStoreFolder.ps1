[CmdletBinding()]
param (    
    $LogicalPath = "\Fortran",
    [switch]$Recurse,
    [switch]$RemoveFolders,
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


#Get Folders
if($Recurse) {
    $RecurseLogicalPath = "$($SQL_LogicalPath)%"
    $Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath like '$($RecurseLogicalPath)' AND Volume='$($Volume)';"    
}
else {
    $Query = "SELECT * FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"  
}

Write-Verbose "Remove-ARWStoreFolder: Executing SQL Query: $($Query)"
$Folders = Invoke-SQLQuery -Query $Query 


#If LogicalPath doesnt exist then exit
if($Folders.Tables.Rows.LogicalPath -notcontains $LogicalPath) {
    Write-Warning "Remove-ARWStoreFolder: $($LogicalPath) does not exist in Volume: $($Volume). Exiting"
    return
}


#Remove Files
if($Recurse) {
    $RecurseLogicalPath = "$($SQL_LogicalPath)%"
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath like '$($RecurseLogicalPath)' AND ComputerName='' AND Volume='$($Volume)';"    
}
else {
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath='$($SQL_LogicalPath)' AND ComputerName='' AND Volume='$($Volume)';"  
}

Write-Verbose "Remove-ARWStoreFolder: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query 


#For Each File
foreach ($File in $Files.Tables.Rows) {
    Write-Verbose "Remove-ARWStoreFolder: Running Remove-ARWStoreFile -rootName $($File.FileName) -ext $($File.Ext) -restorePath $($restorePath) -Volume $($Volume)"
    .\Remove-ARWStoreFile.ps1 -rootName $File.FileName -ext $File.Ext -LogicalPath $LogicalPath -Verbose -Volume $Volume
}


#Remove Folders
if($RemoveFolders) {
    foreach ($Folder in $Folders.Tables.Rows) {

        #If LogicalPath contains esc char
        if(($Folder.LogicalPath).contains("'")) {
            $SQL_LogicalPath = ($Folder.LogicalPath).Replace("'","''")
        }
        else {
            $SQL_LogicalPath = $Folder.LogicalPath
        }

        $Query = "DELETE FROM [ARWStore].[dbo].[Folders] WHERE LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"  
        Write-Verbose "Remove-ARWStoreFolder: Executing SQL Query: $($Query)"
        Invoke-SQLQuery -Query $Query | Out-Null
    }
}