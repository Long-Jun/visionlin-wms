# VisionLin WMS - 雲端即時倉庫 ERP

本專案是從 Gemini 對話紀錄中移轉並還原的「單一 HTML 檔案」雲端即時倉庫 ERP 系統。

## 技術棧與架構
- **前端技術**：純 HTML、CSS、Vanilla JavaScript。
- **雲端資料庫**：Google Firebase Cloud Firestore (Compat SDK 寫法，支援直接以 file:// 協議開啟)。
- **核心商業邏輯**：
  - **防衝突出入庫**：使用 Firestore `runTransaction` 確保原子性（Atomicity），防範多人同時操作庫存時的併發衝突（Race Condition）。
  - **批次寫入**：使用 Firestore `writeBatch` 處理大量儲位初始化及盤點差異修復。
  - **離線備份**：支援將雲端資料庫完整匯出為本地 JSON，並可利用備份檔執行覆寫還原。

## 系統功能頁面
1. **儀表板 (Dashboard)**：即時統計總儲位數、空儲位數、低於安全庫存品項、待驗與待報廢數，並顯示最新 50 筆異動紀錄。
2. **儲位主檔 (Locations)**：可批次自動鋪設 B1 與 1F 的標準層架，或自訂個別儲位。
3. **物料主檔 (Materials)**：管理料號、品名、規格、安全庫存等物料資訊。
4. **庫存明細 (Inventory)**：即時顯示各儲位的物料庫存數量與狀態（正常、待驗、待修、待報廢、借出），具備低庫存高亮提醒。
5. **出入庫/移位作業 (Transactions)**：支援入庫、出庫、移位、借出、歸還等作業，並記錄經手人與備份。
6. **盤點作業 (Stocktake)**：可依樓層/層架載入盤點單，人工輸入實盤數量後一鍵修復雲端庫存並記錄落差。
7. **標籤列印 (Labels)**：生成高清晰度實體儲位標籤（層架大標籤/每層小標籤），支援瀏覽器列印與 QR Code 框。
8. **資料備份與還原 (Data)**：提供一鍵導出 JSON 備份檔，並可上傳備份檔覆寫還原（需輸入關鍵字確認）。

## 如何開啟並使用系統
由於系統已全面升級為 **Firebase 相容版 SDK (Compat CDN)**，完全不需要架設任何伺服器，且無任何本地依賴項目：

1. **本機直接開啟**：您只需直接雙擊 [index.html](file:///c:/Users/user/Desktop/WMS/index.html)，即可直接在任何瀏覽器（如 Chrome/Edge/Firefox）中載入並執行。
2. **公開雲端網址 (跨設備最方便)**：
   - 您的系統已託管於 GitHub Pages，請使用任何手機、平板或電腦直接瀏覽專屬網址：  
     👉 **[https://long-jun.github.io/visionlin-wms/](https://long-jun.github.io/visionlin-wms/)**
   - 隨開即用，手機端可直接開啟實體相機掃描條碼與進行大卡片盤點，所有資料皆即時儲存至您的 Firebase 雲端資料庫！
