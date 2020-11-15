[CmdletBinding()]
param (
    $restorePath = "C:\BBRIN\ARWStore\Restore\",   
    $LogicalPath = "\Scripts",
    [switch]$Recurse,
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


#If Recurse is Selected
if($Recurse) {
    $RecurseLogicalPath = "$($SQL_LogicalPath)%"
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath LIKE '$($RecurseLogicalPath)' AND ComputerName='' AND Volume='$($Volume)';"  
}
else {
    $Query = "SELECT * FROM [ARWStore].[dbo].[Files] WHERE LogicalPath='$($SQL_LogicalPath)' AND ComputerName='' AND Volume='$($Volume)';"  
}

#Query Files Table for List of Files in LogicalPath
Write-Verbose "Get-ARWStoreFolder: Executing SQL Query: $($Query)"
$Files = Invoke-SQLQuery -Query $Query

foreach ($File in $Files.Tables.Rows) {
    #If logical path is nested folder
    if($File.LogicalPath -ne $LogicalPath) {
        Write-Verbose "Get-ARWStoreFolder: $($File.FileName).$($File.ext) is nested within $($File.LogicalPath) on Volume: $($Volume)"

        #Check if Folder Exists in Restore Path
        if($LogicalPath -eq "\") {
            $NestedRestorePath = "{0}{1}" -f ($RestorePath.SubString(0,$($RestorePath.Length)-1),$($File.LogicalPath))
        }
        else {
            $NestedRestorePath = "{0}{1}" -f ($RestorePath.Substring(0,$restorePath.Length-1),(($File.LogicalPath).replace($LogicalPath,'')))
        }
        
        Write-Verbose "Get-ARWStoreFolder: Testing path $($NestedRestorePath)"
        if(Test-Path -LiteralPath $NestedRestorePath) {
            $NestedRestorePath = "$($NestedRestorePath)\"
            Write-Verbose "Get-ARWStoreFolder: Running Get-ARWStoreFile -rootName $($File.FileName) -ext $($File.Ext) -restorePath $($NestedRestorePath) -LogicalPath $($LogicalPath) -Volume $($Volume)"
            .\Get-ARWStoreFile.ps1 -rootName $File.FileName -ext $File.Ext -restorePath $NestedRestorePath -LogicalPath $File.LogicalPath -Verbose -Volume $Volume
        }
        else {  
            Write-Verbose "Get-ARWStoreFolder: $($NestedRestorePath) not found. Creating new directory."          
            New-Item -Path $NestedRestorePath -ItemType Directory
            $NestedRestorePath = "$($NestedRestorePath)\"
           
            Write-Verbose "Get-ARWStoreFolder: Running Get-ARWStoreFile -rootName $($File.FileName) -ext $($File.Ext) -restorePath $($NestedRestorePath) -LogicalPath $($LogicalPath) -Volume $($Volume)"
            .\Get-ARWStoreFile.ps1 -rootName $File.FileName -ext $File.Ext -restorePath $NestedRestorePath -LogicalPath $File.LogicalPath -Verbose -Volume $Volume
        }
    }
    else {
        Write-Verbose "Get-ARWStoreFolder: Running Get-ARWStoreFile -rootName $($File.FileName) -ext $($File.Ext) -restorePath $($restorePath) -LogicalPath $($LogicalPath) -Volume $($Volume)"
        .\Get-ARWStoreFile.ps1 -rootName $File.FileName -ext $File.Ext -restorePath $restorePath -LogicalPath $LogicalPath -Verbose -Volume $Volume
    }    
}

    