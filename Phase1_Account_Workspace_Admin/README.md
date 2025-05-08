# Phase 1: Account & Workspace Administration

This phase focuses on setting up your Databricks account and configuring workspaces in AWS. These are fundamental steps that establish the foundation for your Databricks environment.

## Learning Objectives

By the end of this phase, you will be able to:
- Set up a Databricks account with AWS integration
- Configure and deploy Databricks workspaces
- Understand workspace architecture and deployment options
- Configure network settings for workspaces
- Manage workspace settings and parameters

## Prerequisites

- AWS account with administrative access
- Ability to create IAM roles and policies
- Access to create VPC resources
- Basic understanding of networking concepts (CIDR blocks, subnets, etc.)

## Step 1: Databricks Account Setup

1. **Sign up for Databricks on AWS**:
   - Go to [Databricks AWS signup page](https://databricks.com/try-databricks)
   - Select "Get started with Databricks on AWS"
   - Complete the registration process
   - Verify your email address

2. **Account Console Access**:
   - Log in to your Databricks account
   - Familiarize yourself with the account console interface
   - Note the account ID (you'll need this later)

## Step 2: AWS E2 Account Configuration

1. **Create IAM Cross-Account Role**:
   - Use the template in `aws_cross_account_role.json` to create the necessary IAM role
   - This role allows Databricks to provision resources in your AWS account

2. **Configure AWS Account ID in Databricks**:
   - In the Databricks account console, navigate to "AWS Account"
   - Enter your AWS Account ID
   - Configure the IAM role ARN created in the previous step

## Step 3: Network Configuration

1. **VPC Setup**:
   - Create a new VPC or use an existing one
   - Ensure the VPC has the appropriate CIDR block (recommended: /16 or larger)
   - Configure subnets across multiple availability zones (at least 2)
   - Use the `vpc_configuration.json` template for reference

2. **Security Group Configuration**:
   - Create security groups for Databricks components
   - Configure inbound and outbound rules
   - Follow the security group settings in `security_groups.json`

## Step 4: Workspace Deployment

1. **Create a Workspace**:
   - In the Databricks account console, select "Create Workspace"
   - Choose a meaningful workspace name
   - Select the appropriate region (should match your VPC region)
   - Choose the pricing tier (Standard, Premium, or Enterprise)
   - Configure the workspace using the VPC and security groups created earlier

2. **Workspace Configuration Options**:
   - DBFS root location (S3 bucket)
   - Network access settings (Public IP vs. No Public IP)
   - VPC endpoints (if using PrivateLink)
   - Encryption settings

## Step 5: Workspace Management

1. **Access the Workspace**:
   - Once deployment is complete, access your workspace
   - Explore the workspace UI and familiarize yourself with key components
   - Note the differences between the account console and workspace UI

2. **Configure Workspace Settings**:
   - Personal access tokens lifetime
   - Workspace access control settings
   - Default notebook language
   - Artifact allowlist settings

## Best Practices

- Use descriptive naming conventions for workspaces
- Deploy workspaces in regions close to your data sources
- Consider network latency when configuring multi-region deployments
- Document your workspace configurations for future reference
- Use separate workspaces for development, testing, and production
- Configure appropriate CIDR blocks to avoid IP conflicts

## Certification Exam Tips

- Understand the difference between account-level and workspace-level settings
- Know the networking requirements for Databricks deployment
- Be familiar with the workspace deployment process and options
- Understand the IAM role requirements for Databricks-AWS integration
- Know the differences between workspace pricing tiers and their features

## Templates and Resources

This directory contains the following templates:
- `aws_cross_account_role.json`: IAM role template for AWS-Databricks integration
- `vpc_configuration.json`: VPC configuration template
- `security_groups.json`: Security group configuration template
- `workspace_deployment_checklist.md`: Checklist for workspace deployment

## Next Steps

Once you've completed this phase, proceed to [Phase 2: Identity & Access Management](../Phase2_Identity_Access_Management/README.md) to learn how to configure authentication and authorization for your Databricks environment.
