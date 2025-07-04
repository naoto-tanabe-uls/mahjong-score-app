#!/bin/bash

# Azure Container Instance deployment script
# Variables - Update these with your actual values
RESOURCE_GROUP="mahjong-rg"
LOCATION="japaneast"
CONTAINER_NAME="mahjong-backend"
IMAGE_NAME="your-registry.azurecr.io/mahjong-backend:latest"

# Database connection details
DB_HOST="your-postgres-server.postgres.database.azure.com"
DB_NAME="mahjong_db"
DB_USER="mahjong_user"
DB_PASSWORD="your-secure-password"

echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Deploying backend container..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image $IMAGE_NAME \
  --cpu 1 \
  --memory 1 \
  --ports 8080 \
  --dns-name-label mahjong-backend-unique \
  --environment-variables \
    SPRING_PROFILES_ACTIVE=prod \
    DATABASE_URL="jdbc:postgresql://$DB_HOST:5432/$DB_NAME?sslmode=require" \
    DATABASE_USERNAME=$DB_USER \
    DATABASE_PASSWORD=$DB_PASSWORD \
    SERVER_PORT=8080 \
    LOG_LEVEL=INFO

echo "Deployment completed!"
echo "Backend URL: http://mahjong-backend-unique.japaneast.azurecontainer.io:8080"
