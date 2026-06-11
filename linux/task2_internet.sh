#!/bin/bash
# Задание 2 - Доступ в интернет

echo "=== ЗАДАНИЕ 2: Доступ в интернет ==="

# 1
echo -n "1. ISP hostname: "
[ "$(hostname)" = "isp.tattele.com" ] && echo "[OK]" || echo "[FAIL]"

# 2
echo "2. IP адреса ISP:"
for iface in ens224 ens256; do
    if ip a show $iface 2>/dev/null | grep -q "inet "; then
        echo "   $iface: [OK]"
    else
        echo "   $iface: [FAIL]"
    fi
done

# 3
echo -n "3. IP Forward: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "[OK]" || echo "[FAIL]"

# 4
echo -n "4. nftables active: "
if systemctl is-active nftables 2>/dev/null | grep -q "active"; then
    echo -n "[OK] "
    if nft list ruleset 2>/dev/null | grep -q "masquerade"; then
        echo "masquerade [OK]"
    else
        echo "masquerade [FAIL]"
    fi
else
    echo "[FAIL] (nftables not active)"
fi

# 5
echo "5. Ping 77.88.8.8: ручная проверка с DC-HQ и DC-BR"
