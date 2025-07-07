# 麻雀得点集計アプリ

会社の麻雀サークル向けの得点集計Webアプリケーションです。

## 技術スタック

### フロントエンド
- Vue 3
- Element Plus UI
- TypeScript
- Vite

### バックエンド
- Spring Boot 3.4
- MyBatis
- PostgreSQL
- Java 17

## 機能

### 部屋管理
- 月ごとの部屋作成
- 参加プレイヤーの登録
- ルール設定（ウマ・オカ・トビ）

### プレイヤー管理
- プレイヤーの登録・編集
- プレイヤー一覧表示

### 対局記録
- 4人対局の記録
- 得点・順位・起家・トビの記録
- 自動得点計算

### 集計機能
- 日次集計（部屋単位）
- 年間成績（プレイヤー単位）
- 統計情報の表示

## セットアップ

### 前提条件
- Docker & Docker Compose
- Node.js 18+
- Java 17+
- Maven 3.6+

### データベース起動
```bash
docker-compose up -d
```

### バックエンド起動
```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### フロントエンド起動
```bash
cd frontend
npm install
npm run dev
```

## アクセス
- フロントエンド: http://localhost:5173
- バックエンドAPI: http://localhost:8080/api

## 画面構成
- トップページ（部屋一覧）
- 部屋詳細ページ
- 対局入力ページ
- プレイヤー一覧ページ
- プレイヤー詳細ページ
- 年間成績ページ
