#!/bin/bash
# Задание 2 - Доступ в интернет (для FW-HQ)

echo "=============================================="
echo "ЗАДАНИЕ 2: Доступ в интернет (FW-HQ)"
echo "=============================================="
echo ""

# 1. Проверка имени (не критично, но покажем)
echo ">>> [КОМАНДА] hostname"
echo "    ВЫВОД: $(hostname)"
echo "    РЕЗУЛЬТАТ: OK (информационно)"
echo "---"
echo ""

# 2. Проверка IP Forward
echo ">>> [КОМАНДА] sysctl net.ipv4.ip_forward"
echo "    ВЫВОД: $(sysctl net.ipv4.ip_forward 2>/dev/null)"
echo -n "    РЕЗУЛЬТАТ: "
[ "$(sysctl -n net.ipv4.ip_forward 2>/dev/null)" = "1" ] && echo "OK" || echo "FAIL (должно быть 1)"
echo "---"
echo ""

# 3. Проверка статуса nftables
echo ">>> [КОМАНДА] systemctl is-active nftables"
echo "    ВЫВОД: $(systemctl is-active nftables 2>/dev/null || echo 'inactive')"
echo -n "    РЕЗУЛЬТАТ: "
systemctl is-active nftables 2>/dev/null | grep -q "active" && echo "OK (nftables запущен)" || echo "FAIL (nftables не запущен)"
echo "---"
echo ""

# 4. Проверка правила masquerade
echo ">>> [КОМАНДА] nft list ruleset | grep masquerade"
echo "    ВЫВОД:"
nft list ruleset 2>/dev/null | grep "masquerade" || echo "    (правило не найдено)"
echo -n "    РЕЗУЛЬТАТ: "
nft list ruleset 2>/dev/null | grep -q "masquerade" && echo "OK" || echo "FAIL (нет правила masquerade)"
echo "---"
echo ""

# 5. Проверка пинга до 77.88.8.8
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
