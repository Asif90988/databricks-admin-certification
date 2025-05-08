# Databricks Workspace Deployment Checklist

Use this checklist to ensure you've completed all the necessary steps for deploying a Databricks workspace in AWS.

## Pre-Deployment

- [ ] Databricks account created and verified
- [ ] AWS account with administrative access available
- [ ] Required AWS permissions granted to your user/role
- [ ] Decided on workspace region (consider data locality and compliance)
- [ ] Determined workspace tier (Standard, Premium, Enterprise)
- [ ] Identified network requirements (CIDR blocks, subnets, etc.)
- [ ] Planned for encryption requirements (BYOK vs. Databricks-managed)

## AWS Configuration

- [ ] Created cross-account IAM role for Databricks
- [ ] Configured trust relationship with Databricks account
- [ ] Added necessary IAM policies to the role
- [ ] Verified role ARN is correctly formatted
- [ ] Created or identified VPC for Databricks deployment
- [ ] Configured subnets across multiple availability zones
- [ ] Set up route tables and internet gateway
- [ ] Created security groups with appropriate rules
- [ ] (Optional) Set up VPC endpoints for PrivateLink
- [ ] (Optional) Configured NAT gateway for private subnets

## Databricks Account Configuration

- [ ] Added AWS account ID to Databricks account console
- [ ] Configured cross-account IAM role ARN
- [ ] Verified AWS account connection status
- [ ] Set up account-level administrators
- [ ] Configured account-level settings

## Workspace Deployment

- [ ] Selected appropriate AWS region
- [ ] Provided descriptive workspace name
- [ ] Selected appropriate pricing tier
- [ ] Configured network settings (VPC, subnets, security groups)
- [ ] Set up DBFS root location (S3 bucket)
- [ ] Configured encryption settings
- [ ] Reviewed and confirmed deployment settings
- [ ] Initiated workspace deployment
- [ ] Monitored deployment progress

## Post-Deployment Verification

- [ ] Verified workspace deployment completed successfully
- [ ] Accessed workspace URL
- [ ] Logged in to workspace
- [ ] Verified workspace settings
- [ ] Configured workspace-level settings
- [ ] Set up initial users and groups
- [ ] Tested basic functionality (notebook creation, cluster deployment)
- [ ] Documented workspace configuration

## Common Issues and Troubleshooting

- **Deployment Fails with IAM Role Error**
  - Verify the IAM role ARN is correct
  - Check that the trust relationship is properly configured
  - Ensure the role has the necessary permissions

- **Network Configuration Issues**
  - Verify CIDR blocks don't overlap with existing networks
  - Ensure subnets are in different availability zones
  - Check that security groups allow necessary traffic

- **Workspace Access Issues**
  - Verify DNS resolution is working correctly
  - Check that security groups allow HTTPS traffic
  - Ensure your user has the correct permissions

## Certification Exam Notes

- Know the differences between account console and workspace UI
- Understand the workspace deployment process and requirements
- Be familiar with the networking requirements for Databricks
- Know the IAM role requirements and permissions
- Understand the different workspace pricing tiers and features
