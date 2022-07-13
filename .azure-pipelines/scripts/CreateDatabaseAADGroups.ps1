param (
    $environment
)

# Server Admin Group
. "./.azure-pipelines/scripts/functions/CreateAADGroup.ps1" -groupName "sg-sql-platform-$environment-admins"