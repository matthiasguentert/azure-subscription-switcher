Function Switch-AzContext {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red 'Azure CLI not installed!'
        break
    }
    
    $azContext = az account list -o json | ConvertFrom-Json
    $azActive = $azContext | Where-Object { $_.isDefault -eq $true}
    
    $available = @()
    $azContext | ForEach-Object { $index = 1 } {
        if ($_.Id -eq $azActive.Id) {
            $available += [PSCustomObject]@{
                Active = "=>"
                Index = $index++
                Subscription = $_.Name
                SubscriptionId = $_.Id
                Account = $_.user.Name
            }
        }
        else {
            $available += [PSCustomObject]@{
                Active = $null
                Index = $index++
                Subscription = $_.Name
                SubscriptionId = $_.Id
                Account = $_.user.Name
            }
        }
    }
    
    $available | Format-Table
    
    try {
        [int]$userInput = Read-Host "Index (0 to quit)"
        
        if ($userInput -eq 0) {
            Write-Host -ForegroundColor Red 'Wont switch Azure CLI context!'
            break
        } elseif ($userInput -lt 1 -or $userInput -gt $index-1) {
            Write-Host -ForegroundColor Red 'Input out of range'
            break
        }
    
        $selection = $available | Where-Object { $_.Index -eq $userInput }
        Write-Host -ForegroundColor Cyan 'Switching to:', $selection.Subscription
        az account set --subscription $selection.SubscriptionId
    } catch {
        Write-Host -ForegroundColor Red "Luke, wrong input, the index you must use!"
    }
}