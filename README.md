# jitsi-k8s
# jitsi kubernetes scalable service with octo

Jitsi Kubernetes deployment with autoscale JVB and OCTO enabled

This setup is tested on **CivoCloud** and cluster used is **K3s v1.20.0-k3s2**

This repo is based on https://github.com/congthang1/jitsi-kubernetes

Thanks for this great work.

# Prequirements

You need 2 kubernetes for each region, 1 for Main Jitsi Web Prosody and 1 for JVBs. If you have 2 regions, 4 kubernertes needed.

This separation make sure JVB autoscale not disturbe the Main Jitis Web as I see on CivoCloud kubernetes. 

JVB nodes need at least 2 cpu (recommended 4).


**NOTE:** I tested it on multi node cluster running on CivoCloud. K8s setup Configuration is `4 CPU 8GB Memory 25 GB`

# Installation

### 0. Search for all places in the code marked as: ``<< update_this >> `` and update them!

## 1. Deploy metacontroller

Apply below command 
  ```
    kubectl apply -f ops/metacontroller/metacontroller-namespace.yaml
    kubectl apply -f ops/metacontroller/metacontroller-crds-v1.yaml
    kubectl apply -f ops/metacontroller/metacontroller-crds-v1beta1.yaml
    kubectl apply -f ops/metacontroller/metacontroller-rbac.yaml
    kubectl apply -f ops/metacontroller/metacontroller.yaml  
    kubectl apply -f ops/metacontroller/service-per-pod-configmap.yaml
    kubectl apply -f ops/metacontroller/service-per-pod-deployment.yaml
  ```

## 2. Deploy Main Jitsi Web server on kubernetes shard 0:

Connect ``kubectl`` to kuberenets shard 0

Create kubernetes namespace 
    
    kubectl create namespace jitsi
    
Go to /base

    kubectl apply -f config.yaml
    
Go to /shard0/web
    
    kubectl apply -f jicofo.yaml
    
    kubectl apply -f web-configmap.yaml
    
Go to /base/web-base
    
    kubectl apply -f web-configmap.yaml
    
    kubectl apply -f jicofo-configmap.yaml
    
    kubectl apply -f service.yaml
    
    kubectl apply -f web-prosody.yaml
    
    
## 3. Deploy the JVBs on kubernetes jvb-shard0

Connect ``kubectl`` to kuberenets jvb-shard0

Make sure udp port open on jvb node: udp 31000-30006 and OCTO udp port 30960 - 30966. with CivoCloud can use firewall with tag start with Kubernetes cluster:.. added by default to apply firewall to all nodes.


Make sure udp port open on jvb node: udp 31000-30006 and OCTO udp port 30960 - 30966. with CivoCloud can use firewall with tag start with k8.. added by default to apply firewall to all nodes.

    
    kubectl create namespace jitsi
    
Go to /base
    
    kubectl apply -f config.yaml
    
Go to /jvb-base
    
    kubectl apply -f server_metrics.yaml
    
    kubectl apply -f jvb-configmap.yaml
    
Go to /shard0/jvb

    kubectl apply -f base/jvb-base/service-per-pod-decoratorcontroller.yaml

    kubectl apply -f jvb-statefullset.yaml

For JVB service, we are using a metacontroller which will  dynamically create a service for jvb based on the number of replicas we are running.     
    
Your Jitsi meet now already available on first region with load balancing JVBs autoscale. Follow next steps to add more region if you have.


## 4. Deploy the second Jitsi Web server region on kubernetes shard1 (optional)


Connect ``kubectl`` to kuberenets shard1

Create kubernetes namespace 
    
    kubectl create namespace jitsi
    
Go to /base
    
    kubectl apply -f config.yaml
    
Go to /shard1/web
    
    kubectl apply -f web-configmap.yaml
    
Go to /base/web-base
    
    kubectl apply -f web-configmap.yaml
    
    kubectl apply -f service.yaml
    
    kubectl apply -f web-prosody.yaml
    
## 5. Deploy the second JVBs on kubernetes jvb-shard1 for second region (if you have step 3)

Connect ``kubectl`` to kuberenets jvb-shard1

Make sure udp port open on jvb node: udp 31000-30006 and OCTO udp port 30960 - 30966
    
    kubectl create namespace jitsi
    
Go to /base
    
    kubectl apply -f config.yaml
    
Go to /jvb-base
    
    kubectl apply -f server_metrics.yaml
    
    kubectl apply -f jvb-configmap.yaml
    
    kubectl apply -f service.yaml
    
Go to /shard1/jvb
    
    kubectl apply -f jvb-statefullset.yaml
    

Your scaleable jitsi with octo will be avaiable at the main domain! 

On Digitalocean point your domain to the load balancer created on kuberenets main web and second region one. 

You can use route53 with regional routing support, this will select best domain for user. Just point 1 domain to both Jitsi Web loadbalancer.

You need to set ssl certificate there too for port 443 on setting of load balancer.

If you have more region just clone ``/shard1`` to ``/shard2``, update the region on 2 places:

* For Jitsi web:

    /shard2/web-configmap.yaml
    
Find this and update

    deploymentInfo: {
        shard: "shard1",
        region: "tor-1",
        userRegion: "tor-1"
    }
* For JVBs:

    /shard2/jvb-statefullset.yaml
Update `OCTO_REGION`

Then redo from step 3.

## Testing
Please refer to this testing using this configuration.
https://community.jitsi.org/t/jitsi-jvb-2-performance-2020-testing/83672
