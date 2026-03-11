# SelfVPN - Xray VLESS Reality on Zeabur

一键部署到 Zeabur，Shadowrocket 直连。

## 🚀 部署到 Zeabur

### 方法一：GitHub 部署（推荐）

1. 将此项目推送到你的 GitHub 仓库
2. 登录 [Zeabur](https://zeabur.com)
3. 创建新项目 → 选择你的 GitHub 仓库
4. Zeabur 会自动检测 Dockerfile 并构建部署
5. 在「Networking」中开启公网访问，获取分配的 **域名** 和 **端口**

### 方法二：Zeabur CLI

```bash
# 安装 Zeabur CLI
npm i -g @zeabur/cli

# 登录
npx zeabur auth login

# 部署
npx zeabur deploy
```

## 🔑 获取连接参数

部署成功后，在 Zeabur 控制台 → 选择你的服务 → **Logs** 标签页，可以看到：

```
==========================================
  Xray VLESS Reality - Connection Info
==========================================

  Protocol : vless
  UUID     : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
  Flow     : xtls-rprx-vision
  Security : reality
  SNI      : www.microsoft.com
  PublicKey: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ShortId  : xxxxxxxx
  Fingerprint: chrome
```

**Address 和 Port** 从 Zeabur 的 Networking 页面获取。

## 📱 Shadowrocket 配置

打开 Shadowrocket → 右上角 `+` → 手动输入：

| 字段 | 值 |
|---|---|
| 类型 | VLESS |
| 地址 | Zeabur 分配的域名 |
| 端口 | Zeabur 分配的端口 |
| UUID | 日志中的 UUID |
| Flow | xtls-rprx-vision |
| TLS | reality |
| SNI | www.microsoft.com |
| Public Key | 日志中的 PublicKey |
| Short ID | 日志中的 ShortId |
| Fingerprint | chrome |

保存后点击连接即可使用 ✅

## ⚙️ 环境变量（可选）

| 变量 | 说明 | 默认值 |
|---|---|---|
| `PORT` | 监听端口 | 443 |
| `UUID` | 自定义 UUID | 自动生成 |

在 Zeabur 控制台 → 服务 → Variables 中添加。

## 📝 注意事项

- 每次重新部署会重新生成密钥，需要更新 Shadowrocket 配置
- 如果想固定 UUID，在环境变量中设置 `UUID`
- Reality 协议不需要域名和证书
