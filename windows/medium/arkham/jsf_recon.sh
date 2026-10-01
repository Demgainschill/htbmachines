#!/bin/bash

# ============================================================================
# JSF RECONNAISSANCE - Analyze userSubscribe.faces
# ============================================================================

TARGET="http://10.129.228.116:8080/userSubscribe.faces"

echo "=========================================="
echo "JSF RECONNAISSANCE"
echo "=========================================="
echo "[*] Target: $TARGET"
echo ""

echo "[*] Fetching page..."
curl -s "$TARGET" > page.html

echo ""
echo "=== PAGE TITLE ==="
grep -oP '<title>\K[^<]*' page.html

echo ""
echo "=== FORM FIELDS ==="
grep -oP 'name="[^"]*"' page.html | sort -u

echo ""
echo "=== VIEWSTATE ==="
grep -i "viewstate" page.html | head -3

echo ""
echo "=== ALL INPUT FIELDS ==="
grep -oP '<input[^>]*>' page.html | head -10

echo ""
echo "=== FORM NAMES ==="
grep -oP 'id="[^"]*"' page.html | grep -i form | head -5

echo ""
echo "=== BUTTONS/ACTIONS ==="
grep -oP 'id="[^"]*"' page.html | grep -iE "button|submit|action" | head -5

echo ""
echo "[*] Full HTML saved to: page.html"
echo "[+] Done!"
