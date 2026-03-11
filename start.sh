#!/bin/sh
set -e

CONFIG_FILE="/etc/web-core/config.json"
CORE_PORT="${CORE_PORT:-6443}"

# ─── UUID ───
if [ -z "$CORE_UUID" ]; then
  CORE_UUID=$(/usr/local/bin/web-core uuid)
fi

# ─── Key Pair ───
KEY_OUTPUT=$(/usr/local/bin/web-core x25519)
PRIVATE_KEY=$(echo "$KEY_OUTPUT" | grep "Private key:" | awk '{print $3}')
PUBLIC_KEY=$(echo "$KEY_OUTPUT" | grep "Public key:" | awk '{print $3}')

# ─── Short ID ───
SHORT_ID=$(head -c 4 /dev/urandom | od -An -tx1 | tr -d ' \n')

# ─── Replace placeholders ───
sed -i "s|CORE_PORT|$CORE_PORT|g"          "$CONFIG_FILE"
sed -i "s|CORE_UUID|$CORE_UUID|g"          "$CONFIG_FILE"
sed -i "s|CORE_PRIVATE_KEY|$PRIVATE_KEY|g" "$CONFIG_FILE"
sed -i "s|CORE_SHORT_ID|$SHORT_ID|g"       "$CONFIG_FILE"

# ─── Print connection info ───
echo ""
echo "=========================================="
echo "  Connection Info"
echo "=========================================="
echo ""
echo "  Protocol : vless"
echo "  Address  : (use platform assigned domain)"
echo "  Port     : (use platform assigned port for $CORE_PORT)"
echo "  UUID     : $CORE_UUID"
echo "  Flow     : xtls-rprx-vision"
echo "  Security : reality"
echo "  SNI      : www.microsoft.com"
echo "  PublicKey: $PUBLIC_KEY"
echo "  ShortId  : $SHORT_ID"
echo "  Fingerprint: chrome"
echo ""
echo "=========================================="
echo ""

# ─── Start nginx in background ───
nginx &

# ─── Start core service ───
exec /usr/local/bin/web-core run -c "$CONFIG_FILE"
