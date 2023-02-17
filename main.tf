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
  peer_vpc_id   = "vpc-091fc7198743302ac"
  vpc_id        = aws_vpc.main.id
  auto_accept   = true
}