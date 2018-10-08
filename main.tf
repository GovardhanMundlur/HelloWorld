provider "aws" {
  region = "us-east-1"
}

locals {
  instance_prefix = "${aws_instance.php-web.id}"
  sg_instance_prefix = "${aws_security_group.hello-world-instance.id}"
  sg_elb_prefix = "${aws_security_group.hello-world-lb.id}"
}

# Security group for Instance
resource "aws_security_group" "hello-world-instance" {
  name = "hello-world-instancesg"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    name = "SG-Helloworld-Govardhan"
  }
}

# Security group for Load Balancer
resource "aws_security_group" "hello-world-lb" {
  name = "hello-world-lb"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

# Instance creation for php web page
resource "aws_instance" "php-web" {
  ami = "${var.instance_id}"
  instance_type = "t2.micro"
  key_name = "${var.key-pair}"
  associate_public_ip_address = "true"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${local.sg_instance_prefix}"]
  user_data = "${data.template_file.user_data.rendered}"
  tags {
    Name = "Hello-World-Govardhan"
  }
}

# Classic load Balancer for EC2
resource "aws_elb" "elb-hello-world" {
  subnets = ["${var.subnet_id}"]
  security_groups = ["${local.sg_elb_prefix}"]
  "listener" {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
  "health_check" {
    healthy_threshold = "2"
    unhealthy_threshold = "3"
    timeout = "8"
    target = "HTTP:80/index.php"
    interval = "10"
  }
  tags {
    nam
  }
}

# Attaching Instance to the load balancer
resource "aws_elb_attachment" "test-webpage" {
  elb = "${aws_elb.elb-hello-world.id}"
  instance = "${local.instance_prefix}"
}


