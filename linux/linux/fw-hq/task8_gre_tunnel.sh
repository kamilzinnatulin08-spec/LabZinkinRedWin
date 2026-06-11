#!/bin/bash
# Задание 8 - GRE туннель (FW-HQ)

echo "=============================================="
echo "ЗАДАНИЕ 8: GRE туннель (FW-HQ)"
echo "=============================================="
echo ""

# 1. Проверка установки network-scripts
echo ">>> [КОМАНДА] rpm -q network-scripts"
echo "    ВЫВОД: $(rpm -q network-scripts 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
rpm -q network-scripts &>/dev/null && echo "OK" || echo "FAIL (network-scripts не установлен)"
echo "---"
echo ""

# 2. Проверка наличия ifcfg-tun1
echo ">>> [КОМАНДА] ls -la /etc/sysconfig/network-scripts/ifcfg-tun1"
ls -la /etc/sysconfig/network-scripts/ifcfg-tun1 2>&1
echo -n "    РЕЗУЛЬТАТ: "
[ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ] && echo "OK" || echo "FAIL (файл ifcfg-tun1 не найден)"
echo "---"
echo ""

# 3. Содержимое ifcfg-tun1
echo ">>> [КОМАНДА] cat /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    cat /etc/sysconfig/network-scripts/ifcfg-tun1
else
    echo "    (файл не найден)"
fi
echo "---"
echo ""

# 4. Проверка MY_INNER_IPADDR
echo ">>> [КОМАНДА] grep MY_INNER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
else
    echo "    (файл не найден)"
fi
echo -n "    РЕЗУЛЬТАТ: "
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep -q "MY_INNER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL (нет MY_INNER_IPADDR)"
else
    echo "FAIL (файл отсутствует)"
fi
echo "---"
echo ""

# 5. Проверка MY_OUTER_IPADDR
echo ">>> [КОМАНДА] grep MY_OUTER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "MY_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
else
    echo "    (файл не найден)"
fi
echo -n "    РЕЗУЛЬТАТ: "
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep -q "MY_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL (нет MY_OUTER_IPADDR)"
else
    echo "FAIL (файл отсутствует)"
fi
echo "---"
echo ""

# 6. Проверка PEER_OUTER_IPADDR
echo ">>> [КОМАНДА] grep PEER_OUTER_IPADDR /etc/sysconfig/network-scripts/ifcfg-tun1"
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep "PEER_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null || echo "    (не найдено)"
else
    echo "    (файл не найден)"
fi
echo -n "    РЕЗУЛЬТАТ: "
if [ -f /etc/sysconfig/network-scripts/ifcfg-tun1 ]; then
    grep -q "PEER_OUTER_IPADDR" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null && echo "OK" || echo "FAIL (нет PEER_OUTER_IPADDR)"
else
    echo "FAIL (файл отсутствует)"
fi
echo "---"
echo ""

# 7. Проверка состояния интерфейса tun1
echo ">>> [КОМАНДА] ip a show tun1"
ip a show tun1 2>&1
echo -n "    РЕЗУЛЬТАТ: "
ip a show tun1 2>/dev/null | grep -q "UP" && echo "OK (интерфейс поднят)" || echo "FAIL (интерфейс не поднят или не существует)"
echo "---"
echo ""

# 8. Пинг до FW-BR
PEER_IP=$(grep "^PEER_OUTER_IPADDR=" /etc/sysconfig/network-scripts/ifcfg-tun1 2>/dev/null | cut -d= -f2 | tr -d '"')
if [ -n "$PEER_IP" ]; then
    echo ">>> [КОМАНДА] ping -c 3 $PEER_IP (FW-BR)"
    ping -c 3 $PEER_IP 2>&1
    echo -n "    РЕЗУЛЬТАТ: "
    [ $? -eq 0 ] && echo "OK (связь с FW-BR есть)" || echo "FAIL (нет связи с FW-BR)"
else
    echo ">>> [КОМАНДА] ping -c 3 <PEER_OUTER_IPADDR>"
    echo "    ВЫВОД: PEER_OUTER_IPADDR не задан в ifcfg-tun1"
    echo "    РЕЗУЛЬТАТ: FAIL (нельзя определить IP FW-BR)"
fi
echo "---"
echo ""

echo "=============================================="
echo "ПРОВЕРКА ЗАВЕРШЕНА"
echo "=============================================="
