#!/bin/bash
# Задание 2 - Доступ в интернет

printf "\nЗАДАНИЕ 2: Доступ в интернет\n"
printf "%-4s | %-35s | %-10s | %s\n" "№" "ПРОВЕРКА" "РЕЗУЛЬТАТ" "ВЫВОД / ПОЯСНЕНИЕ"
printf "%-4s-+-%-35s-+-%-10s-+-%s\n" "----" "-----------------------------------" "----------" "----------------------------------------"

# 1
CMD_OUT=$(hostname)
printf "%-4s | %-35s | %-10s | %s\n" "1" "hostname" "$([ "$CMD_OUT" = "isp.tattele.com" ] && echo "OK" || echo "FAIL")" "$CMD_OUT"

# 2
IP224=$(ip a show ens224 2>/dev/null | grep "inet " | awk '{print $2}')
printf "%-4s | %-35s | %-10s | %s\n" "2" "ip a show ens224 | grep inet" "$([ -n "$IP224" ] && echo "OK" || echo "FAIL")" "${IP224:-IP не найден}"

# 3
IP256=$(ip a show ens256 2>/dev/null | grep "inet " | awk '{print $2}')
printf "%-4s | %-35s | %-10s | %s\n" "3" "ip a show ens256 | grep inet" "$([ -n "$IP256" ] && echo "OK" || echo "FAIL")" "${IP256:-IP не найден}"

# 4
FWD=$(sysctl -n net.ipv4.ip_forward 2>/dev/null)
printf "%-4s | %-35s | %-10s | %s\n" "4" "sysctl net.ipv4.ip_forward" "$([ "$FWD" = "1" ] && echo "OK" || echo "FAIL")" "$FWD"

# 5
NFT_STATUS=$(systemctl is-active nftables 2>/dev/null)
printf "%-4s | %-35s | %-10s | %s\n" "5" "systemctl is-active nftables" "$([ "$NFT_STATUS" = "active" ] && echo "OK" || echo "FAIL")" "$NFT_STATUS"

# 6
MASQ=$(nft list ruleset 2>/dev/null | grep -c "masquerade")
printf "%-4s | %-35s | %-10s | %s\n" "6" "nft list ruleset | grep masquerade" "$([ $MASQ -gt 0 ] && echo "OK" || echo "FAIL")" "найдено правил: $MASQ"

# 7
ping -c 2 -W 2 77.88.8.8 &>/dev/null
printf "%-4s | %-35s | %-10s | %s\n" "7" "ping -c 2 77.88.8.8" "$([ $? -eq 0 ] && echo "OK" || echo "FAIL")" "доступ в интернет"

printf "\n"
