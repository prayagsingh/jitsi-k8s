#!/bin/bash
#kubectl config use-context your-shard0-kubernet #<< update this >>
kubectl delete -f base/config.yaml
kubectl delete -f shard0/shard-config.yaml
kubectl delete -f base/web-base/jicofo-configmap.yaml
kubectl delete -f base/web-base/web-configmap.yaml
kubectl delete -f base/web-base/web-prosody.yaml
kubectl delete -f base/web-base/service.yaml
kubectl delete -f shard0/jicofo.yaml
# jvb
#kubectl config use-context your-shard0-jvb #<< update this >>
kubectl delete -f base/config.yaml
kubectl delete -f shard0/shard-config.yaml
kubectl delete -f base/jvb-base/server_metrics.yaml
kubectl delete -f base/jvb-base/jvb-configmap.yaml
kubectl delete -f base/jvb-base/jvb-statefullset.yaml
#kubectl delete -f base/jvb-base/service.yaml
kubectl delete -f base/jvb-base/hpa.yml

# remove metacontroller
kubectl delete -f ops/metacontroller/metacontroller-crds-v1.yaml
kubectl delete -f ops/metacontroller/metacontroller-crds-v1beta1.yaml
kubectl delete -f ops/metacontroller/metacontroller-rbac.yaml
kubectl delete -f ops/metacontroller/metacontroller.yaml  
kubectl delete -f ops/metacontroller/service-per-pod-configmap.yaml
kubectl delete -f ops/metacontroller/service-per-pod-deployment.yaml
kubectl delete -f ops/metacontroller/metacontroller-namespace.yaml
