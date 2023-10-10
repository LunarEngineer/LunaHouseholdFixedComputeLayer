
output "cluster_join" {
  value = data.local_file.cluster-join.content
  sensitive = true
}
