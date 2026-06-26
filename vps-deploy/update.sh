#!/bin/bash
# ============================================================
#  UPDATE SCRIPT - Pho Tue SoftWare Solutions JSC
#  Cap nhat toan bo scripts tu GitHub
#
#  Cach su dung (1 lenh duy nhat):
#  curl -sSL https://raw.githubusercontent.com/thanhan92-f1/Windows-Genuine-License-Tool/main/vps-deploy/update.sh | sudo bash
#
#  Hoac truyen config:
#  INPUT_DOMAIN=your.com curl -sSL URL/update.sh | sudo bash
# ============================================================

set -e
export DEBIAN_FRONTEND=noninteractive

# Mau sac
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

INSTALL_DIR="/opt/pho-tue-scripts"
REPO_RAW="https://raw.githubusercontent.com/thanhan92-f1/Windows-Genuine-License-Tool/main"
SERVICE_NAME="pho-tue-scripts"

echo ""
echo -e "  ${CYAN}============================================================${NC}"
echo -e "  ${GREEN}MICROSOFT LICENSE TOOL - UPDATE${NC}"
echo -e "  ${CYAN}Pho Tue SoftWare Solutions JSC${NC}"
echo -e "  ${CYAN}============================================================${NC}"
echo ""

# Kiem tra root
if [ "$EUID" -ne 0 ]; then
    echo -e "  ${RED}[LOI] Can chay voi quyen root${NC}"
    echo -e "  ${YELLOW}Chay lai: curl -sSL URL/update.sh | sudo bash${NC}"
    exit 1
fi

# ============================================================
#  KIEM TRA HE THONG
# ============================================================
echo -e "  ${YELLOW}[1/5] Kiem tra he thong...${NC}"

if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "  ${RED}[!] Khong tim thay thu muc $INSTALL_DIR${NC}"
    echo -e "  ${YELLOW}[!] Hay chay setup truoc: curl -sSL URL/bootstrap.sh | sudo bash${NC}"
    exit 1
fi

# Doc cau hinh hien tai tu server.py (neu co)
if [ -f "$INSTALL_DIR/server.py" ]; then
    CURRENT_PORT=$(grep -oP 'PORT = int\(os\.environ\.get\("PORT", \K[0-9]+' "$INSTALL_DIR/server.py" 2>/dev/null || echo "8888")
    # Tim domain tu server.py
    CURRENT_DOMAIN=$(grep -oP 'DOMAIN = os\.environ\.get\("DOMAIN", "\K[^"]+' "$INSTALL_DIR/server.py" 2>/dev/null || echo "")
else
    CURRENT_PORT="8888"
    CURRENT_DOMAIN=""
fi

# Domain tu env hoac hien tai hoac mac dinh
DOMAIN="${INPUT_DOMAIN:-$CURRENT_DOMAIN}"
if [ -z "$DOMAIN" ]; then
    DOMAIN="microsoft-genuine-license.hitechcloud.vn"
fi

echo -e "  ${GREEN}[OK] Thu muc: $INSTALL_DIR${NC}"
echo -e "  ${GREEN}[OK] Domain:  $DOMAIN${NC}"
echo -e "  ${GREEN}[OK] Port:    $CURRENT_PORT${NC}"
echo ""

# ============================================================
#  BACKUP
# ============================================================
echo -e "  ${YELLOW}[2/5] Tao backup...${NC}"

BACKUP_DIR="$INSTALL_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup scripts hien tai
cp -f "$INSTALL_DIR/server.py" "$BACKUP_DIR/" 2>/dev/null || true
cp -f "$INSTALL_DIR/scripts/Microsoft-License-Audit-Tool.ps1" "$BACKUP_DIR/" 2>/dev/null || true
cp -f "$INSTALL_DIR/scripts/Windows_License_Cleanup.ps1" "$BACKUP_DIR/" 2>/dev/null || true
cp -f "$INSTALL_DIR/templates/index.html" "$BACKUP_DIR/" 2>/dev/null || true

echo -e "  ${GREEN}[OK] Backup tai: $BACKUP_DIR${NC}"
echo ""

# ============================================================
#  DOWNLOAD
# ============================================================
echo -e "  ${YELLOW}[3/5] Download scripts moi nhat tu GitHub...${NC}"

# Tao thu muc neu chua co
mkdir -p "$INSTALL_DIR/scripts"
mkdir -p "$INSTALL_DIR/templates"

# Download tat ca scripts
download_file() {
    local url="$1"
    local dest="$2"
    local name=$(basename "$dest")

    if curl -sSL --fail "$url" -o "$dest" 2>/dev/null; then
        echo -e "  ${GREEN}[OK] $name${NC}"
        return 0
    else
        echo -e "  ${RED}[FAIL] $name - khong the tai${NC}"
        return 1
    fi
}

download_file "$REPO_RAW/Microsoft-License-Audit-Tool.ps1" "$INSTALL_DIR/scripts/Microsoft-License-Audit-Tool.ps1"
download_file "$REPO_RAW/Windows_License_Cleanup.ps1" "$INSTALL_DIR/scripts/Windows_License_Cleanup.ps1"
download_file "$REPO_RAW/vps-deploy/server.py" "$INSTALL_DIR/server.py"
download_file "$REPO_RAW/vps-deploy/templates/index.html" "$INSTALL_DIR/templates/index.html"

