param (
    $environment
)

# Server Admin Group
$config = (Get-Content $(Build.sourcesDirectory)/params/platformKeyVault.$environment.json | ConvertFrom-Json)

. "./.azure-pipelines/scripts/functions/CreateAADGroup.ps1" -groupName "sg-sql-platform-admins-$environment-$($config.parameters.parInstance.value)"