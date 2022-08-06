# Manual Steps

## SQL Server Directory Readers

The SQL Server instances needs to be able to read from the AAD directory to be able to use AAD accounts for AuthN/AuthZ. This was originally automated with the view to coming back to it as the deployment SPN is required to be high privilege.

On return to the problem; it has been to setup the `dev` environment; which would mean that the dev SPN would also need to have that high privilege access. Through various attempts to automate this each time I have ended up at a privilege escalation scenario, dishing out more privileges than needed or generally more identities having the privileges than likeable. As such this will be a manual step; it is one time at the point of environment creation or when a new SQL server instance is added.

Required step is therefore one time per new SQL server that the SQL server managed identity is added to the `Directory readers` AAD role through the portal.
