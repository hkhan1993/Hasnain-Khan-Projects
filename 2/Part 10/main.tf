resource "aws_vpc_peering_connection" "mesh" {
  for_each = local.peering_map

  vpc_id      = each.value.requester
  peer_vpc_id = each.value.accepter

  auto_accept = true

  tags = {
    Name = each.key
    Type = "Full-Mesh-Peering"

  }


}