output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}

output "public_route_table_association_ids" {
  description = "IDs of public route table associations."
  value = [
    for association in aws_route_table_association.public : association.id
  ]
}

output "private_route_table_association_ids" {
  description = "IDs of private route table associations."
  value = [
    for association in aws_route_table_association.private : association.id
  ]
}