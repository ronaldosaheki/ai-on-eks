name                             = "aibrix-on-eks"
enable_aibrix_stack              = true
enable_argocd                    = true
enable_ai_ml_observability_stack = true
region                           = "eu-west-2" # has more p5.48xlarge capacity blocks available
availability_zones_count         = 3           #change to match capacity block

# -------------------------------------------------------------------------------------
# Enable this to NVIDIA K8s DRA Driver with NVIDIA GPU Opeator
#   Check infra/base/terraform/variables.tf for more details
# -------------------------------------------------------------------------------------
# enable_nvidia_dra_driver         = true
enable_nvidia_gpu_operator = true
# -------------------------------------------------------------------------------------
# eks_cluster_version = "1.33"

# -------------------------------------------------------------------------------------
# EKS Addons Configuration
#
# These are the EKS Cluster Addons managed by Terrafrom stack.
# You can enable or disable any addon by setting the value to `true` or `false`.
#
# If you need to add a new addon that isn't listed here:
# 1. Add the addon name to the `enable_cluster_addons` variable in `base/terraform/variables.tf`
# 2. Update the `locals.cluster_addons` logic in `eks.tf` to include any required configuration
#
# -------------------------------------------------------------------------------------

enable_cluster_addons = {
  coredns                         = true
  kube-proxy                      = true
  vpc-cni                         = true
  eks-pod-identity-agent          = true
  aws-ebs-csi-driver              = true
  metrics-server                  = true
  eks-node-monitoring-agent       = false
  amazon-cloudwatch-observability = false
}
