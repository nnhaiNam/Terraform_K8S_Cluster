#!/bin/bash
# Cloud-init script

# Ghi file install-core-components.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/install-core-components-load_balancer.sh
${install_script}
EOF
chmod +x /tmp/install-core-components-load_balancer.sh

# Ghi file master-01.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/load_balancer-01.sh
${master_script}
EOF
chmod +x /tmp/load_balancer-01.sh

# Cấp quyền chạy
chmod +x /tmp/*.sh

# Chạy 2 script theo thứ tự
echo "Running install-core-components-load_balancer.sh..."
bash /tmp/install-core-components-load_balancer.sh

echo "Running load_balancer-01.sh..."
bash /tmp/load_balancer-01.sh
