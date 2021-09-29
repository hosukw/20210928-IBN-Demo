# Show IP assignments
output "ppan" {
    value = "https://${aws_network_interface.ppan-nic.private_ip}"
}
output "span" {
    value = "https://${aws_network_interface.span-nic.private_ip}"
}
output "ubuntu-1" {
    value = aws_instance.ubuntu-1.private_ip
}

# Create variables file with proper ISE instance IP addresses for the Ansible playbook under ansible directory
resource "local_file" "ansible" {
    content = templatefile("ansible_var.tpl", {
        ppan_ip = aws_network_interface.ppan-nic.private_ip
        span_ip = aws_network_interface.span-nic.private_ip
        ise_password = "${var.ise_password}"
        ad_admin_password = "${var.ad_admin_password}"
        ise_domain = "${var.ise_domain}"
        ppan_name = "${var.ppan_name}"
        span_name = "${var.span_name}"
    })
    filename = "ansible/vars.yml"
    file_permission = 644
}
