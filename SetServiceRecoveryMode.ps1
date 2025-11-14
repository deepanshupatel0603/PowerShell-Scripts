#Recovery Mode of Service
function Set-ServiceRecovery {
    param (
        [string] [Parameter(Mandatory=$true)] $ServiceName,
        [int] $resetPeriod = 86400, # in seconds (1 day)
        [int] $restartDelay = 60000 # in milliseconds (1 minute)
    )

    $actions = "restart/$restartDelay/restart/$restartDelay/restart/$restartDelay"
    sc.exe failure $ServiceName reset= $resetPeriod actions= $actions
}

# Example usage
Set-ServiceRecovery -ServiceName "YourServiceName"
