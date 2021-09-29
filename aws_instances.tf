# Bring up ISE interfaces
resource "aws_network_interface" "ppan-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  # private_ips     = ["10.0.1.21"]
  security_groups = [aws_security_group.ise-demo.id]
}
resource "aws_network_interface" "span-nic" {
  subnet_id       = aws_subnet.subnet-2.id
  # private_ips     = ["10.0.2.21"]
  security_groups = [aws_security_group.ise-demo.id]
}

#Bring up ISE instance
resource "aws_instance" "ppan" {
  ami           = "ami-0cbed48cc9df4f880"
  instance_type = "c5.4xlarge"
  key_name = "howon-cloud-us-east-1"
  network_interface {
   network_interface_id = aws_network_interface.ppan-nic.id
   device_index         = 0
  }
  tags = {
    Name = "ppan"
  }
  ebs_block_device {
    volume_size = 300
    device_name = "/dev/sda1"
  }
  lifecycle {
   ignore_changes = [root_block_device,ebs_block_device]
  }
  user_data = <<EOF
  hostname=ppan
  primarynameserver=10.0.0.2
  dnsdomain=authc.net
  ntpserver=time.nist.gov
  timezone=CST6CDT
  username=admin
  password=default1A
  ersapi=yes
  openapi=yes
  pxGrid=no
  pxgrid_cloud=no
  EOF
}

resource "aws_instance" "span" {
  ami           = "ami-0cbed48cc9df4f880"
  instance_type = "c5.4xlarge"
  key_name = "howon-cloud-us-east-1"
  network_interface {
   network_interface_id = aws_network_interface.span-nic.id
   device_index         = 0
  }
  tags = {
    Name = "span"
  }
  ebs_block_device {
    volume_size = 300
    device_name = "/dev/sda1"
  }
  lifecycle {
    ignore_changes = [root_block_device,ebs_block_device]
  }
  user_data = <<EOF
  hostname=span
  primarynameserver=10.0.0.2
  dnsdomain=authc.net
  ntpserver=time.nist.gov
  timezone=CST6CDT
  username=admin
  password=default1A
  ersapi=yes
  openapi=yes
  pxGrid=no
  pxgrid_cloud=no
  EOF
}



resource "aws_instance" "ubuntu-1" {
 ami           = "ami-09e67e426f25ce0d7"
 instance_type = "t2.micro"
 key_name = "howon-cloud-us-east-1"
 vpc_security_group_ids = [aws_security_group.ise-demo.id]
 subnet_id = aws_subnet.subnet-1.id
#  private_ips     = ["10.0.1.23"]
 tags = {
   Name = "ubuntu-1"
 }
 ebs_block_device {
   volume_size = 10
   device_name = "/dev/sda1"
 }
 lifecycle {
   ignore_changes = [root_block_device,ebs_block_device]
 }
}
