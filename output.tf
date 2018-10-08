output "Instance_ID" {
  value = "${local.sg_instance_prefix}"
}

output "Instance_SG_ID" {
  value = "${local.sg_instance_prefix}"
}

output "ELB_SG_ID" {
  value = "${local.sg_elb_prefix}"
}

output "ELB_DNS" {
  value = "${aws_elb.elb-hello-world.dns_name}"
}