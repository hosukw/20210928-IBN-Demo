# Auto-generated via terraform

# Variables common to all deployment types
ise_deployment_type: small
ise_base_hostname: ise
ise_username: admin
ise_password: ${ise_password}
ise_domain: ${ise_domain}
pan1_ip: ${ppan_ip}
pan2_ip: ${span_ip}
pan2_local_ip: ${span_ip}
pan1_name: ${ppan_name}
pan2_name: ${span_name}

# Additional variables for medium and large deployments
mnt1_ip: 
mnt2_ip: 
psn1_ip: 
psn2_ip: 
mnt1_local_ip: 
mnt2_local_ip: 
psn1_local_ip: 
psn2_local_ip: 

ise_hostname: ${ppan_ip}
ise_version: 3.0.0  # optional, defaults to 3.0.0
ise_verify: False  # optional, defaults to True
# inventory_hostname: ${ppan_ip}
ad_admin_username: administrator
ad_admin_password: ${ad_admin_password}