[CmdletBinding()]
param (
    $rootName = "CompTIA '",
    $ext = "pdf",
    $restorePath = "C:\BBRIN\ARWStore\Restore\",
    $LogicalPath = "\",
    $Volume = 0
)

#Import Functions.ps1 
. ".\Functions.ps1"

#Get MaxParts from Properties Table
$MaxParts = Get-MaxParts -Volume $Volume

$PartNumber = 0

#Foreach File Part
while ($PartNumber -lt  $MaxParts) {
    
    $Destination = "{0}{1}.{2}.{3}" -f ($restorePath, $rootName, $PartNumber, $ext)
    $FileName = "{0}.{1}.{2}" -f ($rootName,$PartNumber,$ext)
    $FilePart = "{0}.{1}" -f ($rootName,$PartNumber) 

    $Files = Get-FilesDBEntries -FileName $FilePart -LogicalPath $LogicalPath -Extension $Ext -Volume $Volume

    foreach ($File in $Files) {        
       
        try {
            Write-Verbose "Get-ARWStoreFile: Attempting to copy $($File.FilePath) to $($restorePath)"
            Copy-Item -LiteralPath $File.FilePath -Destination $Destination -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "Get-ARWStoreFile: $($File.FilePath) not available" 
        }

        #If File Copied Successful
        if(Test-Path -LiteralPath $Destination) {
            Write-Verbose "Get-ARWStoreFile: $($File.FilePath) copied to $($Destination)"
            $PartNumber++
            break
        }
        else {
            Write-Warning "Get-ARWStoreFile: $($File.FilePath) not found"    
        }
    }

    #Confirm File Part Copied
    if(Test-Path -LiteralPath $Destination) {
        Write-Verbose "Get-ARWStoreFile: $($Destination) confirmed"
        #Future file hash check        
    }
    else {
        Write-Warning "Get-ARWStoreFile: $($FileName) not found on any node. Operation Failed" 
        return
    }
}


#Combine Files to Original
Combine-Files -fromFolder $restorePath -rootName $rootName -ext $ext 

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

#Check file for consistency
$Query = "SELECT Hash FROM [ARWStore].[dbo].[Files] WHERE FileName='$($SQLFileName)' AND Ext='$($ext)' AND LogicalPath='$($SQL_LogicalPath)' AND ComputerName='' AND Volume='$($Volume)';"
Write-Verbose "Get-ARWStoreFile: Executing SQL Query: $($Query)"
$Result = Invoke-Sqlcmd -ServerInstance localhost -Query $Query

$OriginalFileHash = $Result.Hash
$FilePath = "{0}{1}.{2}" -f ($RestorePath,$rootName,$ext)
$RestoreFileHash = Get-FileHash -LiteralPath $FilePath | Select -ExpandProperty Hash

if($RestoreFileHash -eq $OriginalFileHash) {
    Write-Verbose "Get-ARWStoreFile: $FilePath has passed consistency check."
}
else {    
    Write-Warning "Get-ARWStoreFile: File restored is different from original."
}


#remove file parts
$i = 0
while ($i -lt ($MaxParts)) {
    $Parts = "{0}{1}.{2}.{3}" -f ($restorePath, $rootName, $i, $ext)
    Remove-Item -LiteralPath $Parts
    $i++
}

