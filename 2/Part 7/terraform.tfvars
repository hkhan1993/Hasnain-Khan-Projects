default_instance_class    = "db.t3.micro"
default_allocated_storage = 20

primary_subnet_ids = ["subnet-0835b4c5596a6aa04","subnet-0e37ad7a61ba3ff6f"]

replica_subnet_ids = {
        us-west-1 = ["subnet-090bd66f","subnet-03c02959"]
        us-west-2 = ["subnet-f34139d8","subnet-96ae6ecb"]

    }

replicas = {
  us-west-1 = {}

  us-west-2 = {
    instance_class    = "db.r6g.large"
    allocated_storage = 50
  }
}