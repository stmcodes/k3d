#!/bin/bash

k3d cluster create --config config.yaml
kubectl apply -f https://github.com/knative/operator/releases/download/v0.25.0/operator.yaml
echo 'apiVersion: v1
kind: Namespace
metadata:
  name: knative-serving
---
apiVersion: operator.knative.dev/v1alpha1
kind: KnativeServing
metadata:
  name: knative-serving
  namespace: knative-serving' | kubectl apply -f -
echo 'apiVersion: v1
kind: Namespace
metadata:
  name: knative-eventing
---
apiVersion: operator.knative.dev/v1alpha1
kind: KnativeEventing
metadata:
  name: knative-eventing
  namespace: knative-eventing' | kubectl apply -f -
kubectl apply -l knative.dev/crd-install=true -f https://github.com/knative/net-istio/releases/download/v0.25.0/istio.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/v0.25.0/istio.yaml
kubectl apply -f https://github.com/knative/net-istio/releases/download/v0.25.0/net-istio.yaml
kubectl --namespace istio-system get service istio-ingressgateway
cp -r ~/.kube/config /mnt/c/Users/stefan/.kube/config  
kubectl patch -n knative-serving configmap config-istio --type=json --patch '[{ "op": "remove", "path": "/data/_example" }]'
kubectl patch -n knative-serving configmap config-istio --patch  "data:
  gateway.knative-serving.knative-ingress-gateway: istio-ingressgateway.istio-system.svc.cluster.local
  local-gateway.knative-serving.knative-local-gateway: knative-local-gateway.istio-system.svc.cluster.local"
kubectl patch -n knative-serving configmap config-domain --type=json --patch '[{ "op": "remove", "path": "/data/_example" }]'
kubectl patch -n knative-serving configmap config-domain --patch "data:
  k3d.localhost: ''"
