function Get-NestedValue {
    param (
        [Parameter(Mandatory=$true)]
        [object]$Object,

        [Parameter(Mandatory=$true)]
        [string]$Key
    )

    $keys = $Key -split '/'
    $currentObject = $Object

    foreach ($k in $keys) {
        if ($currentObject -is [System.Collections.IDictionary]) {
            if ($currentObject.ContainsKey($k)) {
                $currentObject = $currentObject[$k]
            } else {
                Write-Host "Key '$k' not found in the object."
                return $null
            }
        } else {
            Write-Host "The current object is not a dictionary."
            return $null
        }
    }

    return $currentObject
}

# Example usage:
$object1 = @{"a" = @{"b" = @{"c" = "d"}}}
$key1 = "a"
$value1 = Get-NestedValue -Object $object1 -Key $key1
Write-Host "Value for '$key1' is '$value1'" -ForegroundColor Green

$object2 = @{"x" = @{"y" = @{"z" = "a"}}}
$key2 = "x/y/z"
$value2 = Get-NestedValue -Object $object2 -Key $key2
Write-Host "Value for '$key2' is '$value2'" -ForegroundColor Green
