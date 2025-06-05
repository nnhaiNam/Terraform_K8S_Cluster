#!/bin/bash
# Cloud-init script

# Ghi file install-core-components.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/install-core-components.sh
${install_script}
EOF
chmod +x /tmp/install-core-components.sh

# Ghi file master-01.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/master-01.sh
${master_script}
EOF
chmod +x /tmp/master-01.sh

# Cấp quyền chạy
chmod +x /tmp/*.sh

# Chạy 2 script theo thứ tự
echo "Running install-core-components.sh..."
bash /tmp/install-core-components.sh

echo "Running master-01.sh..."
bash /tmp/master-01.sh
