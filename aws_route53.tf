# Route 53
# DNS forward and reverse is needed to join two or more ISE nodes together.

# resource "aws_route53_zone" "authc" {
#   name = "authc.net"

#   vpc {
#     vpc_id = aws_vpc.main.id
#   }
# }

resource "aws_route53_zone_association" "authc" {
  zone_id = "Z05698913VLHUT470MQK5"
  vpc_id = aws_vpc.main.id
}

resource "aws_route53_record" "ppan" {
  # zone_id = aws_route53_zone.authc.zone_id
  zone_id = "Z05698913VLHUT470MQK5"
  name    = "ppan.authc.net"
  type    = "A"
  ttl     = "300"
  records = [aws_network_interface.ppan-nic.private_ip]
}
resource "aws_route53_record" "span" {
  # zone_id = aws_route53_zone.authc.zone_id
  zone_id = "Z05698913VLHUT470MQK5"
  name    = "span.authc.net"
  type    = "A"
  ttl     = "300"
  records = [aws_network_interface.span-nic.private_ip]
}

# resource "aws_route53_zone" "reverse" {
#   name = "0.10.in-addr.arpa"

#   vpc {
#     vpc_id = aws_vpc.main.id
#   }
# }

resource "aws_route53_zone_association" "reverse" {
  zone_id = "Z05939853HVUGGVVBF2UG"
  vpc_id = aws_vpc.main.id
}

resource "aws_route53_record" "ppan-reverse" {
  # zone_id = aws_route53_zone.reverse.zone_id
  zone_id = "Z05939853HVUGGVVBF2UG"
  name    = join(".", [element(split(".",aws_network_interface.ppan-nic.private_ip),3), element(split(".",aws_network_interface.ppan-nic.private_ip),2)])
  type    = "PTR"
  ttl     = "300"
  records = ["ppan.authc.net"]
}
resource "aws_route53_record" "span-reverse" {
  # zone_id = aws_route53_zone.reverse.zone_id
  zone_id = "Z05939853HVUGGVVBF2UG"
  name    = join(".", [element(split(".",aws_network_interface.span-nic.private_ip),3), element(split(".",aws_network_interface.span-nic.private_ip),2)])
  type    = "PTR"
  ttl     = "300"
  records = ["span.authc.net"]
}

