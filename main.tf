resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(local.common_tags,
    { Name = "${var.env}-vpc"} )
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  count = length(var.subnet_cidr)
  cidr_block = var.subnet_cidr[count.index]

  tags = merge(local.common_tags,
    { Name = "${var.env}-subnet-${count.index+1}"} )

}

resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = var.default_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
  tags = merge(local.common_tags,
    { Name = "${var.env}-peering"} )
}

resource "aws_route" "default" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
resource "aws_route" "default-vpc" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}