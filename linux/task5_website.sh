#!/bin/bash
# Задание 5 - Сайт организации

echo "=== ЗАДАНИЕ 5: Сайт организации ==="

DOMAIN=$(hostname -d 2>/dev/null || echo "HQ.Domain")

# 1
echo -n "1. hostname: "
hostname
echo -n "   DNS server: "
grep "^nameserver" /etc/resolv.conf | head -1

# 2
echo "2. Установленное ПО:"
for pkg in git httpd python3-mod_wsgi; do
    echo -n "   $pkg: "
    rpm -q $pkg 2>/dev/null | grep -q "is not installed" && echo "[FAIL]" || echo "[OK]"
done
echo -n "   flask: "
pip3 show flask 2>/dev/null >/dev/null && echo "[OK]" || echo "[FAIL]"

# 3
echo -n "3. flask.conf exists: "
[ -f /etc/httpd/conf.d/flask.conf ] && echo "[OK]" || echo "[FAIL]"
echo -n "   httpd enabled: "
systemctl is-enabled httpd 2>/dev/null | grep -q "enabled" && echo "[OK]" || echo "[FAIL]"
echo -n "   httpd active: "
systemctl is-active httpd 2>/dev/null | grep -q "active" && echo "[OK]" || echo "[FAIL]"

# 4
echo "4. DNS записи (на DC-HQ запустите PowerShell):"
echo "   Resolve-DnsName web1.$DOMAIN"
echo "   Resolve-DnsName site1.$DOMAIN"

# 5
echo "5. Доступность сайтов с CLI-HQ:"
echo "   curl http://site1.$DOMAIN"
echo "   curl http://site2.$DOMAIN"
