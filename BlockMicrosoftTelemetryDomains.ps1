If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	
}

# copy script to windows folder
$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "hostsbuild.txt"
$destinationPath = Join-Path -Path "C:\Windows" -ChildPath "BlockMicrosoftTelemetryDomains.ps1"

# copy the original script to the new location
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

Write-Host "Script Copied Successfully From $sourcePath to $destinationPath"

# create scheduled task for script
$taskName = "BlockMicrosoftTelemetryDomains"
$scriptPath = "C:\Windows\BlockMicrosoftTelemetryDomains.ps1"
$taskDescription = "This Task Updates the BlockMicrosoftTelemetryDomains Script Automatically Every Day."
$trigger = New-ScheduledTaskTrigger -AtStartup
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount

# register the task
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description $taskDescription -TaskName $taskName

Write-Host "Successfully Created Scheduled Task for Script."

$input = Read-Host 'Done! Press Any Key to Exit'
if ($input) { exit }
