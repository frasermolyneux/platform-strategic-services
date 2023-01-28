param (
    $environment
)

# Server Admin Group
$config = (Get-Content "./params/platform.$environment.json" | ConvertFrom-Json)

. "./.azure-pipelines/scripts/functions/CreateAADGroup.ps1" -groupName "sg-sql-platform-admins-$environment-$($config.parameters.parInstance.value)"