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

}