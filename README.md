# README

步驟4：table schema 如下， 建立兩個資料表，分別儲存任務以及使用者  
06/07：更正 schema，將 roles 更新為 role  

![dbdiagram](docs/dbdiagram.png)



## 部署網址 https://pleased-tildie-jonathanwu-6f7ad67b.koyeb.app/
06/12：部署到 https://www.koyeb.com，步驟如下

1. 建立 Koyeb 帳號，登入後，點 Create Web Service
2. Choose your deployment method: 選擇 GitHub
3. Import project: 選擇要部署的專案
4. Configure service and deploy: 用預設的選項即可，environment variables 要新增連接到 Koyeb 給的 PostgreSQL 的 production 的環境變數
5. 按下 Deploy 就會開始部署
6. 去 Databases 裡面按下 Create Database Service
7. 選擇預設的即可，按下 Create Database Service