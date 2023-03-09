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
Write-Host -ForegroundColor Green "Currently active: $($context.Subscription.Name) ($($context.Subscription.Id))"

$selection = Read-Host "Switch"

# ... WIP