echo ""

# ============================================================
#  CAP NHAT DOMAIN
# ============================================================
echo -e "  ${YELLOW}[4/5] Cap nhat domain: $DOMAIN${NC}"

# Lay danh sach cac domain mac dinh de thay the
DEFAULT_DOMAINS=(
    "irm-genuine-license-windows.hitechcloud.vn"
    "microsoft-genuine-license.hitechcloud.vn"
)

for DEFAULT in "${DEFAULT_DOMAINS[@]}"; do
    if [ "$DEFAULT" != "$DOMAIN" ]; then
        sed -i "s|$DEFAULT|$DOMAIN|g" "$INSTALL_DIR/scripts/Microsoft-License-Audit-Tool.ps1" 2>/dev/null || true
        sed -i "s|$DEFAULT|$DOMAIN|g" "$INSTALL_DIR/scripts/Windows_License_Cleanup.ps1" 2>/dev/null || true
        sed -i "s|$DEFAULT|$DOMAIN|g" "$INSTALL_DIR/server.py" 2>/dev/null || true
        sed -i "s|$DEFAULT|$DOMAIN|g" "$INSTALL_DIR/templates/index.html" 2>/dev/null || true
    fi
done

echo -e "  ${GREEN}[OK] Da cap nhat domain trong tat ca scripts${NC}"
echo ""

# ============================================================
#  RESTART SERVICE
# ============================================================
echo -e "  ${YELLOW}[5/5] Khoi dong lai service...${NC}"

# Kiem tra service ton tai
if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
    systemctl restart "$SERVICE_NAME"
    sleep 2
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo -e "  ${GREEN}[OK] Service da khoi dong lai${NC}"
    else
        echo -e "  ${RED}[!] Service khong khoi dong duoc. Kiem tra: journalctl -u $SERVICE_NAME -n 20${NC}"
    fi
elif systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
    systemctl start "$SERVICE_NAME"
    sleep 2
    echo -e "  ${GREEN}[OK] Service da khoi dong${NC}"
else
    echo -e "  ${YELLOW}[!] Khong tim thay service. Hay chay bootstrap de tao lai.${NC}"
fi

echo ""

# ============================================================
#  KIEM TRA
# ============================================================
echo -e "  ${CYAN}── Kiem tra ────────────────────────────────────────────${NC}"

# Kiem tra port
if command -v ss &> /dev/null; then
    if ss -tlnp | grep -q ":$CURRENT_PORT"; then
        echo -e "  ${GREEN}[OK] Port $CURRENT_PORT: Dang lang nghe${NC}"
    else
        echo -e "  ${RED}[!] Port $CURRENT_PORT: Khong thay lang nghe${NC}"
    fi
elif command -v netstat &> /dev/null; then
    if netstat -tlnp | grep -q ":$CURRENT_PORT"; then
        echo -e "  ${GREEN}[OK] Port $CURRENT_PORT: Dang lang nghe${NC}"
    else
        echo -e "  ${RED}[!] Port $CURRENT_PORT: Khong thay lang nghe${NC}"
    fi
fi

# Kiem tra service
if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
    echo -e "  ${GREEN}[OK] Service: Running${NC}"
else
    echo -e "  ${RED}[!] Service: Not running${NC}"
fi

# Kiem tra file
if [ -f "$INSTALL_DIR/scripts/Microsoft-License-Audit-Tool.ps1" ]; then
    FILE_SIZE=$(wc -c < "$INSTALL_DIR/scripts/Microsoft-License-Audit-Tool.ps1")
    echo -e "  ${GREEN}[OK] Microsoft-License-Audit-Tool.ps1: ${FILE_SIZE} bytes${NC}"
fi

echo ""

# ============================================================
#  HOAN TAT
# ============================================================
echo -e "  ${CYAN}============================================================${NC}"
echo -e "  ${GREEN}CAP NHAT THANH CONG!${NC}"
echo -e "  ${CYAN}============================================================${NC}"
echo ""
echo -e "  Thu muc:   ${GREEN}$INSTALL_DIR${NC}"
echo -e "  Domain:    ${GREEN}https://$DOMAIN${NC}"
echo -e "  Port:      ${GREEN}$CURRENT_PORT${NC}"
echo -e "  Backup:    ${GREEN}$BACKUP_DIR${NC}"
echo ""
echo -e "  ${CYAN}── Su dung ─────────────────────────────────────────────${NC}"
echo -e "  ${GREEN}irm https://$DOMAIN | iex${NC}"
echo ""
echo -e "  ${CYAN}── Quan ly ─────────────────────────────────────────────${NC}"
echo -e "  systemctl status $SERVICE_NAME    # Xem trang thai"
echo -e "  systemctl restart $SERVICE_NAME   # Khoi dong lai"
echo -e "  journalctl -u $SERVICE_NAME -f    # Xem log"
echo ""

# Xoa backup cu (giu 5 ban gan nhat)
if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR"
    ls -dt backup_* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true
fi
