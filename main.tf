provider "aws" {
  region  = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "${var.name}"
  }
}

# internet gateway
resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"

  tags = {
    Name = "${var.name}"
  }
}

# load the init template
data "template_file" "app_init" {
   template = "${file("./scripts/app/init.sh.tpl")}"
   vars = {
      db_host = "mongodb://${module.db.private_ip}:27017/posts"
   }
}
module "app" {
  source ="./modules/app_tier"
  name ="${var.name}"
  ig_id  = "${aws_internet_gateway.app.id}"
  vpc_id = "${aws_vpc.app.id}"
  app_ami_id = "${var.app_ami_id}"
  user_data = "${data.template_file.app_init.rendered}"
}

module "db" {
  source ="./modules/db_tier"
  name ="${var.name}"
  vpc_id = "${aws_vpc.app.id}"
  db_ami_id = "${var.db_ami_id}"
  user_data = "${data.template_file.app_init.rendered}"
  security_group_id = "${module.app.security_group_id}"
  private_ip = "${module.db.private_ip}"
}
