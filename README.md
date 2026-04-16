# MERN Stack on AWS EKS (Production-Level Deployment)

## Project Overview

This project demonstrates a **production-ready deployment of a MERN (MongoDB, Express, React, Node.js) application** on AWS using modern DevOps practices.

It showcases how to build, deploy, and manage a scalable, secure, and automated cloud-native application using:

* Kubernetes (EKS)
* Terraform (Infrastructure as Code)
* Docker (Containerization)
* GitHub Actions (CI/CD)

---

## Architecture

### High-Level Design

* **VPC** with public & private subnets
* **EKS Cluster** with managed node groups
* **MongoDB** deployed as StatefulSet with persistent storage
* **Frontend** exposed via LoadBalancer
* **Backend** exposed internally via ClusterIP

---

## Tech Stack

* **Cloud:** AWS (EKS, VPC, ECR, IAM, EBS)
* **Containerization:** Docker
* **Orchestration:** Kubernetes
* **IaC:** Terraform
* **CI/CD:** GitHub Actions
* **Database:** MongoDB
* **Backend:** Node.js + Express
* **Frontend:** React + Nginx

---

## Project Structure

```
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── eks/
│   ├── dev.tfvars
│   └── main.tf
│
├── k8s/
│   ├── frontend.yaml
│   ├── backend.yaml
│
├── .github/workflows/
│   ├── infra.yml
│   └── app.yml
│
├── frontend/ # I used Docker Hub images Which i created for my project.
├── backend/  # I also used MongoDB ATLAS for database Connection
└── README.md
```

---

## Infrastructure Setup (Terraform)

### Initialize Terraform

```bash
terraform init
```

### Validate Configuration

```bash
terraform validate
```

### Plan Deployment

```bash
terraform plan -var-file="dev.tfvars"
```

### Apply Changes

```bash
terraform apply -var-file="dev.tfvars"
```

---

## Kubernetes Deployment

### Apply All Resources

```bash
kubectl apply -f k8s/
```

### Check Pods

```bash
kubectl get pods
```

### Check Services

```bash
kubectl get svc
```

---

## CI/CD Pipelines

### Infrastructure Pipeline

* terraform fmt
* terraform validate
* terraform plan
* terraform apply

### Application Pipeline

* Build Docker images
* Push to AWS ECR
* Deploy to EKS using kubectl

---

##  Security Best Practices

* Private subnets for backend & database
* No hardcoded credentials
* Non-root Docker containers
* Remote Terraform state (S3 + DynamoDB locking)

---

##  Features

* Scalable Kubernetes deployment
* Automated CI/CD pipelines
* Persistent MongoDB storage
* Secure networking (VPC)
* Infrastructure as Code

---

## Troubleshooting

### Check Logs

```bash
kubectl logs -l app=backend
```

### Describe Pod

```bash
kubectl describe pod <pod-name>
```

### Common Issues

* CrashLoopBackOff → Check logs & env variables
* Service not accessible → Verify LoadBalancer & security groups
* Image pull error → Check ECR permissions

---

## Future Improvements

* Add monitoring (Prometheus + Grafana)
* Implement logging (ELK stack)
* Add HTTPS with Ingress + Cert Manager
* Use Helm for better deployments

---

## ⭐ If you like this project

Give it a ⭐ on GitHub and connect with me on LinkedIn!
