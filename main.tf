# Retrieve the availability zones in the target region
data "aws_availability_zones" "available" {
  state = "available"
}

# Retrieve information about the target region
data "aws_region" "current" {}

# Retrieve information about the user and account
data "aws_caller_identity" "current" {}

locals {
  # Common tags for all resources
  tags = {
    Environment = var.environment
    Project     = "terraform-improved-demo"  # <-- Changed from "terraform-demo"
    Owner       = "devops-team"              # <-- Changed from "infrastructure-team"
    CostCenter  = "cc-5678"                  # <-- Changed from "cc-1234"
    Region      = data.aws_region.current.name
    ManagedBy   = "terraform"
  }
  
  # Common name prefix for resources
  name_prefix = "${var.environment}-tf-"     # <-- Added "tf-" to the prefix
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${local.name_prefix}vpc-${data.aws_region.current.name}" # <-- update value here
    Environment = local.tags.Environment                                    # <-- update value here
    Project     = local.tags.Project                                        # <-- update value here
    Owner       = local.tags.Owner                                          # <-- update value here
    CostCenter  = local.tags.CostCenter                                     # <-- update value here
    Region      = local.tags.Region                                         # <-- update value here
    ManagedBy   = local.tags.ManagedBy                                      # <-- update value here
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.name_prefix}public-subnet-us-east-1a" # <-- update value here
    Environment = local.tags.Environment                         # <-- update value here
    Project     = local.tags.Project                             # <-- update value here
    Owner       = local.tags.Owner                               # <-- update value here
    CostCenter  = local.tags.CostCenter                          # <-- update value here
    Region      = local.tags.Region                              # <-- update value here
    ManagedBy   = local.tags.ManagedBy                           # <-- update value here
    Tier        = "public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.name_prefix}public-subnet-us-east-1b" # <-- update value here
    Environment = local.tags.Environment                         # <-- update value here
    Project     = local.tags.Project                             # <-- update value here
    Owner       = local.tags.Owner                               # <-- update value here
    CostCenter  = local.tags.CostCenter                          # <-- update value here
    Region      = local.tags.Region                              # <-- update value here
    ManagedBy   = local.tags.ManagedBy                           # <-- update value here
    Tier        = "public"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_prefix}private-subnet-us-east-1a" # <-- update value here
    Environment = local.tags.Environment                          # <-- update value here
    Project     = local.tags.Project                              # <-- update value here
    Owner       = local.tags.Owner                                # <-- update value here
    CostCenter  = local.tags.CostCenter                           # <-- update value here
    Region      = local.tags.Region                               # <-- update value here
    ManagedBy   = local.tags.ManagedBy                            # <-- update value here
    Tier        = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_prefix}private-subnet-us-east-1b" # <-- update value here
    Environment = local.tags.Environment                          # <-- update value here
    Project     = local.tags.Project                              # <-- update value here
    Owner       = local.tags.Owner                                # <-- update value here
    CostCenter  = local.tags.CostCenter                           # <-- update value here
    Region      = local.tags.Region                               # <-- update value here
    ManagedBy   = local.tags.ManagedBy                            # <-- update value here
    Tier        = "private"
  }
}

resource "aws_security_group" "web" {
  name        = "${local.name_prefix}web-sg" # <-- update value here
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name_prefix}web-sg" # <-- update value here
    Environment = local.tags.Environment       # <-- update value here
    Project     = local.tags.Project           # <-- update value here
    Owner       = local.tags.Owner             # <-- update value here
    CostCenter  = local.tags.CostCenter        # <-- update value here
    Region      = local.tags.Region            # <-- update value here
    ManagedBy   = local.tags.ManagedBy         # <-- update value here
  }
}