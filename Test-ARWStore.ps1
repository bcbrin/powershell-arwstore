#Import Functions.ps1 
. ".\Functions.ps1"

############################################################################################################################################################
################################################################### 4 NODES ###############################################################################
############################################################################################################################################################
$Log = @()
$N = 4

#10MB
#Single -  4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }



#Double - 4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Single - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#100MB
#Single -  4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#1000MB
#Single -  4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 4 Nodes - 2 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 2
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 4 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init2x2 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save2x2 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get2x2 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove2x2 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove2x2.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Export Results to Log
$Log | Select -Property N,FileSize,Init,Save,Get,Remove,Copies,MaxParts | Export-Csv -NoTypeInformation -Path C:\BBRIN\ARWStore\perf2x2.csv


############################################################################################################################################################
################################################################### 16 NODES ###############################################################################
############################################################################################################################################################
#10MB
#Single -  16 Nodes - 4 Parts
$Computers = Get-Content .\SenComputers16.txt
Reset-ARWStore ($Computers)
$FileName = "history"
$Extension = "txt"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$FromFolder = "C:\BBRIN\Stuff\"
$fromFolder1 = "I:\Books\"
$Volume = 0
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -Volume $Volume }
$SaveFolder4x4 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder $fromFolder -LogicalPath "\" -Volume $Volume }
$SaveFolder4x4 = Measure-Command { .\Save-ARWStoreFolder.ps1 -Verbose -fromFolder $fromFolder1 -LogicalPath "\BBRIN" -Volume $Volume }
$RemoveFile4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -Verbose -LogicalPath "\" -Volume $Volume -rootName $FileName -ext $Extension }
$RemoveFolder4x4 = Measure-Command { .\Remove-ARWStoreFolder.ps1 -Verbose -LogicalPath "\" -Recurse -Volume $Volume }
$RenameFile4x4 = Measure-Command { .\Rename-ARWStoreFile.ps1 -Verbose -LogicalPath "\" -Volume $Volume -rootName $FileName -ext $Extension -NewName "newhistory" }
$RenameFolder4x4 = Measure-Command { .\Rename-ARWStoreFolder.ps1 -Verbose -LogicalPath "\Scripts" -Volume $Volume -NewName "\NewScripts" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFolder.ps1 -Verbose -restorePath $RestorePath -LogicalPath "\Scripts" -Recurse -Volume $Volume }
$Get4x4 = Measure-Command { .\Get-ARWStoreFolder.ps1 -Verbose -restorePath $RestorePath -LogicalPath "\" -Recurse -Volume $Volume }
$MoveFile4x4 = Measure-Command { .\Move-ARWStoreFile.ps1 -rootName "newhistory" -ext "txt" -LogicalPath "\" -Destination "\Jan" -Verbose -Volume $Volume }
Remove-Item -Path "\\S-0016-121320\c$\ARWStore" -Recurse
$Update4x4 = Measure-Command { .\Update-ARWStore.ps1 -Verbose -Volume $Volume }


##############################################################################################################################################################
$Log = @()
$N = 16

#10MB
#Single -  16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer4.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#100MB
#Single -  16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#1000MB
#Single -  16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Export Results to Log
$Log | Select -Property N,FileSize,Init,Save,Get,Remove,Copies,MaxParts | Export-Csv -NoTypeInformation -Path C:\BBRIN\ARWStore\perf4x4.csv


############################################################################################################################################################
################################################################### 64 NODES ###############################################################################
############################################################################################################################################################






#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 8
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer64.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "10MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#100MB
#Single -  16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "100MB"
$Extension = "mp3"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#1000MB
#Single -  16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 4 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 4
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Single - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension  -LogicalPath "\" }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\" }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Single"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry

#Double - 16 Nodes - 6 Parts
Reset-ARWStore
$FileName = "1000MB"
$Extension = "iso"
$MaxParts = 6
$ReserveComputers = Get-Content -Path "C:\BBRIN\ARWStore\Reserve.txt"
$RestorePath = "C:\BBRIN\ARWStore\Restore\"
$Computers = Get-Content .\Computer16.txt
$Init4x4 = Measure-Command { .\Init-ARWStoreDB.ps1 -Verbose -ComputerName $Computers -MaxParts $MaxParts -ReserveComputers $ReserveComputers -SecondaryCopy }
$Save4x4 = Measure-Command { .\Save-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\" }
$Get4x4 = Measure-Command { .\Get-ARWStoreFile.ps1 -Verbose -rootName $FileName -ext $Extension -LogicalPath "\"  }
$Remove4x4 = Measure-Command { .\Remove-ARWStoreFile.ps1 -rootName $FileName -ext $Extension -Verbose -LogicalPath "\"  }
$LogEntry = New-Object -TypeName PSObject
Add-Member -InputObject $LogEntry -Type NoteProperty -Name N -Value $N
Add-Member -InputObject $LogEntry -Type NoteProperty -Name FileSize -Value $FileName
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Init -Value $Init4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Save -Value $Save4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Get -Value $Get4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Remove -Value $Remove4x4.TotalSeconds
Add-Member -InputObject $LogEntry -Type NoteProperty -Name Copies -Value "Double"
Add-Member -InputObject $LogEntry -Type NoteProperty -Name MaxParts -Value $MaxParts
$Log += $LogEntry


#Export Results to Log
$Log | Select -Property N,FileSize,Init,Save,Get,Remove,Copies,MaxParts | Export-Csv -NoTypeInformation -Path C:\BBRIN\ARWStore\perf4x4.csv
