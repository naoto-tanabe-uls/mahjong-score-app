# Mahjong Score App - Azure Deployment Guide

## 概要
このガイドでは、Mahjong Score AppをAzureに最小コストでデプロイする手順を説明します。

## 構成
- **バックエンド**: Azure Container Instances (Spring Boot)
- **フロントエンド**: Azure Static Web Apps (Vue.js)
- **データベース**: Azure Database for PostgreSQL Flexible Server

## 月額コスト見積もり（20ユーザー想定）
- Container Instances: ¥1,500
- Static Web Apps: 無料
- PostgreSQL Flexible Server: ¥2,000
- **合計: 約¥3,500/月**

## デプロイ手順

### 1. 前提条件
- Azure CLIのインストール
- Docker Desktopのインストール
- GitHubリポジトリの準備

### 2. Azureリソースの作成

```bash
# Azure CLIでログイン
az login

# PowerShellスクリプトでリソース作成
./azure-setup.ps1
```

### 3. バックエンドのデプロイ

```bash
# Docker imageをビルド
cd backend
docker build -t mahjong-backend .

# Azure Container Registryにプッシュ
az acr login --name your-registry
docker tag mahjong-backend your-registry.azurecr.io/mahjong-backend:latest
docker push your-registry.azurecr.io/mahjong-backend:latest

# Container Instancesにデプロイ
./azure-deploy-backend.sh
```

### 4. フロントエンドのデプロイ

```bash
# Static Web Appsにデプロイ（GitHub Actionsで自動化）
# .github/workflows/azure-deploy.yml が自動実行されます
```

### 5. 環境変数の設定

以下の環境変数をAzureで設定してください：

```
DATABASE_URL=jdbc:postgresql://your-server.postgres.database.azure.com:5432/mahjong_db?sslmode=require
DATABASE_USERNAME=mahjong_admin
DATABASE_PASSWORD=your-secure-password
SPRING_PROFILES_ACTIVE=prod
```

### 6. データベースの初期化

```bash
# PostgreSQLに接続してテーブル作成
psql -h your-server.postgres.database.azure.com -U mahjong_admin -d mahjong_db
\i backend/src/main/resources/db/migration/001_create_tables.sql
```

## GitHub Secrets設定

GitHubリポジトリで以下のSecretsを設定してください：

```
AZURE_CREDENTIALS={"clientId":"...","clientSecret":"...","subscriptionId":"...","tenantId":"..."}
ACR_USERNAME=your-registry-username
ACR_PASSWORD=your-registry-password
DATABASE_URL=jdbc:postgresql://...
DATABASE_USERNAME=mahjong_admin
DATABASE_PASSWORD=your-secure-password
AZURE_STATIC_WEB_APPS_API_TOKEN=your-static-web-apps-token
```

## セキュリティ設定

### PostgreSQL
- SSL接続を強制
- Azure Services以外のアクセスを制限
- 強力なパスワードを使用

### Container Instances
- 必要最小限のポートのみ公開
- 環境変数でシークレット管理

### Static Web Apps
- HTTPS通信を強制
- カスタムドメインの設定推奨

## 監視とログ

### Application Insights（オプション）
月額約¥500で詳細な監視が可能：

```yaml
# application-prod.yml に追加
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
```

## トラブルシューティング

### よくある問題
1. **データベース接続エラー**: ファイアウォール設定を確認
2. **CORS エラー**: WebConfig.javaでCORS設定を確認
3. **Static Web Apps ビルドエラー**: package.jsonのbuildスクリプトを確認

### ログの確認
```bash
# Container Instancesのログ確認
az container logs --resource-group mahjong-rg --name mahjong-backend
```

## コスト最適化のヒント

1. **開発環境では Container Instances を停止**: 使用しない時は削除
2. **PostgreSQL を Burstable インスタンス**: トラフィックが少ない時間帯は自動でスケールダウン
3. **Static Web Apps の Free tier**: 月100GBまで無料

## スケーリング

ユーザー数が増加した場合：
- Container Instances → App Service Plan に移行
- PostgreSQL → General Purpose tier に移行
- Azure CDN の追加検討
