# Manual Steps

## SQL Server Username / Password

There is an annoying issue when creating a SQL Server instance that it requires a username and password to be set. This is not used for anything other than to allow the instance to be created. I had automated the creation of the username/password and had a method of storing the credentials in KeyVault, but the generation of the password is not cryptographically secure and there are issues when it comes to scaling to more regions/instances. I have instead opted for this to be a manual step.

After the first run the following secrets need to be added to the KeyVault:

* `platform-sql-username`
* `platform-sql-password`
  
These secrets will be used when creating any of the SQL Server instances. This does mean that all the sql servers have the same admin credentials but as the intention is to use AAD for AuthN/AuthZ this is not a problem.

The params file for the environments will need to be validated to ensure they are referencing the correct keyvault and secrets.

---

## SQL Server Directory Readers

The SQL Server instances needs to be able to read from the AAD directory to be able to use AAD accounts for AuthN/AuthZ. This was originally automated with the view to coming back to it as the deployment SPN is required to be high privilege.

On return to the problem; it has been to setup the `dev` environment; which would mean that the dev SPN would also need to have that high privilege access. Through various attempts to automate this each time I have ended up at a privilege escalation scenario, dishing out more privileges than needed or generally more identities having the privileges than likeable. As such this will be a manual step; it is one time at the point of environment creation or when a new SQL server instance is added.

Required step is therefore one time per new SQL server that the SQL server managed identity is added to the `Directory readers` AAD role through the portal.
