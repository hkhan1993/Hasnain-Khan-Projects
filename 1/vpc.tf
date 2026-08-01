resource "aws_vpc" "MAIN_VPC" {
  cidr_block = var.vpc_cidr
  tags = merge(local.tags, { Name = "MAIN_VPC"
  })


}

resource "aws_internet_gateway" "MAIN_IGW" {
  vpc_id = aws_vpc.MAIN_VPC.id
  tags   = merge(local.tags, { Name = "MAIN_IGW" })

  depends_on = [aws_vpc.MAIN_VPC]

}

resource "aws_subnet" "MAIN_Subnet" {
  count                   = length(var.subnet_cidr)
  vpc_id                  = aws_vpc.MAIN_VPC.id
  cidr_block              = var.subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true

  # Depends on VPC to be created first
  depends_on = [aws_vpc.MAIN_VPC]

  tags = merge(local.tags, { Name = "MAIN_Subnet-${count.index}" })


}

resource "aws_route_table" "MAIN_Route_Table" {
  vpc_id = aws_vpc.MAIN_VPC.id
  tags   = merge(local.tags, { Name = "MAIN_Route_Table" })

  # Depends on VPC to be created first
  depends_on = [aws_vpc.MAIN_VPC]
}


resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.MAIN_Route_Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.MAIN_IGW.id

  depends_on = [aws_route_table.MAIN_Route_Table]

}

resource "aws_route_table_association" "MAIN_Route_Table_Association" {
  count          = length(var.subnet_cidr)
  subnet_id      = aws_subnet.MAIN_Subnet[count.index].id
  route_table_id = aws_route_table.MAIN_Route_Table.id

  depends_on = [aws_route_table.MAIN_Route_Table]
}


