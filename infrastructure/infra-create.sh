#!/usr/bin/bash
set -euo pipefail

location="<insert-your-azure-region-here>" # You can change this to your available Azure region
sku="B1" # You can change this to your preferred App Service plan SKU, e.g. free tier "F1"

random_number=$(shuf -i 10000-99999 -n 1)
resource_group="flask-app-${random_number}-rg"
app_service_plan="flask-plan-${random_number}"
web_app_name="flask-app-${random_number}"
health_config='{"healthCheckPath":"/healthz"}'

echo "Creating resource group: ${resource_group}"
az group create --name "${resource_group}" --location "${location}"

echo "Creating App Service plan (${sku}, Linux): ${app_service_plan}"
az appservice plan create --name "${app_service_plan}" --resource-group "${resource_group}" --location "${location}" --sku "${sku}" --is-linux

echo "Creating Web App: ${web_app_name}"
az webapp create --name "${web_app_name}" --resource-group "${resource_group}" --plan "${app_service_plan}" --runtime "PYTHON:3.13"

echo "Setting app setting APP_MESSAGE"
az webapp config appsettings set --name "${web_app_name}" --resource-group "${resource_group}" --settings APP_MESSAGE="Hello from the Azure!" SCM_DO_BUILD_DURING_DEPLOYMENT="true"

echo "Configuring health check endpoint"
az webapp config set --name "${web_app_name}" --resource-group "${resource_group}" --generic-configurations "${health_config}"

echo "Configuring startup command"
az webapp config set --name "${web_app_name}" --resource-group "${resource_group}" --startup-file "gunicorn --bind=0.0.0.0:8000 --workers=3 src.app:app"

echo "Enabling Always On"
az webapp config set --name "${web_app_name}" --resource-group "${resource_group}" --always-on true

echo "Done."
echo "Resource group: ${resource_group}"
echo "Web App: ${web_app_name}"
