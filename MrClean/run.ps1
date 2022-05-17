using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})

## Variables
$StorageAccountName = $env:StorageAccountName
$StorageResourceGroupName = $env:StorageResourceGroupName
$StorageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $StorageResourceGroupName

## Funtion for removing containers, needs to be put ahead of the other
Function DeleteStorageContainer  
{  
    Write-Host -ForegroundColor Red $container.Name "has been removed successfully!"
    ## Delete a container  
    Remove-AzStorageContainer -Container $container.Name -Context $StorageAccount.Context
}
## Showing list of containers, then for each container run blob argument against it and remove if greater than or equal 1
Function StorageContainer
{
    Write-Host -ForegroundColor Blue "Retreiving container list..."
    Get-AzStorageContainer -Context $StorageAccount.Context
    $containers = Get-AzStorageContainer -Context $StorageAccount.Context
    # Iterate containers, display properties
    Foreach ($container in $containers) 
    {
        $blobs = Get-AzStorageBlob -Context $StorageAccount.Context -Container $container.Name
        if ($blobs.count -ge 1) {
            Write-Host -ForegroundColor Green $container.Name "is not empty, it contains" $blobs.Name.count "files!" 
            Write-Host "Skipping..."
        } else {
            Write-Host -ForegroundColor Yellow $container.Name "has no files, deleting..."
            DeleteStorageContainer
        }
    }

}

StorageContainer
Write-Host -ForegroundColor Blue "Script complete!"
Write-Host -ForegroundColor Blue "Containers remaining after cleanup:"
Get-AzStorageContainer -Context $StorageAccount.Context
