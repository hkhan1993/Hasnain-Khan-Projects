locals {

  raw_pairs = [
    for i, vpc1 in var.vpc_list : [
      for j, vpc2 in var.vpc_list : {
        requester = vpc1
        accepter  = vpc2
      } if j > i
    ]

  ]

  pair_list = flatten(local.raw_pairs)

  peering_map = {
    for pair in local.pair_list : "${substr(pair.requester, 0, 8)}-to-${substr(pair.accepter, 0, 8)}" => pair
  }

  peering_keys = [
    for pair in local.pair_list : "${substr(pair.requester, 4, 8)}-to-${substr(pair.accepter, 4, 8)}"
  ]

  peering_keys_are_unique = length(local.peering_keys) == length(toset(local.peering_keys))


}

check "validate_peering_map_uniqueness" {
  assert {
    condition     = local.peering_keys_are_unique
    error_message = "Key collision detected in peering_map! Slicing past the 'vpc-' prefix produced duplicate keys."
  }
}