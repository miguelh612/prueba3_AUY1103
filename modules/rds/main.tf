resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "main_db_subnet_group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Grupo de subredes RDS"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "postgres-rds"
  allocated_storage      = 20
  db_name                = "postgresdb"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.sg_backend_id]
  publicly_accessible    = true
  engine                 = "postgres"
  engine_version         = "16.11"
  parameter_group_name   = "default.postgres16"
  instance_class         = "db.t3.micro"
  username               = "duoc_admin"
  password               = "contrasenasegura.2025"
  skip_final_snapshot    = true
  multi_az               = true
}

resource "aws_db_instance" "mysql" {
  identifier             = "mysql-rds"
  allocated_storage      = 20
  db_name                = "mysqldb"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.sg_backend_id]
  publicly_accessible    = true
  engine                 = "mysql"
  engine_version         = "8.0"
  parameter_group_name   = "default.mysql8.0"
  instance_class         = "db.t3.micro"
  username               = "duoc_admin"
  password               = "contrasenasegura.2025"
  skip_final_snapshot    = true
  multi_az               = true
}