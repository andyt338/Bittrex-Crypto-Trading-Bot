provider "aws" {
  access_key = "..."
  secret_key = "..."
  region     = "us-west-2"
}

resource "aws_security_group" "bittrex_sg" {
  name        = "bittrex_sg"
  description = "bittrex security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bittrex_instance" {
  associate_public_ip_address = "true"
  ami                = "ami-aa5ebdd2"
  instance_type      = "t2.micro"
  key_name           = "..."
  security_groups    = ["${aws_security_group.bittrex_sg.name}"]
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd24 php70 php70-mysqlnd",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "sudo chown ec2-user /var/www/html",
      "(crontab -l ; echo '0 8 * * * curl http://localhost/index.php') | crontab -",
      "(crontab -l ; echo '') | crontab -"
    ]
    connection {
      type     = "ssh"
      user = "ec2-user"
      private_key = "${file("....pem")}"
      agent = false
    }
  }

  provisioner "file" {
    source      = "./index.php"
    destination = "/var/www/html/index.php"
    connection {
      type     = "ssh"
      user = "ec2-user"
      private_key = "${file("....pem")}"
      agent = false
    }
  }

  tags {
    Name             = "bittrex instance"
  }
}







