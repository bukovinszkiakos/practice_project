output "subnet_ids" {
  description = "Map of all subnet IDs by subnet name."
  value = {
    for name, subnet in aws_subnet.this : name => subnet.id
  }
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value = [
    for name, subnet in aws_subnet.this : subnet.id
    if var.subnets[name].public
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs."
  value = [
    for name, subnet in aws_subnet.this : subnet.id
    if !var.subnets[name].public
  ]
}