#!/bin/bash
# Задание 9 - OSPF (FRR)

echo "=== ЗАДАНИЕ 9: OSPF (FRR) ==="

# 1
echo -n "1. frr installed: "
rpm -q frr 2>/dev/null && echo "[OK]" || echo "[FAIL]"
echo -n "   ospfd=yes: "
grep "^ospfd=yes" /etc/frr/daemons 2>/dev/null && echo "[OK]" || echo "[FAIL]"

# 2
echo -n "2. frr enabled: "
systemctl is-enabled frr 2>/dev/null | grep -q "enabled" && echo "[OK]" || echo "[FAIL]"
echo -n "   frr active: "
systemctl is-active frr 2>/dev/null | grep -q "active" && echo "[OK]" || echo "[FAIL]"

# 3
echo -n "3. OSPF networks in area 0: "
vtysh -c "show running-config" 2>/dev/null | grep -A10 "router ospf" | grep -q "area 0" && echo "[OK]" || echo "[FAIL]"

# 4
echo -n "4. Config saved: "
echo "   проверьте vtysh -c 'show running-config'"

# 5
echo -n "5. OSPF neighbor Full: "
vtysh -c "show ip ospf neighbor" 2>/dev/null | grep -q "Full" && echo "[OK]" || echo "[FAIL]"
