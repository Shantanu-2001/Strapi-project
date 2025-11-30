terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH and Strapi HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Strapi HTTP port"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapi-sg"
  }
}

resource "aws_instance" "strapi" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name               = var.ssh_key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = <<-EOT
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1

    apt-get update -y
    apt-get install -y docker.io docker-compose

    systemctl enable docker
    systemctl start docker

    # Clean any previous data
    rm -rf /opt/strapi
    mkdir -p /opt/strapi
    cd /opt/strapi

    # Simple Strapi with SQLite
    cat <<EOF > docker-compose.yml
    version: "3.8"

    services:
      strapi:
        image: strapi/strapi:latest
        restart: always
        environment:
          NODE_ENV: production
          DATABASE_CLIENT: sqlite
          DATABASE_FILENAME: ./data/data.db
          APP_KEYS: someAppKey1,someAppKey2
          API_TOKEN_SALT: someApiTokenSalt
          ADMIN_JWT_SECRET: someAdminJwtSecret
          JWT_SECRET: someJwtSecret
        volumes:
          - ./app:/srv/app
          - ./data:/srv/app/data
        ports:
          - "1337:1337"

    volumes:
      # named, but local, just for clarity
      strapi_data:
    EOF

    docker-compose up -d

    # Wait for Strapi container to be ready
    STRAPI_CONTAINER=""
    for i in {1..30}; do
      STRAPI_CONTAINER=$(docker ps --filter "name=strapi_strapi_1" --format "{{.ID}}")
      if [ ! -z "$STRAPI_CONTAINER" ]; then
        break
      fi
      sleep 5
    done

    # Give Strapi some extra time to boot
    sleep 40

    # Auto-create admin user (if not already exists)
    docker exec strapi_strapi_1 sh -c "yarn strapi admin:create-user \
      --firstname=Shantanu \
      --lastname=Rana \
      --email=pradipshantanu@gmail.com \
      --password=Shantanu@2001" || true

  EOT

  tags = {
    Name = "strapi-ec2"
  }
}

