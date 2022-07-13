param (
    $environment,
    $location
)

$keyVaultName = "kv-platform-$environment-$location"
$secretName = "sql-platform-$environment-$location-admin-password"

if ($null -eq (az keyvault secret show --name $secretName)) {
    $password = ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!£$%^&*()".tochararray() | Sort-Object { Get-Random })[0..18] -join ''
    az keyvault secret set --name $secretName --vault-name $keyVaultName --value $password --description 'text/plain' | Out-Null
    az keyvault secret set --name "sql-platform-$environment-$location-admin-username" --vault-name $keyVaultName --value "sql-platform-$environment-$location-addy" --description 'text/plain' | Out-Null
}
