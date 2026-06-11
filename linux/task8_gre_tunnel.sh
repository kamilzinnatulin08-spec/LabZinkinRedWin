#!/bin/bash
# Задание 8 - GRE туннель

echo "=== ЗАДАНИЕ 8: GRE туннель ==="

# 1
echo -n "1. network-scripts installed: "
rpm -q network-scripts 2>/dev/null && echo "[OK]" || echo "[FAIL]"
echo -n "   ifcfg-tun1 exists: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && echo "[OK]" || echo "[FAIL]"

# 2
echo "2. Параметры туннеля:"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep -E "MY_INNER|MY_OUTER|PEER_OUTER" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "   [FAIL] параметры не найдены"
fi

# 3
echo -n "3. tun1 status UP: "
ip a show tun1 2>/dev/null | grep -q "UP" && echo "[OK]" || echo "[FAIL]"

# 4-5
echo "4-5. Пинг до соседа: проверьте вручную"
