#!/bin/bash
# Cloud-init script

# Ghi file install-core-components.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/install-core-components.sh
${install_script}
EOF
chmod +x /tmp/install-core-components.sh

# Ghi file master-02.sh vào /tmp và cấp quyền
cat <<'EOF' > /tmp/master-02.sh
${master_script}
EOF
chmod +x /tmp/master-02.sh

# Cấp quyền chạy
chmod +x /tmp/*.sh

# Chạy 2 script theo thứ tự
echo "Running install-core-components.sh..."
bash /tmp/install-core-components.sh

echo "Running master-02.sh..."
bash /tmp/master-02.sh
