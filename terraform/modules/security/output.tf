output "cluster_sg_id" {
  value = aws_security_group.eks-cluster-sg
}
output "node_sg_id" {
  value = aws_security_group.node_group_sg
}