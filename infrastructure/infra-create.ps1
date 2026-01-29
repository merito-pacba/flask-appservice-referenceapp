$ErrorActionPreference = "Stop"

$location = "<region>"   # You can change this to your available Azure region
$sku="B1"                # You can change this to your preferred App Service plan SKU, eg. free tier "F1"   

$randomNumber = Get-Random -Minimum 10000 -Maximum 99999
$resourceGroup = "flask-app-$randomNumber-rg"
$appServicePlan = "flask-plan-$randomNumber"
$webAppName = "flask-app-$randomNumber"
# $healthConfig = "{\""healthCheckPath\"":\""/healthz\""}"  # use in Windows PowerShell
$healthConfig = '{"healthCheckPath":"/healthz"}'            # use in Azure Portal Shell with PowerShell

Write-Host "Creating resource group: $resourceGroup"
az group create --name $resourceGroup --location $location | Out-Null

Write-Host "Creating App Service plan ($sku, Linux): $appServicePlan"
az appservice plan create --name $appServicePlan --resource-group $resourceGroup --location $location --sku $sku --is-linux | Out-Null

Write-Host "Creating Web App: $webAppName"
az webapp create --name $webAppName --resource-group $resourceGroup --plan $appServicePlan --runtime "PYTHON:3.13" | Out-Null

Write-Host "Setting app setting APP_MESSAGE"
az webapp config appsettings set --name $webAppName --resource-group $resourceGroup --settings APP_MESSAGE="Hello from the Azure!" | Out-Null

Write-Host "Configuring health check endpoint"
az webapp config set --name $webAppName --resource-group $resourceGroup --generic-configurations $healthConfig | Out-Null

Write-Host "Configuring startup command"
az webapp config set --name $webAppName --resource-group $resourceGroup --startup-file "gunicorn --bind=0.0.0.0:8000 --workers=3 app.app:app" | Out-Null

Write-Host "Done."
Write-Host "Resource group: $resourceGroup"
Write-Host "Web App: $webAppName"

