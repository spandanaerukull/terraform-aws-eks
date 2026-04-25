module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # this is module version

  name               = "${var.project}-${var.environment}"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
    metrics-server= {}
  }

  # Optional
  endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_node_security_group = false
  create_security_group = false
  security_group_id = local.eks_control_plane_sg_id
  node_security_group_id = local.eks_node_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    /* blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD" # user name is ec2-user
      instance_types = ["m5.xlarge"]
      
      min_size     = 2
      max_size     = 10
      desired_size = 2
    } */
    # iam_role_additional_policies = {
    #     AmazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" # this is the policy for ebs csi driver to work with eks nodes and acessing them
    #     AmazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy" # this is the policy for efs csi driver to work with eks nodes and acessing them
    #     AmazonEKSLoad = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy" # this is the policy for alb ingress controller to work with eks nodes and acessing them
    # }
    green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD" # user name is ec2-user
      instance_types = ["m5.xlarge"]
      
      min_size     = 2
      max_size     = 10
      desired_size = 2

      iam_role_additional_policies = { # adding the extra policies for ebs, efs and alb load balancer to work with eks nodes and acessing them, why we need this because when we install the csi drivers for ebs and efs and alb ingress controller then those drivers need permissions to access the eks nodes and perform their operations like creating volumes, attaching volumes, creating load balancers etc. so we need to add these policies to the node group iam role to give those permissions to the drivers to work properly with the eks nodes and acessing them
        AmazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEKSLoad = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
      }

      /* taints = {
        upgrade = {
          key = "upgrade"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      } */
    }
  }

  # Top-level `tags` is not supported by this module version; set tags via the module's supported inputs
  # (for example: cluster_tags, node_group_tags, or specific resource tags) or apply tags at resource-level.
}