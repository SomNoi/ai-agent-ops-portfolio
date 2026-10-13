<#
.SYNOPSIS
  Sanitized watchdog for a self-hosted AI agent gateway on Windows.
  Intended to run every 5 minutes from Task Scheduler as the agent's OWN user
  (not SYSTEM; SYSTEM resolves a different profile/home folder).

.NOTES
  - All paths/names are placeholders. Configure via the params below.
  - No secrets are read or written by this script.
  - Back-off: after $MaxRestartsPerHour restarts it stops trying and raises an alert,
    so a broken update cannot cause a restart storm.
#>
[CmdletBinding()]
param(
  [string]$AgentHome       = "$env:LOCALAPPDATA\agent",          # agent home folder
  [string]$ProcessMatch    = 'gateway',                           # substring in the gateway command line
  [string]$StartCommand    = 'agent',                             # CLI on PATH
  [string[]]$StartArgs     = @('gateway','start'),
  [int]$MaxRestartsPerHour = 3,
  [int]$MinFreeDiskGB      = 5,
  [int]$MinFreeRamMB       = 500
)

$ErrorActionPreference = 'Stop'
$LogDir   = Join-Path $AgentHome 'watchdog'
$LogFile  = Join-Path $LogDir 'watchdog.log'
$StateFile= Join-Path $LogDir 'restarts.json'
$ResumeNote = Join-Path $LogDir 'RESUME_NOTE.md'
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

function Write-Log([string]$level, [string]$msg) {
  $line = '{0} [{1}] {2}' -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'), $level, $msg
  Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

function Get-Gateway {
  Get-CimInstance Win32_Process -Filter "Name='python.exe' OR Name='pythonw.exe' OR Name='node.exe'" |
    Where-Object { $_.CommandLine -and $_.CommandLine -match [regex]::Escape($ProcessMatch) }
}

function Get-RecentRestarts {
  if (-not (Test-Path $StateFile)) { return @() }
  $cut = (Get-Date).AddHours(-1)
  @((Get-Content $StateFile -Raw | ConvertFrom-Json) | Where-Object { [datetime]$_ -gt $cut })
}

# 1) Health checks (alert only; never auto-delete anything)
$drive = Get-PSDrive -Name ($env:SystemDrive.TrimEnd(':'))
$freeGB = [math]::Round($drive.Free / 1GB, 1)
if ($freeGB -lt $MinFreeDiskGB) { Write-Log 'ALERT' "Low disk: $freeGB GB free on $env:SystemDrive" }
$freeRamMB = [int]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB)
if ($freeRamMB -lt $MinFreeRamMB) { Write-Log 'ALERT' "Low RAM: $freeRamMB MB free" }

# 2) Liveness
$gw = Get-Gateway
if ($gw) { Write-Log 'OK' "Gateway alive (PID $($gw[0].ProcessId)); disk $freeGB GB; ram $freeRamMB MB"; exit 0 }

# 3) Back-off guard
$recent = Get-RecentRestarts
if ($recent.Count -ge $MaxRestartsPerHour) {
  Write-Log 'ALERT' "Gateway down; $($recent.Count) restarts in last hour. Backing off; human attention needed."
  exit 2
}

# 4) Restart + resume note
Write-Log 'WARN' 'Gateway not running; restarting.'
try {
  Start-Process -FilePath $StartCommand -ArgumentList $StartArgs -WindowStyle Hidden
  Start-Sleep -Seconds 20
  $ok = [bool](Get-Gateway)
} catch { $ok = $false; Write-Log 'ERROR' "Start failed: $($_.Exception.Message)" }

$recent += (Get-Date).ToString('o')
$recent | ConvertTo-Json | Set-Content -Path $StateFile -Encoding UTF8

@"
# Resume note ($(Get-Date -Format 'yyyy-MM-dd HH:mm zzz'))
The watchdog restarted the gateway (result: $(if($ok){'running'}else{'NOT confirmed'})).
On your first message after restart: state the last task, its state (done/partial/unknown),
and that you did NOT retry it automatically. Then ask what to do next.
"@ | Set-Content -Path $ResumeNote -Encoding UTF8

if ($ok) { Write-Log 'OK' 'Gateway restarted and confirmed.'; exit 0 }
else     { Write-Log 'ERROR' 'Gateway restart not confirmed.'; exit 1 }
