#!/bin/bash

# deploying metacontroller
kubectl apply -f ops/metacontroller/metacontroller-namespace.yaml
kubectl apply -f ops/metacontroller/metacontroller-crds-v1.yaml
kubectl apply -f ops/metacontroller/metacontroller-crds-v1beta1.yaml
kubectl apply -f ops/metacontroller/metacontroller-rbac.yaml
kubectl apply -f ops/metacontroller/metacontroller.yaml  
kubectl apply -f ops/metacontroller/service-per-pod-configmap.yaml
kubectl apply -f ops/metacontroller/service-per-pod-deployment.yaml

# deploying jitsi
kubectl apply -f base/jitsi-namespace.yaml
kubectl apply -f base/config.yaml
kubectl apply -f shard0/shard-config.yaml
kubectl apply -f base/web-base/jicofo-configmap.yaml
kubectl apply -f base/web-base/web-configmap.yaml
kubectl apply -f base/web-base/web-prosody.yaml
kubectl apply -f base/web-base/service.yaml
kubectl apply -f shard0/jicofo.yaml

# jvb
#kubectl config use-context your-shard0-jvb #<< update this >>
kubectl apply -f base/jvb-base/service-per-pod-decoratorcontroller.yaml
kubectl apply -f base/config.yaml
kubectl apply -f shard0/shard-config.yaml
kubectl apply -f base/jvb-base/server_metrics.yaml
kubectl apply -f base/jvb-base/jvb-configmap.yaml
kubectl apply -f base/jvb-base/jvb-statefullset.yaml
#kubectl apply -f base/jvb-base/service.yaml
kubectl apply -f base/jvb-base/hpa.yml

