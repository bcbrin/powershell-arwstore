[CmdletBinding()]
param (
    $FileID = "d7986aee-baf8-432a-9fd7-de0b8180d0a4",
    $TargetNode = "H-0136-502W74",
    $Volume = 0    
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Import relavant Files Rows
$Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE FileID='$($FileID)' AND Volume='$($Volume)';"
Write-Verbose "Sync-ARWStoreFile: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query

$TargetPath = "\\$($TargetNode)\c$\ARWStore\"
$TargetFileName = $FileID
$Destination = "{0}{1}" -f ($TargetPath,$FileID)

foreach ($File in $Files.Tables.Rows) {
      #If File.LogicalPath contains esc char
    if(($File.LogicalPath).contains("'")) {
        $SQL_FileLogicalPath = ($File.LogicalPath).Replace("'","''")
    }
    else {
        $SQL_FileLogicalPath = $File.LogicalPath
    }

    #If File.FileName contains esc char
    if(($File.FileName).contains("'")) {
        $SQL_FileName = ($File.FileName).Replace("'","''")
    }
    else {
        $SQL_FileName = $File.FileName
    }



    try {        
        Write-Verbose "Sync-ARWStoreFile: Copying $($File.FilePath) to $($TargetPath)"
        Copy-Item -Path $File.FilePath -Destination $TargetPath -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Warning "Sync-ARWStoreFile: Unable to Copy $File.FilePath to $TargetPath"
    }

    if(Test-Path -Path $Destination) {
        Write-Verbose "Sync-ARWStoreFile: File Copy Successful"

        #Check File Integrety
        $OriginalFileHash = $File.Hash        
        $RestoreFileHash = Get-FileHash -Path $Destination | Select -ExpandProperty Hash

        if($OriginalFileHash -eq $RestoreFileHash) {
            Write-Verbose "Sync-ARWStoreFile: File integrity check passed"
            $DateSaved = Get-Date | Select -ExpandProperty Ticks
                                                 
            #Save FileDB entry and updated freespace to SQL
            $Query = "INSERT INTO [ARWStore].[dbo].[Files] (Volume,FileID,FileName,Ext,Size,Hash,DateSaved,ComputerName,LogicalPath,FilePath) VALUES ('$($Volume)','$($File.FileID)','$($SQL_FileName)','$($File.Ext)','$($File.Size)','$($RestoreFileHash)','$($DateSaved)','$($TargetNode)','$($SQL_FileLogicalPath)','$Destination');"
            Write-Verbose "Sync-ARWStoreFile: Executing SQL Query: $($Query)"
            Invoke-SQLQuery -Query $Query | Out-Null

            #Update FreeSpace
            Update-FreeSpace -ComputerName $TargetNode

            return
        }
        else {
            Write-Warning "Sync-ARWStoreFile: File integrety check failed"
            Remove-Item -Path $Destination
        }
        
    }
    else {
        Write-Verbose "Sync-ARWStoreFile: $($Destination) does not exist."
    }
}

Write-Warning "Sync-ARWStoreFile: Unable to find valid copy of $($TargetFileName)"




