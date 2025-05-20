variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "private_key_path" {}
variable "ami" {}
variable "insta_type" {}


locals {
  private_key_path = var.private_key_path
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_instance" "wordpress" {
  ami           = var.ami
  instance_type = var.insta_type
  key_name      = "aws_hosting"
  security_groups = ["launch-wizard-1"]

  // Dodawanie nowego dysku EBS o rozmiarze 8 GiB
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 15
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "aws_wordpress_tf"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
  
    connection {
      type        = "ssh"
      user        = "ubuntu"
      #user        = "ec2-user" #user redhat
      private_key = file(local.private_key_path)
      host        = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = <<-EOT
      scp -i /home/ubuntu/tf_provisioning/aws_hosting.pem -o StrictHostKeyChecking=no /home/ubuntu/tf_provisioning/preinstall.sh ubuntu@${self.public_ip}:/home/ubuntu/preinstall.sh &&
      ssh -i /home/ubuntu/tf_provisioning/aws_hosting.pem -o StrictHostKeyChecking=no ubuntu@${self.public_ip} 'chmod +x /home/ubuntu/preinstall.sh && sudo /home/ubuntu/preinstall.sh'
    EOT
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${local.private_key_path} /home/ubuntu/tf_provisioning/wordpress/playbook.yaml" #ansible-galaxy test

  }
}
  #
  #provisioner "file" {
  #  source      = "/home/ubuntu/tf_provisioning/wordpress/docker-compose.yml"
  #  destination = "/home/ubuntu/docker-compose.yml"
  #}
  #
  #provisioner "remote-exec" {
  #  inline = [
  #    "docker-compose up -d",
  #    "sleep 10"
  #  ]
  #}



resource "aws_instance" "jenkins" {
  ami           = var.ami
  instance_type = ver.insta_type
  key_name      = "aws_hosting"
  security_groups = ["launch-wizard-1"]

  // Dodawanie nowego dysku EBS o rozmiarze 8 GiB
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "aws_jenkins_tf"
  }
}

resource "aws_instance" "grafana" {
  ami           = var.ami
  instance_type = var.insta_type
  key_name      = "aws_hosting"
  security_groups = ["launch-wizard-1"]

  // Dodawanie nowego dysku EBS o rozmiarze 8 GiB
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "aws_grafana_tf"
  }
}

output "wordpress_dns" {
  value = aws_instance.wordpress.*.public_dns
}

output "jenkins_dns" {
  value = aws_instance.jenkins.*.public_dns
}

output "grafana_dns" {
  value = aws_instance.grafana.*.public_dns
}

output "wordpress_ssh" {
  value = aws_instance.wordpress.*.public_ip
}

output "jenkins_ssh" {
  value = aws_instance.jenkins.*.public_ip
}

output "grafana_ssh" {
  value = aws_instance.grafana.*.public_ip
}
