if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red 'Azure CLI not installed!'
    exit;
}

if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Write-Host -ForegroundColor Red 'Azure PowerShell not installed!'
    exit;
}

# Get Azure CLI subscriptions 
$azSubscriptions = az account list -o json | ConvertFrom-Json
$azActive = $azSubscriptions | Where-Object { $_.isDefault -eq $true}

# Get Azure PowerShell subscriptions 
$psSubscriptions = Get-AzSubscription
$psActive = Get-AzContext

$currentSelection = @()
$currentSelection += [PSCustomObject]@{
    Type = 'Azure CLI';
    Name = $azActive.Name;
    Id = $azActive.Id;
}

$currentSelection += [PSCustomObject]@{
    Type = 'Azure PowerShell';
    Name = $psActive.Subscription.Name;
    Id = $psActive.Subscription.Id;
}

$available = @()
$azSubscriptions | ForEach-Object {
    $available += [PSCustomObject]@{
        Type = 'Azure CLI';
        Name = $_.Name;
        Id = $_.Id;
    }
}
$psSubscriptions | ForEach-Object {
    $available += [PSCustomObject]@{
        Type = 'Azure PowerShell';
        Name = $_.Name;
        Id = $_.Id;
    }
}

Write-Host -ForegroundColor Cyan 'Active subscriptions:'
$currentSelection | Format-Table | Sort-Object { $_.Type }

Write-Host -ForegroundColor Cyan 'Available subscriptions:'
$available | Sort-Object { $_.Type, $_.Name }

# $subscriptions = @()
# Get-AzSubscription | Foreach-Object { $index = 1 } {
#     $subscriptions += [PSCustomObject]@{
#         Index = $index;
#         Name = $_.Name; 
#         Id = $_.Id; 
#         TenantId = $_.TenantId;
#         State = $_.State; 
#     }; 
#     $index++    
# }

# $subscriptions | Format-Table
# $context = Get-AzContext
# Write-Host -ForegroundColor Green "Active: $($context.Subscription.Name) ($($context.Subscription.Id))"

# try {
#     [int]$selection = Read-Host "Index (0 to quit)"

#     if ($selection -eq 0) {
#         Write-Host -ForegroundColor Red 'Wont switch subscription!'
#         exit
#     }

#     $subscription = $subscriptions | Where-Object { $_.Index -eq $selection }
#     $result = Set-AzContext -SubscriptionObject $subscription

#     Write-Host -ForegroundColor Yellow 'Switched to:', $result.Subscription.Name
# } catch {
#     Write-Host -ForegroundColor Red "Luke, wrong input, the index you must use!"
# }