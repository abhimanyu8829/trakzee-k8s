# Trakzee Kubernetes Migration - Proof of Concept

## Overview

This project demonstrates migrating a GPS tracking platform from AWS EC2 to Kubernetes. It shows how a containerized Trakzee stack can run on Kubernetes with shared state in Redis and MySQL, plus scalable web, application, and GPS service tiers.

## Architecture Diagram

```
Internet
   |
Ingress
   |
+--------------------+
|                    |
|   Nginx (3 Pods)   |
|                    |
+--+-------------+--+
   |             |
   |             |
Shared Redis   Shared MySQL
   |             |
   +-------------+
        |   |
   +----+   +----+
   |             |
Tomcat (3 Pods)  ComServer (2 Pods)
   |             |
   +-------------+
   |             |
All pods connect to the same Redis and MySQL
```

## Components

- 🚪 **Ingress** - Load balancer and entry point
- 🌍 **Nginx** - Web server, 3 replicas
- ⚡ **Redis** - Cache store, 1 replica
- 🐬 **MySQL** - Database, 1 replica
- ☕ **Tomcat** - Java application server, 3 replicas
- 📡 **ComServer** - GPS service handler, 2 replicas

## How It Works

- Service discovery is handled through Kubernetes DNS names for each service.
- All pods share the same Redis and MySQL backends, ensuring consistent cached and persistent state.
- Horizontal Pod Autoscaling (HPA) allows workloads to scale automatically based on resource usage.
- The design avoids direct pod-to-pod communication; each component uses service endpoints for backend access.

## Test Results

- ✅ Redis shared across pods
- ✅ Auto-scaling works
- ✅ New pods connect to existing Redis

## Quick Start Commands

```bash
kubectl apply -f configmap.yaml
kubectl apply -f mysql.yaml
kubectl apply -f redis.yaml
kubectl apply -f nginx.yaml
kubectl apply -f tomcat-deployment.yaml
kubectl apply -f comserver.yaml
kubectl apply -f ingress.yaml
kubectl apply -f hpa.yaml
```

## File Structure

- `configmap.yaml` - Configuration data for the application environment
- `mysql.yaml` - MySQL deployment and service definitions
- `redis.yaml` - Redis deployment and service definitions
- `nginx.yaml` - Nginx deployment and service definitions
- `tomcat-deployment.yaml` - Tomcat deployment and service definitions
- `comserver.yaml` - ComServer deployment and service definitions
- `ingress.yaml` - Ingress resource for external routing
- `hpa.yaml` - Horizontal Pod Autoscaler configuration
- `working-proof.sh` - Proof-of-concept helper or validation script
- `str full arch.png` - Architecture diagram image asset

## Conclusion

This proof of concept establishes a production-ready architecture for AWS EKS. The setup is designed for scalability, shared backend persistence, and modern Kubernetes service discovery.
