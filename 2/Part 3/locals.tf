locals {

    region = "us-east-1"
    team_a_port = [443, 8080]
    team_b_port = [8080, 9000]

    team_c_port = [22, 80]
    team_d_port = [80, 443]

    deduplicated_ports_1 = distinct(concat(local.team_a_port, local.team_b_port))
    deduplicated_ports_2 = toset(concat(local.team_c_port, local.team_d_port))

}

