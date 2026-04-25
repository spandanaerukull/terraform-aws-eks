data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
}

data "aws_ssm_parameter" "eks_node_sg_id" {
  name = "/${var.project}/${var.environment}/eks_node_sg_id"
}

# These data sources are used to retrieve the VPC ID, private subnet IDs, and security group IDs from AWS Systems Manager Parameter Store. The retrieved values are then used in the EKS cluster configuration in main.tf to specify the network settings and security groups for the EKS cluster and its nodes.
# retrive means to get the values from parameter store and use those values in main.tf for vpc id, subnet ids and security group ids for eks cluster and nodes