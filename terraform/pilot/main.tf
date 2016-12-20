# -----------------------------------------------------------------------------
#  Input Variables
# -----------------------------------------------------------------------------


variable "system" {
    description = "Name of the system (used to name and tag resources)"
    default = "datadotgov"
}
variable "stack" {
    description = "Name of the system (used to name and tag resources)"
    default = "pilot"
}
variable "branch" {}

variable "aws_region" { default = "us-east-1" }
variable "ami_type" { default = "hardened" }

variable "bastion_key_name" {}
variable "bastion_subnet_id" {}
variable "bastion_security_group_id" {}
variable "bastion_instance_type" {}


# -----------------------------------------------------------------------------
#  Local Variables
# -----------------------------------------------------------------------------

variable "amis" {
    default = {
        us-east-1-hardened = "ami-fce3c696"
        us-east-1-not-hardened = "ami-857f5392"
    }
}

# -----------------------------------------------------------------------------
#  Bastion server
# -----------------------------------------------------------------------------

provider "aws" {
    region  = "${var.aws_region}"
}

# -----------------------------------------------------------------------------
#  Bastion server
# -----------------------------------------------------------------------------
module "bastion" {
    source = "./bastion"
    system = "${var.system}"
    branch = "${var.branch}"
    stack = "${var.stack}"
    ami = "${lookup(var.amis, format("%s-%s", var.aws_region, var.ami_type))}"
    instance_type = "${var.bastion_instance_type}"
    keypair_name = "${var.bastion_key_name}"
    securitygroup_id = "${var.bastion_security_group_id}"
    subnet_id = "${var.bastion_subnet_id}"
}



output "bastion_instance_id" {
    value = "${module.bastion.instance_id}"
}

output "bastion_public_ip" {
    value = "${module.bastion.public_ip}"
}
