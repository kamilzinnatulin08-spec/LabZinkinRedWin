#!/bin/bash
# Задание 2 - Доступ в интернет (только для ISP)

echo "=============================================="
echo "ЗАДАНИЕ 2: Доступ в интернет (ISP)"
echo "=============================================="
echo ""

# 1. Проверка имени ISP
echo ">>> [КОМАНДА] hostname"
echo "    ВЫВОД: $(hostname)"
echo -n "    РЕЗУЛЬТАТ: "
[ "$(hostname)" = "isp.tattele.com" ] && echo "OK" || echo "FAIL (должно быть isp.tattele.com)"
echo "---"
echo ""

# 2. Проверка ens224
echo ">>> [КОМАНДА] ip a show ens224 | grep inet"
echo "    ВЫВОД:"
ip a show ens224 2>/dev/null | grep "inet " || echo "    (нет вывода)"
echo -n "    РЕЗУЛЬТАТ: "
ip a show ens224 2>/dev/null | grep -q "inet " && echo "OK" || echo "FAIL (нет IP на ens224)"
echo "---"
echo ""

# 3. Проверка ens256
echo ">>> [КОМАНДА] ip a show ens256 | grep inet"
echo "    ВЫВОД:"
ip a show ens256 2>/dev/null | grep "inet " || echo "    (нет вывода)"
echo -n "    РЕЗУЛЬТАТ: "
ip a show ens256 2>/dev/null | grep -q "inet " && echo "OK" || echo "FAIL (нет IP на ens256)"
echo "---"
echo ""

# 4. Проверка IP Forward
echo ">>> [КОМАНДА] sysctl net.ipv4.ip_forward"
echo "    ВЫВОД: $(sysctl net.ipv4.ip_forward 2>/dev/null)"
echo -n "    РЕЗУЛЬТАТ: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "OK" || echo "FAIL (должно быть 1)"
echo "---"
echo ""

# 5. Проверка статуса nftables
echo ">>> [КОМАНДА] systemctl is-active nftables"
echo "    ВЫВОД: $(systemctl is-active nftables 2>/dev/null || echo 'inactive')"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-active nftables 2>/dev/null | grep -q "active" && echo "OK (nftables запущен)" || echo "FAIL (nftables не запущен)"
echo "---"
echo ""

# 6. Проверка правила masquerade
echo ">>> [КОМАНДА] nft list ruleset | grep masquerade"
echo "    ВЫВОД:"
nft list ruleset 2>/dev/null | grep "masquerade" || echo "    (правило не найдено)"
echo -n "    РЕЗУЛЬТАТ: "
nft list ruleset 2>/dev/null | grep -q "masquerade" && echo "OK" || echo "FAIL (нет правила masquerade)"
echo "---"
echo ""

# 7. Проверка пинга до 77.88.8.8
echo ">>> [КОМАНДА] ping -c 2 -W 3 77.88.8.8"
echo "    ВЫВОД:"
ping -c 2 -W 3 77.88.8.8 2>&1
echo -n "    РЕЗУЛЬТАТ: "
[ $? -eq 0 ] && echo "OK (интернет есть)" || echo "FAIL (нет доступа)"
echo "---"
echo ""

echo "=============================================="
echo "ПРОВЕРКА ЗАВЕРШЕНА"
echo "=============================================="
