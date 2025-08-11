param(
    [int]$Port = 8080
)

$pids = @()

try {
    if (Get-Command Get-NetTCPConnection -ErrorAction SilentlyContinue) {
        $connections = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
        if ($connections) {
            $pids = $connections | Select-Object -ExpandProperty OwningProcess -Unique
        }
    } else {
        $lines = netstat -ano -p tcp | Select-String -Pattern (":$Port\s+LISTENING")
        if ($lines) {
            $pids = $lines | ForEach-Object { ($_ -split "\s+")[-1] } | Select-Object -Unique
        }
    }
} catch {
    Write-Warning ("Failed to inspect port ${Port}. " + $_.Exception.Message)
}

if (-not $pids -or $pids.Count -eq 0) {
    Write-Output "Port ${Port} is free"
    exit 0
}

Write-Output ("Port {0} is used by PIDs: {1}" -f $Port, ($pids -join ', '))

foreach ($pid in $pids) {
    try {
        $proc = Get-Process -Id $pid -ErrorAction Stop
        $path = $null
        try { $path = $proc.Path } catch { $path = $null }
        if (-not $path) { $path = '' }
        [PSCustomObject]@{
            Id = $proc.Id
            ProcessName = $proc.ProcessName
            Path = $path
        }
    } catch {
        Write-Output ("PID {0} (process info unavailable)" -f $pid)
    }
}



