function Get-AzureInstanceMetadata {
    $metadataUrl = "http://169.254.169.254/metadata/instance?api-version=2019-03-11"

    # Function to retrieve metadata for a specific key
    function Get-MetadataForKey {
        param (
            [string]$key
        )
        
        $metadataResponse = Invoke-RestMethod -Uri "$metadataUrl&$($key)=true" -Headers @{"Metadata"="true"} -Method GET -ErrorAction SilentlyContinue
        
        if ($?) {
            return $metadataResponse
        }
        else {
            Write-Host "Error retrieving metadata for key '$key'."
            return $null
        }
    }

    # Main function logic
    $metadata = @{}
    $metadataKeys = @("compute/location", "compute/resourceGroupName", "compute/name", "network/interface/0/ipv4/ipAddress/0/publicIpAddress", "network/interface/0/ipv4/ipAddress/0/privateIpAddress")

    foreach ($key in $metadataKeys) {
        $metadata[$key] = (Get-MetadataForKey -key $key) | ConvertTo-Json -Compress
    }

    return $metadata | ConvertTo-Json -Compress
}

# Example usage:
$azureInstanceMetadata = Get-AzureInstanceMetadata
if ($azureInstanceMetadata) {
    Write-Host "Azure Instance Metadata:"
    Write-Host $azureInstanceMetadata
}
