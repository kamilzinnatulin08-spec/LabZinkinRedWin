#!/bin/bash
# Задание 2 - Доступ в интернет (полностью автоматическая проверка)

echo "=== ЗАДАНИЕ 2: Доступ в интернет ==="

# 1. ISP hostname
echo -n "1. ISP hostname: "
[ "$(hostname)" = "isp.tattele.com" ] && echo "[OK]" || echo "[FAIL]"

# 2. IP адреса на внутренних интерфейсах
echo "2. IP адреса:"
for iface in ens224 ens256; do
    if ip a show $iface 2>/dev/null | grep -q "inet "; then
        ip_addr=$(ip a show $iface 2>/dev/null | grep "inet " | awk '{print $2}')
        echo "   $iface: $ip_addr [OK]"
    else
        echo "   $iface: [FAIL]"
    fi
done

# 3. Включена пересылка пакетов
echo -n "3. IP Forward: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "[OK]" || echo "[FAIL]"

# 4. nftables и маскарадинг
echo -n "4. nftables: "
if systemctl is-active nftables 2>/dev/null | grep -q "active"; then
    echo -n "[OK] "
    if nft list ruleset 2>/dev/null | grep -q "masquerade"; then
        echo "masquerade [OK]"
    else
        echo "masquerade [FAIL]"
    fi
else
    echo "[FAIL] (не запущен)"
fi

# 5. Пинг до 77.88.8.8 (автоматически с текущего сервера)
echo -n "5. Пинг 77.88.8.8: "
if ping -c 2 -W 3 77.88.8.8 &>/dev/null; then
    echo "[OK]"
else
    echo "[FAIL]"
fi
