#!/bin/bash
# Задание 2 - Доступ в интернет

echo "=============================================="
echo "ЗАДАНИЕ 2: Доступ в интернет"
echo "=============================================="
echo ""

# 1. Проверка имени ISP
echo ">>> Проверка 1: Имя хоста ISP"
echo -n "   Ожидается: isp.tattele.com | Получено: $(hostname) -> "
if [ "$(hostname)" = "isp.tattele.com" ]; then
    echo "OK"
else
    echo "FAIL"
fi
echo ""

# 2. Проверка IP адресов
echo ">>> Проверка 2: IP адреса на внутренних интерфейсах"
for iface in ens224 ens256; do
    if ip a show $iface 2>/dev/null | grep -q "inet "; then
        ip_addr=$(ip a show $iface 2>/dev/null | grep "inet " | awk '{print $2}')
        echo "   Интерфейс $iface: IP $ip_addr -> OK"
    else
        echo "   Интерфейс $iface: IP не назначен -> FAIL"
    fi
done
echo ""

# 3. Проверка пересылки пакетов
echo ">>> Проверка 3: Включена ли пересылка пакетов (IP Forward)"
current_fwd=$(sysctl -n net.ipv4.ip_forward 2>/dev/null)
echo -n "   Ожидается: 1 | Получено: $current_fwd -> "
[ "$current_fwd" = "1" ] && echo "OK" || echo "FAIL"
echo ""

# 4. Проверка nftables и маскарадинга
echo ">>> Проверка 4: nftables и маскарадинг"
if systemctl is-active nftables 2>/dev/null | grep -q "active"; then
    echo -n "   Статус nftables: ЗАПУЩЕН -> OK, "
    if nft list ruleset 2>/dev/null | grep -q "masquerade"; then
        echo "Маскарадинг: НАСТРОЕН -> OK"
    else
        echo "Маскарадинг: НЕ НАСТРОЕН -> FAIL"
    fi
else
    echo "   Статус nftables: НЕ ЗАПУЩЕН -> FAIL"
fi
echo ""

# 5. Проверка пинга до DNS Яндекса
echo ">>> Проверка 5: Доступ в интернет (пинг до 77.88.8.8)"
echo -n "   Отправка 2 ICMP пакетов... "
if ping -c 2 -W 3 77.88.8.8 &>/dev/null; then
    echo "Пакеты дошли -> OK"
else
    echo "Пакеты не дошли -> FAIL"
fi
echo ""

echo "=============================================="
echo "ПРОВЕРКА ЗАВЕРШЕНА"
echo "=============================================="
