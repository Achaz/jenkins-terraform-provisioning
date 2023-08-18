data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]

}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.jenkins-sg.name]
  key_name        = "james-devops-key"
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install epel -y",
      "sudo yum update -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key",
      "yum upgrade -y",
      "sudo dnf install java-11-amazon-corretto -y",
      "sudo yum install jenkins -y",
      "sudo service jenkins start",
      "sudo chkconfig --add jenkins",
      "sudo yum update -y",
      "sudo yum install docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user",
      "sudo usermod -a -G docker jenkins"
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("D:\\devops\\james-devops-key.pem")
  }
  tags = {
    "Name" = "Jenkins"
  }
}