---
sidebar_label: AIBrix on EKS
---
import CollapsibleContent from '../../../../src/components/CollapsibleContent';


# AIBrix

AIBrix is an open source initiative designed to provide essential building blocks to construct scalable GenAI inference infrastructure. AIBrix delivers a cloud-native solution optimized for deploying, managing, and scaling large language model (LLM) inference, tailored specifically to enterprise needs.
![Alt text](https://aibrix.readthedocs.io/latest/_images/aibrix-architecture-v1.jpeg)

### Features
* LLM Gateway and Routing: Efficiently manage and direct traffic across multiple models and replicas.
* High-Density LoRA Management: Streamlined support for lightweight, low-rank adaptations of models.
* Distributed Inference: Scalable architecture to handle large workloads across multiple nodes.
* LLM App-Tailored Autoscaler: Dynamically scale inference resources based on real-time demand.
* Unified AI Runtime: A versatile sidecar enabling metric standardization, model downloading, and management.
* Heterogeneous-GPU Inference: Cost-effective SLO-driven LLM inference using heterogeneous GPUs.
* GPU Hardware Failure Detection: Proactive detection of GPU hardware issues.


<CollapsibleContent header={<h2><span>Deploying the Solution</span></h2>}>

:::warning
Before deploying this blueprint, it is important to be cognizant of the costs associated with the utilization of GPU Instances.
:::

Please refer to [AI](https://awslabs.github.io/ai-on-eks/docs/infra/aibrix) page for deploying AIBrix models on EKS.

</CollapsibleContent>


### Checking AIBrix Installation

Please run the below commands to check the AIBrix installation

``` bash
kubectl get pods -n aibrix-system
```

Wait till all the pods are in Running status.

#### Running Deepseek-Distill-llama-8b model on AiBrix system

We will now run Deepseek-Distill-llama-8b model using AIBrix on EKS.

Please run the below command.

```bash
kubectl apply -f blueprints/inference/aibrix/deepseek-distill.yaml
```

This will deploy the model on deepseek-aibrix namespace. Wait for few minutes and run

```bash
kubectl get pods -n deepseek-aibrix
```
Wait for the pod to be in running state.

#### Running Qwen3-235B-Instruct model on AiBrix system

We will now run Qwen3-235B-Instruct model using AIBrix on EKS.

It will use a p5.48xlarge reservation, on-demand was disabled to avoid acidentally spinning such an expensive node.

Deploy the model
```bash
kubectl apply -f blueprints/inference/aibrix/qwen3-235b-instruct.yaml
```

Install de servicemonitor to send metrics to prometheus:
```bash
kubectl apply -f blueprints/inference/aibrix/aibrix-servicemonitor.yaml
```

If you get the error bellow, means that argocd didn't finish syncing yet the `ai-ml-obs-ref-arch` app, wait some 5 minutes.
```
error: resource mapping not found for name: "aibrix-vllm-metrics" namespace: "monitoring" from "/Users/ronaldo/github/ronaldosaheki/ai-on-eks/blueprints/inference/aibrix/aibrix-servicemonitor.yaml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
ensure CRDs are installed first
```

And for now we are patching manually the reservation with the Tag (could also be the reservation id as in [Karpenter documentation](https://karpenter.sh/docs/tasks/odcrs/))

Running in kubectl using tags.application=aibrix from the capacity block reservation we created with the same tag.
```bash
kubectl patch ec2nodeclass p5-gpu-karpenter --type='merge' -p='{"spec":{"capacityReservationSelectorTerms":[{"tags":{"application":"aibrix"}}]}}'
```

#### Accessing the models using gateway

Gateway is designed to serve LLM requests and provides features such as dynamic model & LoRA adapter discovery, user configuration for request count & token usage budgeting, streaming and advanced routing strategies such as prefix-cache aware, heterogeneous GPU hardware.
To access the model using Gateway, Please run the below command

```bash
kubectl -n envoy-gateway-system port-forward service/envoy-aibrix-system-aibrix-eg-903790dc 8888:80 &
```

Once the port-forward is running, you can test the model by sending a request to the Gateway.

```bash
ENDPOINT="localhost:8888"
curl -v http://${ENDPOINT}/v1/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "deepseek-r1-distill-llama-8b",
        "prompt": "San Francisco is a",
        "max_tokens": 128,
        "temperature": 0
    }'
```

Or if you deployed Qwen3, you can test with
```bash
ENDPOINT="localhost:8888"
curl -X POST "http://${ENDPOINT}/v1/chat/completions" \
        -H "Content-Type: application/json" \
        --data '{
                "model": "qwen3-235b-instruct",
                "messages": [
                        {
                                "role": "user",
                                "content": "What is the capital of France?"
                        }
                ]
        }'
```

## Monitoring

### Grafana Dashboard

To view the Grafana dashboard to monitor these metrics, follow the steps below:

<details>
<summary>Click to expand details</summary>

**1. Retrieve the Grafana password.**

The password is saved in the EKS Secret. Below kubectl command will show you the secret name.

```bash
kubectl get secrets -n monitoring kube-prometheus-stack-grafana -o json | jq '.data | map_values(@base64d)'
```

**2. Expose the Grafana Service**

Use port-forward to expose the Grafana service.

```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
```

**3. Login to Grafana:**

- Open your web browser and navigate to [http://localhost:3000](http://localhost:3000).
- Login with the username `admin` and the password retrieved from EKS secret

</details>

Access grafana dashboard and import the dashboards copy the contents of the following files:
- blueprints/inference/aibrix/dashboards/NVIDIA DCGM Exporter-1759413594289.json
- blueprints/inference/aibrix/dashboards/vLLM-1759413572998.json

<CollapsibleContent header={<h2><span>Cleanup</span></h2>}>

This script will cleanup the environment using `-target` option to ensure all the resources are deleted in correct order.

```bash
kubectl delete -f blueprints/inference/aibrix/deepseek-distill.yaml
kubectl delete -f blueprints/inference/aibrix/qwen3-235b-instruct.yaml

```

To cleanup the AIBrix deployment, and delete the EKs cluster please run the below command

```bash
cd infra/aibrix/terraform
./cleanup.sh
```

</CollapsibleContent>

:::caution
To avoid unwanted charges to your AWS account, delete all the AWS resources created during this deployment
:::
