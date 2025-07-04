# Azure リソース作成スクリプト

# 変数設定
$resourceGroupName = "mahjong-rg"
$location = "Japan East"
$postgresServerName = "mahjong-postgres-server-$(Get-Random)"
$databaseName = "mahjong_db"
$adminUsername = "mahjong_admin"
$adminPassword = "SecurePass123!" # 実際には強力なパスワードを使用

Write-Host "Creating resource group..."
az group create --name $resourceGroupName --location $location

Write-Host "Creating PostgreSQL server..."
az postgres flexible-server create `
  --resource-group $resourceGroupName `
  --name $postgresServerName `
  --location $location `
  --admin-user $adminUsername `
  --admin-password $adminPassword `
  --sku-name Standard_B1ms `
  --tier Burstable `
  --storage-size 32 `
  --version 15 `
  --public-access 0.0.0.0 `
  --yes

Write-Host "Creating database..."
az postgres flexible-server db create `
  --resource-group $resourceGroupName `
  --server-name $postgresServerName `
  --database-name $databaseName

Write-Host "Configuring firewall rules..."
az postgres flexible-server firewall-rule create `
  --resource-group $resourceGroupName `
  --name $postgresServerName `
  --rule-name AllowAzureServices `
  --start-ip-address 0.0.0.0 `
  --end-ip-address 0.0.0.0

Write-Host "Creating Container Registry..."
$acrName = "mahjongregistry$(Get-Random)"
az acr create `
  --resource-group $resourceGroupName `
  --name $acrName `
  --sku Basic `
  --admin-enabled true

Write-Host "Creating Static Web App..."
az staticwebapp create `
  --resource-group $resourceGroupName `
  --name "mahjong-frontend" `
  --location $location `
  --source "https://github.com/your-username/your-repo" `
  --branch "main" `
  --app-location "frontend" `
  --output-location "dist"

Write-Host "Setup completed!"
Write-Host "PostgreSQL Server: $postgresServerName.postgres.database.azure.com"
Write-Host "Container Registry: $acrName.azurecr.io"
Write-Host "Database connection string: postgresql://$adminUsername@$postgresServerName.postgres.database.azure.com:5432/$databaseName?sslmode=require"
