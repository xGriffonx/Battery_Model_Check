<#	Query Machines for Model and Battery info
	Script Built: 4/21/17 - Tyler Wing
	Last Modified: 4/21/17 - Tyler Wing
	Configured for FZ-G1 devices
#>

Write-Host "Getting Machine Names"
$machinelist = get-content "c:\temp\machinelist.txt"

$MachineInfo = New-Object System.Collections.Generic.List[object]

foreach ($machine in $machinelist){
	if(Test-Connection -ComputerName $machine -Quiet){
		Write-Host "Getting Info from $machine" -ForegroundColor DarkGreen
		$ComputerModel = Get-WmiObject -ComputerName $machine -Property Model -Class Win32_ComputerSystem
		$computerBatteryModel = Get-WmiObject -ComputerName $machine -Property Name -Class Win32_Battery
		$MachineInfo.Add([PSCustomObject]@{
			ComputerName = $machine
			Model = $ComputerModel.Model
			BatterModel = $computerBatteryModel.Name
			}
		)
	}
	Else{
		Write-Host "$machine is Offline" -ForegroundColor Red
		Add-Content -Value $machine -Path c:\temp\offlinemachines.txt	
	}
}

Write-Host "Compiling Results"
$MachineInfo | Sort-Object ComputerName -Descending -Unique | Export-Csv -Path C:\TEMP\Toughpadresults.csv -NoTypeInformation -Force