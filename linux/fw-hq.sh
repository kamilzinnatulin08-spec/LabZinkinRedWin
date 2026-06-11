#!/bin/bash
# АВТОПРОВЕРКА НА ВМ: FW-HQ

echo "=== ЗАПУСК АВТОПРОВЕРКИ НА ВМ: FW-HQ ==="
echo ""

SCORE=0
TOTAL=11

# Тест 1: Проверка IP Forward
echo "[Тест 1] Проверка включения IP Forward..."
echo "--- [Команда: sysctl net.ipv4.ip_forward] ---"
sysctl net.ipv4.ip_forward 2>/dev/null
if [ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ]; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (должно быть 1)"
fi
echo ""

# Тест 2: Проверка статуса nftables
echo "[Тест 2] Проверка статуса службы nftables..."
echo "--- [Команда: systemctl is-active nftables] ---"
systemctl is-active nftables 2>/dev/null || echo "inactive"
if systemctl is-active nftables 2>/dev/null | grep -q "active"; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (nftables не запущен)"
fi
echo ""

# Тест 3: Проверка правила masquerade
echo "[Тест 3] Проверка наличия правила masquerade..."
echo "--- [Команда: nft list ruleset | grep masquerade] ---"
nft list ruleset 2>/dev/null | grep "masquerade" || echo "правило не найдено"
if nft list ruleset 2>/dev/null | grep -q "masquerade"; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (нет правила masquerade)"
fi
echo ""

# Тест 4: Проверка доступа в интернет
echo "[Тест 4] Проверка доступа в интернет (пинг до 77.88.8.8)..."
echo "--- [Команда: ping -c 2 -W 3 77.88.8.8] ---"
ping -c 2 -W 3 77.88.8.8 2>&1
if [ $? -eq 0 ]; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (нет доступа)"
fi
echo ""

# Тест 5: Проверка установки network-scripts
echo "[Тест 5] Проверка установки пакета network-scripts..."
echo "--- [Команда: rpm -q network-scripts] ---"
rpm -q network-scripts 2>&1
if rpm -q network-scripts &>/dev/null; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (пакет не установлен)"
fi
echo ""

# Тест 6: Проверка наличия ifcfg-tun1
echo "[Тест 6] Проверка наличия конфигурации GRE туннеля..."
echo "--- [Команда: ls /etc/sysconfig/network-scripts/ifcfg-tun1] ---"
ls /etc/sysconfig/network-scripts/ifcfg-tun1 2>&1
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (файл ifcfg-tun1 не найден)"
fi
echo ""

# Тест 7: Проверка параметров GRE
echo "[Тест 7] Проверка параметров GRE туннеля..."
echo "--- [Команда: grep -E 'MY_INNER|MY_OUTER|PEER_OUTER' /etc/sysconfig/network-scripts/ifcfg-tun1] ---"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep -E "MY_INNER|MY_OUTER|PEER_OUTER" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "параметры не найдены"
    if grep -q "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 && \
       grep -q "MY_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 && \
       grep -q "PEER_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1; then
        echo "✓ OK"
        ((SCORE++))
    else
        echo "✗ FAIL (не все параметры заданы)"
    fi
else
    echo "файл не найден"
    echo "✗ FAIL"
fi
echo ""

# Тест 8: Проверка состояния интерфейса tun1
echo "[Тест 8] Проверка состояния интерфейса GRE туннеля..."
echo "--- [Команда: ip a show tun1 | grep -E 'inet|UP'] ---"
ip a show tun1 2>/dev/null | grep -E "inet | UP" || echo "интерфейс не найден"
if ip a show tun1 2>/dev/null | grep -q "UP"; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (интерфейс tun1 не поднят)"
fi
echo ""

# Тест 9: Проверка связи с FW-BR
echo "[Тест 9] Проверка связи с FW-BR через GRE туннель..."
PEER_IP=$(grep "^PEER_OUTER_IPADDR=" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null | cut -d= -f2 | tr -d '"')
if [ -n "$PEER_IP" ]; then
    echo "--- [Команда: ping -c 2 $PEER_IP] ---"
    ping -c 2 $PEER_IP 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ OK"
        ((SCORE++))
    else
        echo "✗ FAIL (нет связи с FW-BR)"
    fi
else
    echo "--- [Команда: ping -c 2 <PEER_IP>] ---"
    echo "PEER_OUTER_IPADDR не задан"
    echo "✗ FAIL"
fi
echo ""

# Тест 10: Проверка установки FRR
echo "[Тест 10] Проверка установки FRR..."
echo "--- [Команда: rpm -q frr] ---"
rpm -q frr 2>&1
if rpm -q frr &>/dev/null; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (frr не установлен)"
fi
echo ""

# Тест 11: Проверка OSPP соседей
echo "[Тест 11] Проверка OSPF соседей (состояние Full)..."
echo "--- [Команда: vtysh -c 'show ip ospf neighbor'] ---"
vtysh -c "show ip ospf neighbor" 2>&1
if vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -q "Full"; then
    echo "✓ OK"
    ((SCORE++))
else
    echo "✗ FAIL (нет соседа в состоянии Full)"
fi
echo ""

# ИТОГ
PERCENT=$((SCORE * 100 / TOTAL))
echo "==========================================="
echo "Score $SCORE/$TOTAL ($PERCENT%)"
echo "Check:"
echo "1. IP Forward Enabled - $( [ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "True" || echo "False" )"
echo "2. nftables Active - $( systemctl is-active nftables 2>/dev/null | grep -q "active" && echo "True" || echo "False" )"
echo "3. Masquerade Rule - $( nft list ruleset 2>/dev/null | grep -q "masquerade" && echo "True" || echo "False" )"
echo "4. Internet Access - $( ping -c 1 -W 2 77.88.8.8 &>/dev/null && echo "True" || echo "False" )"
echo "5. network-scripts Installed - $( rpm -q network-scripts &>/dev/null && echo "True" || echo "False" )"
echo "6. ifcfg-tun1 Exists - $( [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && echo "True" || echo "False" )"
echo "7. GRE Params - $( [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && grep -q "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 && echo "True" || echo "False" )"
echo "8. tun1 Interface UP - $( ip a show tun1 2>/dev/null | grep -q "UP" && echo "True" || echo "False" )"
echo "9. GRE Link to FW-BR - $( [ -n "$PEER_IP" ] && ping -c 1 -W 2 $PEER_IP &>/dev/null && echo "True" || echo "False" )"
echo "10. FRR Installed - $( rpm -q frr &>/dev/null && echo "True" || echo "False" )"
echo "11. OSPF Neighbor Full - $( vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -q "Full" && echo "True" || echo "False" )"
echo "==========================================="
