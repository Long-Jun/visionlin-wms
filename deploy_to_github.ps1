# VisionLin WMS 一鍵部署 GitHub Pages 腳本
$gitPath = 'C:\Program Files\Git\cmd\git.exe'
$ghPath = 'C:\Program Files\GitHub CLI\gh.exe'
$repoName = 'visionlin-wms'

Write-Output "=== 開始執行 WMS 雲端一鍵部署 ==="

# 1. 檢查 GitHub CLI 登入狀態
Write-Output "1. 檢查 GitHub 授權狀態..."
$authStatus = & $ghPath auth status 2>&1
if ($authStatus -match "Logged in to github.com") {
    Write-Output "-> 已成功授權 GitHub 帳號！"
} else {
    Write-Warning "-> 尚未偵測到 GitHub 登入授權！"
    Write-Warning "請在您的電腦上打開 CMD 或 PowerShell，執行以下指令完成瀏覽器登入授權："
    Write-Warning "   gh auth login"
    Write-Warning "登入完成後，再重新執行此部署腳本。"
    exit 1
}

# 2. 取得使用者 GitHub 帳號名稱
$username = & $ghPath api user --jq '.login'
Write-Output "-> 您的 GitHub 帳號為: $username"

# 3. 檢查或建立遠端儲存庫
Write-Output "2. 檢查 GitHub 是否已有 $repoName 專案庫..."
$repoCheck = & $ghPath repo view "$username/$repoName" 2>&1

if ($repoCheck -match "Repository not found") {
    Write-Output "-> 未發現現有專案，正在建立全新 Public 專案並推送..."
    # 一鍵建立、設定 remote 並推送到 main 分支
    & $ghPath repo create $repoName --public --source=. --remote=origin --push
} else {
    Write-Output "-> 發現已存在的專案庫，進行關聯與強推更新..."
    
    # 移除舊 remote (如果有的話)
    & $gitPath remote remove origin 2>$null
    
    # 新增 remote
    $remoteUrl = "https://github.com/$username/$repoName.git"
    & $gitPath remote add origin $remoteUrl
    
    Write-Output "-> 正在上傳代碼到 GitHub main 分支..."
    # 新增所有異動並提交
    & $gitPath add index.html README.md
    & $gitPath commit -m "Auto-update from WMS Deployer" 2>$null
    & $gitPath push -u origin main --force
}

# 4. 啟用並設定 GitHub Pages 靜態網站
Write-Output "3. 正在對 GitHub API 發送請求，為專案啟用 GitHub Pages 服務..."
$pagesApiUrl = "repos/$username/$repoName/pages"
$body = @{
    source = @{
        branch = "main"
        path = "/"
    }
} | ConvertTo-Json

try {
    # 嘗試啟用 Pages (如果尚未啟用)
    $pagesResult = & $ghPath api $pagesApiUrl --method POST --input - <<EOF
{
  "source": {
    "branch": "main",
    "path": "/"
  }
}
EOF
    Write-Output "-> GitHub Pages 啟用指令已成功送出！"
} catch {
    # 如果已經啟用過，此 API 會報錯，忽略即可
    Write-Output "-> GitHub Pages 服務先前已啟動，繼續執行。"
}

$targetUrl = "https://$($username.ToLower()).github.io/$repoName/"
Write-Output ""
Write-Output "=== 🚀 部署大功告成！ ==="
Write-Output "您的 WMS 雲端網址已設定完畢："
Write-Output "👉 $targetUrl"
Write-Output "=========================="
