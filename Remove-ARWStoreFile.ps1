[CmdletBinding()]
param (
    $rootName = "100MB",
    $ext = "mp3",
    $LogicalPath = "\",
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Get MaxParts from Properties Table
$MaxParts = Get-MaxParts -Volume $Volume

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

if(!(Get-FilesDBEntries -FileName $rootName -Extension $ext -Volume $Volume -LogicalPath $LogicalPath)) {
    Write-Warning "Remove-ARWStoreFile: $($rootName).$($ext) does not exist on Volume: $($Volume)"
    return
}


$PartNumber = 0
while ($PartNumber -lt $MaxParts) {

    #Setup FileNames
    $FileName = "{0}.{1}" -f ($rootName,$PartNumber)
    $SQLFilePartName = "{0}.{1}" -f ($SQLFileName,$PartNumber)

    #Get Files Information From SQL
    $Files = Get-FilesDBEntries -FileName $FileName -LogicalPath $LogicalPath -Extension $ext -Volume $Volume

    foreach ($File in $Files) {
        #Confirm Connectivity to Node
        Write-Verbose "Remove-ARWStoreFile: Testing connectivity to $($File.ComputerName)"
        if(Test-Connection -ComputerName $File.ComputerName -Count 1 -Quiet) {
            Write-Verbose "Remove-ARWStoreFile: Successfully connected to $($File.ComputerName)"

            $FilePath = $File.FilePath
            Write-Verbose "Remove-ARWStoreFile: Testing path $($FilePath)"
            if(Test-Path -LiteralPath $FilePath) {
                Write-Verbose "Remove-ARWStoreFile: $($FilePath) exists"
                try {
                    Write-Verbose "Remove-ARWStoreFile: Removing $($FilePath)"
                    Remove-Item -LiteralPath $FilePath 
                }
                catch {
                    Write-Warning "Remove-ARWStoreFile: Unable to remove $($FilePath)"
                }

                #Confirm File Deleted
                if(Test-Path -LiteralPath $FilePath) {
                    Write-Warning "Remove-ARWStoreFile: $($FilePath) not deleted."                 
                }
                else {                    
                    Write-Verbose "Remove-ARWStoreFile: $($FilePath) deleted successfully"   
                    #Remove entry from Files table                    
                    $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE FileName='$($SQLFilePartName)' AND ComputerName='$($File.ComputerName)' AND LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"  
                    Write-Verbose "Remove-ARWStoreFile: Executing SQL Query: $($Query)"
                    Invoke-SQLQuery -Query $Query | Out-Null
                    

                    #Update FreeSpace in Nodes Table
                    Update-FreeSpace -ComputerName $File.ComputerName
                }               
            }
            else {
                Write-Warning "Remove-ARWStoreFile: $($FilePath) does not exist"
                #Remove entry from Files table                    
                $Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE FileName='$($SQLFilePartName)' AND ComputerName='$($File.ComputerName)' AND LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"  
                Write-Verbose "Remove-ARWStoreFile: Executing SQL Query: $($Query)"
                Invoke-SQLQuery -Query $Query | Out-Null
            }
        }
        #Connectivity Failed
        else {
            Write-Warning "Remove-ARWStoreFile: Unable to connect to $($File.ComputerName)"
        }               
    }

    $PartNumber++
}

#Remove Original File Entry - SQL Database
$Query = "DELETE FROM [ARWStore].[dbo].[Files] WHERE FileName='$($SQLFileName)' AND LogicalPath='$($SQL_LogicalPath)' AND Volume='$($Volume)';"  
Write-Verbose "Remove-ARWStoreFile: Executing SQL Query: $($Query)"
Invoke-SQLQuery -Query $Query | Out-Null

#Update Folder Information
Update-FolderTable