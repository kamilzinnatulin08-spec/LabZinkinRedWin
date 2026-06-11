#!/bin/bash
# Все проверки для FW-HQ (Задания 2, 8, 9)

echo "=============================================="
echo "FW-HQ - ВСЕ ПРОВЕРКИ"
echo "=============================================="
echo ""

# ========== ЗАДАНИЕ 2: Доступ в интернет ==========
echo "=== ЗАДАНИЕ 2: Доступ в интернет (FW-HQ) ==="
echo ""

# 1. IP Forward
echo ">>> [КОМАНДА] sysctl net.ipv4.ip_forward"
echo "    ВЫВОД: $(sysctl net.ipv4.ip_forward 2>/dev/null)"
echo -n "    РЕЗУЛЬТАТ: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "OK" || echo "FAIL (должно быть 1)"
echo "---"
echo ""

# 2. Статус nftables
echo ">>> [КОМАНДА] systemctl is-active nftables"
echo "    ВЫВОД: $(systemctl is-active nftables 2>/dev/null || echo 'inactive')"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-active nftables 2>/dev/null | grep -q "active" && echo "OK" || echo "FAIL (nftables не запущен)"
echo "---"
echo ""

# 3. Masquerade
echo ">>> [КОМАНДА] nft list ruleset | grep masquerade"
echo "    ВЫВОД:"
nft list ruleset 2>/dev/null | grep "masquerade" || echo "    (правило не найдено)"
echo -n "    РЕЗУЛЬТАТ: "
nft list ruleset 2>/dev/null | grep -q "masquerade" && echo "OK" || echo "FAIL (нет правила masquerade)"
echo "---"
echo ""

# 4. Пинг до 77.88.8.8
echo ">>> [КОМАНДА] ping -c 2 -W 3 77.88.8.8"
echo "    ВЫВОД:"
ping -c 2 -W 3 77.88.8.8 2>&1
echo -n "    РЕЗУЛЬТАТ: "
[ $? -eq 0 ] && echo "OK" || echo "FAIL (нет доступа)"
echo "---"
echo ""

# ========== ЗАДАНИЕ 8: GRE туннель ==========
echo ""
echo "=== ЗАДАНИЕ 8: GRE туннель (FW-HQ) ==="
echo ""

# 5. network-scripts
echo ">>> [КОМАНДА] rpm -q network-scripts"
echo "    ВЫВОД: $(rpm -q network-scripts 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
rpm -q network-scripts &>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 6. ifcfg-tun1
echo ">>> [КОМАНДА] ls -la /etc/sysconfig/network-scripts/ifcfg-tun1"
ls -la /etc/sysconfig/network-scripts/ifcfg-tun1 2>&1
echo -n "    РЕЗУЛЬТАТ: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 7. MY_INNER_IPADDR
echo ">>> [КОМАНДА] grep MY_INNER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
fi
echo -n "    РЕЗУЛЬТАТ: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && grep -q "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 8. MY_OUTER_IPADDR
echo ">>> [КОМАНДА] grep MY_OUTER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "MY_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
fi
echo -n "    РЕЗУЛЬТАТ: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && grep -q "MY_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 9. PEER_OUTER_IPADDR
echo ">>> [КОМАНДА] grep PEER_OUTER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "PEER_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
fi
echo -n "    РЕЗУЛЬТАТ: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && grep -q "PEER_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 10. Состояние tun1
echo ">>> [КОМАНДА] ip a show tun1"
ip a show tun1 2>&1
echo -n "    РЕЗУЛЬТАТ: "
ip a show tun1 2>/dev/null | grep -q "UP" && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 11. Пинг до FW-BR
PEER_IP=$(grep "^PEER_OUTER_IPADDR=" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null | cut -d= -f2 | tr -d '"')
if [ -n "$PEER_IP" ]; then
    echo ">>> [КОМАНДА] ping -c 3 $PEER_IP (FW-BR)"
    ping -c 3 $PEER_IP 2>&1
    echo -n "    РЕЗУЛЬТАТ: "
    [ $? -eq 0 ] && echo "OK" || echo "FAIL"
else
    echo ">>> [КОМАНДА] ping -c 3 <PEER_IP>"
    echo "    ВЫВОД: PEER_OUTER_IPADDR не задан"
    echo "    РЕЗУЛЬТАТ: FAIL"
fi
echo "---"
echo ""

# ========== ЗАДАНИЕ 9: OSPF ==========
echo ""
echo "=== ЗАДАНИЕ 9: OSPF (FRR) - FW-HQ ==="
echo ""

# 12. Установка FRR
echo ">>> [КОМАНДА] rpm -q frr"
echo "    ВЫВОД: $(rpm -q frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
rpm -q frr &>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 13. ospfd в daemons
echo ">>> [КОМАНДА] grep ospfd /etc/frr/daemons"
grep "ospfd" /etc/frr/daemons 2>&1 || echo "    (файл не найден)"
echo -n "    РЕЗУЛЬТАТ: "
grep -q "^ospfd=yes" /etc/frr/daemons 2>/dev/null && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 14. Статус frr
echo ">>> [КОМАНДА] systemctl is-enabled frr"
echo "    ВЫВОД: $(systemctl is-enabled frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-enabled frr 2>/dev/null | grep -q "enabled" && echo "OK" || echo "FAIL"
echo "---"
echo ""

echo ">>> [КОМАНДА] systemctl is-active frr"
echo "    ВЫВОД: $(systemctl is-active frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-active frr 2>/dev/null | grep -q "active" && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 15. OSPF конфигурация
echo ">>> [КОМАНДА] vtysh -c 'show running-config' | grep -A20 'router ospf'"
vtysh -c "show running-config" 2>/dev/null | grep -A20 "router ospf" || echo "    (OSPF не настроен)"
echo -n "    РЕЗУЛЬТАТ: "
vtysh -c "show running-config" 2>/dev/null | grep -q "router ospf" && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 16. OSPF соседи
echo ">>> [КОМАНДА] vtysh -c 'show ip ospf neighbor'"
vtysh -c "show ip ospf neighbor" 2>&1
echo -n "    РЕЗУЛЬТАТ: "
vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -q "Full" && echo "OK" || echo "FAIL"
echo "---"
echo ""

# 17. OSPF маршруты
echo ">>> [КОМАНДА] vtysh -c 'show ip route ospf'"
vtysh -c "show ip route ospf" 2>&1
echo -n "    РЕЗУЛЬТАТ: "
vtysh -c "show ip route ospf" 2>/dev/null | grep -q "^O" && echo "OK" || echo "WARN"
echo "---"
echo ""

echo "=============================================="
echo "ПРОВЕРКА FW-HQ ЗАВЕРШЕНА"
echo "=============================================="
