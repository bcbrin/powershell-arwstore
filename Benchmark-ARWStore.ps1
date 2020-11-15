#Import Functions.ps1 
. ".\Functions.ps1"
$Log = @()

$ComputerLists = ".\Computer4.txt",".\Computer16.txt",".\Computer64.txt"
$N = "4","16","64"
$MaxPartsList = "2","4","8"

$FileNames = "10MB","100MB","1000MB"
$FileExts = "mp3","mp3","iso"


for($NodeIndex=0;$NodeIndex -lt $ComputerLists.Length;$NodeIndex++) {
    for($FileIndex=0;$FileIndex -lt $FileNames.Length;$FileIndex++)    {
        #Single       
        $FileName = $FileNames[$FileIndex]
        $Extension = $FileExts[$FileIndex]
        $MaxParts = $MaxPartsList[$NodeIndex]
        $ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
        $RestorePath = "C:\BBRIN\ARWStore\Restore\"
        $Computers = Get-Content -Path $($ComputerLists[$NodeIndex])
        Reset-ARWStore($Computers)
        Write-Output "Benchmark-ARWStore: Running Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers"
        $Init = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
        $Save = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
        $Get = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
        $Remove = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
        $LogEntry = New-Object -TypeName PSObject
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N[$NodeIndex]
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
        $Log += $LogEntry

        #Double        
        $FileName = $FileNames[$FileIndex]
        $Extension = $FileExts[$FileIndex]
        $MaxParts = $MaxPartsList[$NodeIndex]
        $ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
        $RestorePath = "C:\BBRIN\ARWStore\Restore\"
        $Computers = Get-Content $($ComputerLists[$NodeIndex])
        Reset-ARWStore($Computers)
        $Init = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
        $Save = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
        $Get = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
        $Remove = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
        $LogEntry = New-Object -TypeName PSObject
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N[$NodeIndex]
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove.TotalSeconds
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
        Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
        $Log += $LogEntry
    }
}

#Export Results to Log
$Log | Select -Property N,FileSize,Init,Save,Get,Remove,Copies,MaxParts | Export-Csv -NoTypeInformation -Path C:\BBRIN\ARWStore\bench_results.csv
Reset-ARWStore