#helm upgrade --install --wait \
#   -n gpu-operator --create-namespace \
#   gpu-operator nvidia/gpu-operator \
#   --version=v25.3.0 --set driver.enabled=false --set toolkit.enabled=true \
#   --set toolkit.version=v1.14.6-centos7 \
#          --set operator.defaultRuntime=containerd

helm upgrade --install --wait \
   -n gpu-operator --create-namespace \
   gpu-operator nvidia/gpu-operator \
   --version=v25.3.0 --set driver.enabled=false
