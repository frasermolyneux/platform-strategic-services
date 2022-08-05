param (
    $sqlServerName,
    $resourceGroup
)

$sqlServer = az sql server show --name $sqlServerName --resource-group $resourceGroup | ConvertFrom-Json
$principalId = $sqlServer.identity.principalId

. "./.azure-pipelines/scripts/functions/AddPrincipalToAADGroup.ps1" -principalId $principalId -groupName "sg-platform-directory-readers"