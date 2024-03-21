variable "access_key" {}
variable "secret_key" {}
variable "region" {}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_instance" "wordpress" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
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
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/aws/aws_hosting.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "/home/ubuntu/tf_provisioning/wordpress/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "/home/ubuntu/install.sh"
    ]
  }
  
  provisioner "file" {
    source      = "/home/ubuntu/tf_provisioning/wordpress/docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose up -d",
      "sleep 10"
    ]
  }

}

#resource "aws_instance" "jenkins" {
#  ami           = "ami-07d9b9ddc6cd8dd30"
#  instance_type = "t2.micro"
#  key_name      = "aws_hosting"
#  security_groups = ["launch-wizard-1"]
#
#  // Dodawanie nowego dysku EBS o rozmiarze 8 GiB
#  ebs_block_device {
#    device_name = "/dev/sdf"
#    volume_size = 8
#    volume_type = "gp2"
#    delete_on_termination = true
#  }
#  tags = {
#    Name = "aws_jenkins_tf"
#  }
#}

#resource "aws_instance" "grafana" {
#  ami           = "ami-07d9b9ddc6cd8dd30"
#  instance_type = "t2.micro"
#  key_name      = "aws_hosting"
#  security_groups = ["launch-wizard-1"]
#
#  // Dodawanie nowego dysku EBS o rozmiarze 8 GiB
#  ebs_block_device {
#    device_name = "/dev/sdf"
#    volume_size = 8
#    volume_type = "gp2"
#    delete_on_termination = true
#  }
#  tags = {
#    Name = "aws_grafana_tf"
#  }
#}

output "wordpress_dns" {
  value = aws_instance.wordpress.*.public_dns
}

#output "jenkins_dns" {
#  value = aws_instance.jenkins.*.public_dns
#}

#output "grafana_dns" {
#  value = aws_instance.grafana.*.public_dns
#}

output "wordpress_ssh" {
  value = aws_instance.wordpress.*.public_ip
}

#output "jenkins_ssh" {
#  value = aws_instance.jenkins.*.public_ip
#}

#output "grafana_ssh" {
#  value = aws_instance.grafana.*.public_ip
#}
