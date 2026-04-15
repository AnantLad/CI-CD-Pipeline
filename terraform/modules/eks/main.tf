# 1. IAM role for the EKS cluster
# 2. The EKS cluster 
#


resource "aws_iam_role" "eks_cluster" {
    name = "${var.environment}-eks-cluster-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "eks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "eks_cluster_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster.name
  
}
resource "aws_eks_cluster" "main" {
  name = "${var.environment}-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
        subnet_ids = var.private_subnet_ids
    }

    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_Policy]
}

resource "aws_iam_role" "nodes" {
  name = "${var.environment}-eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }]
  })
}

resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.nodes.name
}
resource "aws_iam_role_policy_attachment" "nodes_amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.nodes.name
}
resource "aws_iam_role_policy_attachment" "nodes_amazon_ecr_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.nodes.name 
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.environment}-eks-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

    instance_types = ["t3.medium"]

    depends_on = [ 
        aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.nodes_amazon_ecr_read_only
    ]
}