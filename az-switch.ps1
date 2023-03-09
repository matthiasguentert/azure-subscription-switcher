[CmdletBinding()]
param (
    [switch]
    $powershell,

    [switch]
    $azcli
)

$subscriptions = @()
Get-AzSubscription | Foreach-Object { $index = 1 } {
    $subscriptions += [PSCustomObject]@{
        Index = $index;
        Name = $_.Name; 
        Id = $_.Id; 
        TenantId = $_.TenantId;
        State = $_.State; 
    }; 
    $index++    
}

$subscriptions | Format-Table
$context = Get-AzContext
Write-Host -ForegroundColor Green "Active: $($context.Subscription.Name) ($($context.Subscription.Id))"

try {
    [int]$selection = Read-Host "Index (0 to quit)"

    if ($selection -eq 0) {
        Write-Host -ForegroundColor Red 'Wont switch subscription!'
        exit
    }

    $subscription = $subscriptions | Where-Object { $_.Index -eq $selection }
    $result = Set-AzContext -SubscriptionObject $subscription

    Write-Host -ForegroundColor Yellow 'Switched to:', $result.Subscription.Name
} catch {
    Write-Host -ForegroundColor Red "Luke, wrong input, the index you must use!"
}