# Azure Web App Infrastructure

Terraform infrastructure for Azure App Service with SQL geo-replication.

## Architecture
- App Service Linux (P1v3) with auto-scaling
- Azure SQL with geo-replication (East US → West US)  
- VNet (10.0.0.0/16) + NSG + private subnet
- GitHub Actions with OIDC authentication

## Setup

### Prerequisites
- Azure subscription
- Storage account for Terraform state (`tfstatetalha2024`)
- 4 GitHub Secrets configured (see below)

### GitHub Secrets
Settings → Secrets → Actions:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`  
- `AZURE_SUBSCRIPTION_ID`
- `SQL_PASSWORD`

## Decisions & Trade-offs

**1. App Service vs AKS**
- Decision: Chose App Service (PaaS)
- Trade-off: Less control vs faster deployment and easier management

**2. Premium v3 vs Basic**
- Decision: Used P1v3 tier
- Trade-off: Higher cost (~$73/instance) vs required VNet support and auto-scaling

**3. SQL Geo-Replication**
- Decision: Enabled automatic failover to West US
- Trade-off: Double SQL cost (primary + secondary) vs DR capability

**4. OIDC vs Service Principal Secrets**
- Decision: Passwordless GitHub authentication
- Trade-off: More complex initial setup vs no secret rotation/maintenance

**5. Connection Strings in App Settings**
- Decision: Used Terraform variables instead of Key Vault
- Trade-off: Faster implementation vs production-grade secret management
