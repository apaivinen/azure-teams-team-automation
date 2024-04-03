metadata name = 'Teams team automation'
metadata description = 'This bicep deploys Teams team creation & lifecycle resources.'
metadata author = 'Anssi Päivinen'
metadata Created = '2024-04-03'
metadata sourceinformation = 'Everything under web-folder is from Azure Verified Modules. Rest of the files are by by author.'
metadata AVMGithublink = 'https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/web'

// Setting target scope
targetScope = 'subscription'

@description('Required. Define a prefix to be attached to every service name. For example customer name abreviation')
param servicePrefix string  = 'leik'

@description('Required. General name of the service.')
param name string = 'TeamsCreation'

@description('Required. The name of the target environment (e.g. "dev" or "prod")')
param deploymentEnvironment string = 'dev'

@description('Specifies the location for resources.')
param location string = 'westeurope'

//
// Optional and dynamic parameters. Change only if necessary
//


@description('Tags for all resources within Azure Function App module.')
param tags object = {resource:'${servicePrefix}-${name}-${deploymentEnvironment}'}

//
// Variables
//
var ResourceGroupName = replace('RG-${name}-${deploymentEnvironment}',' ','')
var storageAccountName = take(toLower(replace(replace('${servicePrefix}${name}${deploymentEnvironment}${substring(uniqueString(deployment().name, location), 0, 4)}','-',''),' ','')),24)
var QueueServiceName = replace('${name}-Queue',' ','')
var AppServiceName = replace('${servicePrefix}-${name}-AppServ-${deploymentEnvironment}',' ','')
var functionAppName = replace('${servicePrefix}-${name}-FuncApp-${deploymentEnvironment}',' ','')
var functionAppWebsiteContentShare = replace(toLower('${functionAppName}${substring(uniqueString(deployment().name, location), 0, 4)}'),' ','')
var logicAppNameCreation =  replace('${servicePrefix}-${name}-Create-LogicApp-${deploymentEnvironment}',' ','')


//
// Load and create a Resource Group
//

module ResourceGroup 'res/resources/resource-group/main.bicep' = {
  name: ResourceGroupName
  scope: subscription()
  params: {
    name: ResourceGroupName
    location: location
    tags: tags
  }
}

module StorageAccount 'res/storage/storage-account/main.bicep' = {
  name: storageAccountName
  scope: resourceGroup(ResourceGroupName)
  dependsOn:[
    ResourceGroup
  ]
  params:{
    name: storageAccountName
    tags: tags
    location: location
  }
}

module QueueService 'res/storage/storage-account/queue-service/main.bicep' = {
  name: QueueServiceName
  scope: resourceGroup(ResourceGroupName)
  dependsOn: [
    StorageAccount
  ]
  params:{
    storageAccountName: storageAccountName
    queues:[
      'siteurl'
    ]
  }
}
