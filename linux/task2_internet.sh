#!/bin/bash
# Задание 2 - Доступ в интернет

echo "=============================================="
echo "ЗАДАНИЕ 2: Доступ в интернет"
echo "=============================================="
echo ""

# 1. Проверка имени ISP
echo ">>> [Команда] hostname"
echo -n "    Вывод: "
hostname
echo -n "    Результат: "
[ "$(hostname)" = "isp.tattele.com" ] && echo "OK" || echo "FAIL (должно быть isp.tattele.com)"
echo ""

# 2. Проверка IP на ens224
echo ">>> [Команда] ip a show ens224"
ip a show ens224 2>/dev/null | grep "inet " || echo "    Интерфейс ens224 не найден или нет IP"
echo -n "    Результат: "
ip a show ens224 2>/dev/null | grep -q "inet " && echo "OK" || echo "FAIL (нет IP на ens224)"
echo ""

# 3. Проверка IP на ens256
echo ">>> [Команда] ip a show ens256"
ip a show ens256 2>/dev/null | grep "inet " || echo "    Интерфейс ens256 не найден или нет IP"
echo -n "    Результат: "
ip a show ens256 2>/dev/null | grep -q "inet " && echo "OK" || echo "FAIL (нет IP на ens256)"
echo ""

# 4. Проверка IP Forward
echo ">>> [Команда] sysctl net.ipv4.ip_forward"
sysctl net.ipv4.ip_forward
echo -n "    Результат: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "OK" || echo "FAIL (должно быть 1)"
echo ""

# 5. Проверка статуса nftables
echo ">>> [Команда] systemctl is-active nftables"
systemctl is-active nftables 2>/dev/null || echo "inactive"
echo -n "    Результат: "
systemctl is-active nftables 2>/dev/null | grep -q "active" && echo "OK (nftables запущен)" || echo "FAIL (nftables не запущен)"
echo ""

# 6. Проверка правила masquerade
echo ">>> [Команда] nft list ruleset | grep masquerade"
nft list ruleset 2>/dev/null | grep "masquerade" || echo "    Правило masquerade не найдено"
echo -n "    Результат: "
nft list ruleset 2>/dev/null | grep -q "masquerade" && echo "OK" || echo "FAIL (нет masquerade)"
echo ""

# 7. Проверка пинга до 77.88.8.8
echo ">>> [Команда] ping -c 2 -W 3 77.88.8.8"
ping -c 2 -W 3 77.88.8.8 2>&1
echo -n "    Результат: "
[ $? -eq 0 ] && echo "OK (интернет есть)" || echo "FAIL (нет доступа к 77.88.8.8)"
echo ""

echo "=============================================="
echo "ПРОВЕРКА ЗАВЕРШЕНА"
echo "=============================================="
