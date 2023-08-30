terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "spot_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_market_options {
    spot_options {
      max_price = var.instance_max_price
    }
    market_type = "spot"
  }
  instance_type = var.instance_type
  root_block_device {
    volume_size = 12
  }
  key_name      = var.ssh_key_name
  tags = {
    Name = var.instance_name
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
  user_data     = file("mount_ebs_volume.sh")
}

resource "aws_volume_attachment" "llama_data_volume" {
  device_name = "/dev/sdf"
  volume_id   = var.ebs_volume_id
  instance_id = aws_instance.spot_instance.id
}

output "spot_instance_public_ip" {
  description = "Public IP of EC2 spot instance"
  value       = aws_instance.spot_instance.public_ip
}

output "spot_instance_public_dns" {
  description = "Public DNS name of EC2 spot instance"
  value       = aws_instance.spot_instance.public_dns
}
