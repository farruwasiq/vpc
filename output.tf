output "vpc-id" {
    value = aws_vpc.main.id
  
}
output "public-subnets" {
    value = aws_subnet.public.*.id
  
}
output "private-subnets" {
    value = aws_subnet.private.*.id
  
}
output "nat-ip" {
    value = aws_eip.elip.private_ip
  
}