#!/bin/bash
# Задание 9 - OSPF (FRR) на FW-HQ

echo "=============================================="
echo "ЗАДАНИЕ 9: OSPF маршрутизация (FRR) - FW-HQ"
echo "=============================================="
echo ""

# 1. Проверка установки FRR
echo ">>> [КОМАНДА] rpm -q frr"
echo "    ВЫВОД: $(rpm -q frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
rpm -q frr &>/dev/null && echo "OK" || echo "FAIL (frr не установлен)"
echo "---"
echo ""

# 2. Проверка настройки ospfd в daemons
echo ">>> [КОМАНДА] grep ospfd /etc/frr/daemons"
grep "ospfd" /etc/frr/daemons 2>&1 || echo "    (файл не найден)"
echo -n "    РЕЗУЛЬТАТ: "
grep -q "^ospfd=yes" /etc/frr/daemons 2>/dev/null && echo "OK (ospfd включен)" || echo "FAIL (ospfd должен быть yes)"
echo "---"
echo ""

# 3. Проверка автозагрузки frr
echo ">>> [КОМАНДА] systemctl is-enabled frr"
echo "    ВЫВОД: $(systemctl is-enabled frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-enabled frr 2>/dev/null | grep -q "enabled" && echo "OK" || echo "FAIL (frr не в автозагрузке)"
echo "---"
echo ""

# 4. Проверка статуса frr
echo ">>> [КОМАНДА] systemctl is-active frr"
echo "    ВЫВОД: $(systemctl is-active frr 2>&1)"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-active frr 2>/dev/null | grep -q "active" && echo "OK" || echo "FAIL (frr не запущен)"
echo "---"
echo ""

# 5. Показ OSPF конфигурации
echo ">>> [КОМАНДА] vtysh -c 'show running-config' | grep -A20 'router ospf'"
vtysh -c "show running-config" 2>/dev/null | grep -A20 "router ospf" || echo "    (OSPF не настроен)"
echo -n "    РЕЗУЛЬТАТ: "
vtysh -c "show running-config" 2>/dev/null | grep -q "router ospf" && echo "OK" || echo "FAIL (OSPF не настроен)"
echo "---"
echo ""

# 6. Проверка OSPF соседей (должен быть FW-BR)
echo ">>> [КОМАНДА] vtysh -c 'show ip ospf neighbor'"
vtysh -c "show ip ospf neighbor" 2>&1
echo -n "    РЕЗУЛЬТАТ: "
if vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -q "Full"; then
    echo "OK (есть сосед FW-BR в состоянии Full)"
else
    echo "FAIL (нет соседа в состоянии Full)"
fi
echo "---"
echo ""

# 7. Проверка OSPF маршрутов
echo ">>> [КОМАНДА] vtysh -c 'show ip route ospf'"
vtysh -c "show ip route ospf" 2>&1
echo -n "    РЕЗУЛЬТАТ: "
if vtysh -c "show ip route ospf" 2>/dev/null | grep -q "^O"; then
    echo "OK (есть OSPF маршруты)"
else
    echo "WARN (нет OSPF маршрутов - может быть нормально для stub сети)"
fi
echo "---"
echo ""

echo "=============================================="
echo "ПРОВЕРКА ЗАВЕРШЕНА"
echo "=============================================="
