# Multi-Cloud Terraform Foundation

Target architecture for AWS ECS/Fargate and Azure Container Apps.

## Current scope

Layer 0 — remote Terraform state bootstrap for AWS and Azure.

## Structure

- `bootstrap/aws` — AWS state infrastructure bootstrap
- `bootstrap/azure` — Azure state infrastructure bootstrap
- `modules/aws` — AWS reusable modules (future)
- `modules/azure` — Azure reusable modules (future)
- `environments/aws/dev` — AWS DEV environment (future)
- `environments/azure/dev` — Azure DEV environment (future)

The bootstrap state infrastructure is intentionally separated from the main environment state.

## Next layers

1. Terraform foundation
2. Identity and access
3. Networking
4. Container registry
5. ECS/Fargate and Azure Container Apps
6. Ingress/load balancing
7. Secrets
8. Observability
9. Autoscaling
10. Security hardening
11. CI/CD
