
resource "aws_db_subnet_group" "primary" {
  name       = "primary-db-subnet-group"
  subnet_ids = var.primary_subnet_ids
  tags = {
    Name = "Primary DB Subnet Group"
  }
}

resource "aws_db_instance" "primary" {
  identifier           = "primary-db-instance"
  instance_class       = var.default_instance_class
  allocated_storage    = var.default_allocated_storage
  engine               = "postgres"
  engine_version       = "13"
  username             = "dbadmin"
  password             = "password"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  backup_retention_period = 1

  db_subnet_group_name = aws_db_subnet_group.primary.name

}

resource "aws_db_subnet_group" "replica_us_west_1" {
  provider = aws.us-west-1
  name       = "replica-db-subnet-group-us-west-1"
  subnet_ids = var.replica_subnet_ids["us-west-1"]
  tags = {
    Name = "Replica DB Subnet Group us-west-1"
  }
}

resource "aws_db_instance" "replica_us_west_1" {
  provider = aws.us-west-1

  identifier           = "replica-db-instance-us-west-1"
  instance_class       = coalesce(var.replicas["us-west-1"].instance_class, var.default_instance_class)
  allocated_storage    = coalesce(var.replicas["us-west-1"].allocated_storage, var.default_allocated_storage)
  engine               = aws_db_instance.primary.engine
  engine_version       = aws_db_instance.primary.engine_version
  parameter_group_name = aws_db_instance.primary.parameter_group_name
  replicate_source_db  = aws_db_instance.primary.arn
  skip_final_snapshot  = true
  
  db_subnet_group_name = aws_db_subnet_group.replica_us_west_1.name

}

resource "aws_db_subnet_group" "replica_us_west_2" {
  provider = aws.us-west-2
  name       = "replica-db-subnet-group-us-west-2"
  subnet_ids = var.replica_subnet_ids["us-west-2"]
  tags = {
    Name = "Replica DB Subnet Group us-west-2"
  }
}

resource "aws_db_instance" "replica_us_west_2" {
  provider = aws.us-west-2

  identifier           = "replica-db-instance-us-west-2"
  instance_class       = coalesce(var.replicas["us-west-2"].instance_class, var.default_instance_class)
  allocated_storage    = coalesce(var.replicas["us-west-2"].allocated_storage, var.default_allocated_storage)
  engine               = aws_db_instance.primary.engine
  engine_version       = aws_db_instance.primary.engine_version
  parameter_group_name = aws_db_instance.primary.parameter_group_name
  replicate_source_db  = aws_db_instance.primary.arn
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.replica_us_west_2.name

}
