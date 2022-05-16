# Azure Functions profile.ps1
#
# This profile.ps1 will get executed every "cold start" of your Function App.
# "cold start" occurs when:
#
# * A Function App starts up for the very first time
# * A Function App starts up after being de-allocated due to inactivity
#
# You can define helper functions, run commands, or specify environment variables
# NOTE: any variables defined that are not environment variables will get reset after the first execution
$global:subscription_id = "bbc94ccb-1e55-4b95-878c-c174172073f5"
$global:tenant_id = "939f4a83-33ed-4845-a346-516f14ad6321"
$global:StorageAccountName = $env:StorageAccountName
#Login:
Import-Module Az
Connect-AzAccount -Subscription $subscription_id -Tenant $tenant_id -Identity
$global:subscription = Get-AzSubscription -SubscriptionId $subscription_id -Tenant $tenant_id
Set-AzContext -SubscriptionId $subscription_id
Write-Host "Logged on to environment: "$subscription.Name -ForegroundColor "Cyan"
$Context = New-AzStorageContext $StorageAccountName -StorageAccountKey "Lln8pswcwoZaMW8imspM+gDIK57X8QXKKa2mVziyZ1+lzdXxzpiFIqeenTUWE0yPYeEhXRTnkTde+ASteE+PWg=="

# Authenticate with Azure PowerShell using MSI.
# Remove this if you are not planning on using MSI or Azure PowerShell.
if ($env:MSI_SECRET) {
    Disable-AzContextAutosave -Scope Process | Out-Null
    Connect-AzAccount -Identity
}

# Uncomment the next line to enable legacy AzureRm alias in Azure PowerShell.
# Enable-AzureRmAlias

# You can also define functions or aliases that can be referenced in any of your PowerShell functions.
