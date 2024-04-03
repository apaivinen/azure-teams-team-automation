# azure-teams-team-automation
Automation for Microsoft Teams team creation

# Azure Verified Modules
This project is utilizing Azure Verified Modules for bicep deployment.  
res folder contains curated modules needed for deployment.
AVM Site: https://aka.ms/AVM  
AVM Github: https://github.com/Azure/bicep-registry-modules


# Deployment

```powershell
# Login az cli
az login

# Deploy resources
az deployment sub create -n "az-teamsResources-$(Get-Date -Format "yyyyMMddHHmmss")" -l westeurope -f ./main.bicep -p ./main.bicepparam

```