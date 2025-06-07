#!/bin/bash

echo "#################################"
echo "Init Cluster LB"

#Update hostname on system
sudo hostnamectl set-hostname "load_balancer-1"

#Disable auto-start HAProxy and Keepalived for configuring
sudo systemctl stop haproxy
sudo systemctl disable haproxy

sudo systemctl stop keepalived
sudo systemctl disable keepalived

#Config HAProxy
sudo tee -a /etc/haproxy/haproxy.cfg <<EOF
frontend k8s-api-frontend
    bind *:6443
    mode tcp
    option tcplog
    default_backend k8s-api-backend

backend k8s-api-backend
    mode tcp
    option tcp-check
    balance roundrobin
    default-server inter 10s downinter 5s rise 2 fall 3
    server k8s-master-1 192.168.1.111:6443 check
    server k8s-master-2 192.168.1.112:6443 check
    server k8s-master-3 192.168.1.113:6443 check
EOF

#Config Keepalived
sudo tee -a /etc/keepalived/keepalived.conf <<EOF
global_defs {
   enable_script_security
   script_user root
}

vrrp_script chk_haproxy {
    script "killall -0 haproxy"
    interval 2
    weight -200
}

vrrp_instance VI_1 {
    interface ens33
    state MASTER
    priority 200
    virtual_router_id 51
    advert_int 1

    authentication {
        auth_type PASS
        auth_pass 0402
    }

    virtual_ipaddress {
        192.168.189.100/24
    }

    track_script {
        chk_haproxy
    }
}
EOF


#Activate HAproxy and Keepalived
sudo systemctl enable haproxy
sudo systemctl restart haproxy

sudo systemctl enable keepalived
sudo systemctl restart keepalived