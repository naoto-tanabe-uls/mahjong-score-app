#!/bin/bash

# Azure リソース作成スクリプト

# 変数設定
RESOURCE_GROUP_NAME="mahjong-rg"
LOCATION="Japan East"
POSTGRES_SERVER_NAME="mahjong-postgres-server-$RANDOM"
DATABASE_NAME="mahjong_db"
ADMIN_USERNAME="mahjong_admin"
ADMIN_PASSWORD="SecurePass123!" # 実際には強力なパスワードを使用

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP_NAME --location "$LOCATION"

echo "Creating PostgreSQL server..."
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $POSTGRES_SERVER_NAME \
  --location "$LOCATION" \
  --admin-user $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 15 \
  --public-access 0.0.0.0 \
  --yes

echo "Creating database..."
az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP_NAME \
  --server-name $POSTGRES_SERVER_NAME \
  --database-name $DATABASE_NAME

echo "Configuring firewall rules..."
az postgres flexible-server firewall-rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $POSTGRES_SERVER_NAME \
  --rule-name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0

echo "Creating Container Registry..."
ACR_NAME="mahjongregistry$RANDOM"
az acr create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled true

echo "Creating App Service Plan..."
APP_SERVICE_PLAN="mahjong-plan"
az appservice plan create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $APP_SERVICE_PLAN \
  --location "$LOCATION" \
  --sku B1 \
  --is-linux

echo "Creating Web App for backend..."
BACKEND_APP_NAME="mahjong-backend-$RANDOM"
az webapp create \
  --resource-group $RESOURCE_GROUP_NAME \
  --plan $APP_SERVICE_PLAN \
  --name $BACKEND_APP_NAME \
  --deployment-container-image-name "openjdk:17-jdk-slim"

echo "Setup completed!"
echo "PostgreSQL Server: $POSTGRES_SERVER_NAME.postgres.database.azure.com"
echo "Container Registry: $ACR_NAME.azurecr.io"
echo "Backend Web App: $BACKEND_APP_NAME.azurewebsites.net"
echo "Database connection string: postgresql://$ADMIN_USERNAME@$POSTGRES_SERVER_NAME.postgres.database.azure.com:5432/$DATABASE_NAME?sslmode=require"
echo ""
echo "Next steps:"
echo "1. Build and push Docker images to Container Registry"
echo "2. Configure Web App to use Container Registry images"
echo "3. Set up Static Web App for frontend manually in Azure Portal"
