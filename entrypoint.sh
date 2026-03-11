#!/bin/sh
set -e

CONFIG_FILE="/etc/xray/config.json"

# ─── Port ───
PORT="${PORT:-443}"
echo ">>> Port: $PORT"

# ─── UUID ───
if [ -z "$UUID" ]; then
  UUID=$(/usr/local/bin/xray uuid)
fi
echo ">>> UUID: $UUID"

# ─── x25519 Key Pair ───
KEY_OUTPUT=$(/usr/local/bin/xray x25519)
PRIVATE_KEY=$(echo "$KEY_OUTPUT" | grep "Private key:" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEY_OUTPUT" | grep "Public key:" | awk '{print $3}')
echo ">>> Private Key: $PRIVATE_KEY"
echo ">>> Public Key:  $PUBLIC_KEY"

# ─── Short ID (random 8-char hex) ───
SHORT_ID=$(head -c 4 /dev/urandom | od -An -tx1 | tr -d ' \n')
echo ">>> Short ID: $SHORT_ID"

# ─── Replace placeholders in config ───
sed -i "s|XRAY_PORT|$PORT|g"          "$CONFIG_FILE"
sed -i "s|XRAY_UUID|$UUID|g"          "$CONFIG_FILE"
sed -i "s|XRAY_PRIVATE_KEY|$PRIVATE_KEY|g" "$CONFIG_FILE"
sed -i "s|XRAY_SHORT_ID|$SHORT_ID|g"  "$CONFIG_FILE"

# ─── Print connection info ───
echo ""
echo "=========================================="
echo "  Xray VLESS Reality - Connection Info"
echo "=========================================="
echo ""
echo "  Protocol : vless"
echo "  Address  : (use Zeabur assigned domain)"
echo "  Port     : (use Zeabur assigned port)"
echo "  UUID     : $UUID"
echo "  Flow     : xtls-rprx-vision"
echo "  Security : reality"
echo "  SNI      : www.microsoft.com"
echo "  PublicKey: $PUBLIC_KEY"
echo "  ShortId  : $SHORT_ID"
echo "  Fingerprint: chrome"
echo ""
echo "=========================================="
echo "  Copy the above info to Shadowrocket"
echo "=========================================="
echo ""

# ─── Start Xray ───
exec /usr/local/bin/xray run -c "$CONFIG_FILE"
