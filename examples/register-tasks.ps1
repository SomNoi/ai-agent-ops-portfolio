<#
.SYNOPSIS
  Registers two scheduled tasks for a self-hosted agent (run in the agent user's own PowerShell; no SYSTEM):
    1) <Name>-autostart : start the gateway at logon
    2) <Name>-watchdog  : run watchdog.ps1 every 5 minutes
  Placeholders only; review before running. Remove with Unregister-ScheduledTask.
#>
param(
  [string]$Name         = 'agent',
  [string]$StartCommand = 'agent',
  [string]$StartArgs    = 'gateway start',
  [string]$WatchdogPath = "$PSScriptRoot\watchdog.ps1"
)
$user = "$env:USERDOMAIN\$env:USERNAME"
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited
$settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
               -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 4)

# 1) Autostart at logon
$a1 = New-ScheduledTaskAction -Execute $StartCommand -Argument $StartArgs
$t1 = New-ScheduledTaskTrigger -AtLogOn -User $user
Register-ScheduledTask -TaskName "$Name-autostart" -Action $a1 -Trigger $t1 -Principal $principal -Settings $settings -Force | Out-Null

# 2) Watchdog every 5 minutes
$a2 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$WatchdogPath`""
$t2 = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -TaskName "$Name-watchdog" -Action $a2 -Trigger $t2 -Principal $principal -Settings $settings -Force | Out-Null

# Verify
Get-ScheduledTask -TaskName "$Name-*" | Select-Object TaskName, State, @{n='RunAs';e={$_.Principal.UserId}}

# Kill-test (manual): stop the gateway process, then watch watchdog.log until it reports 'restarted and confirmed'.
