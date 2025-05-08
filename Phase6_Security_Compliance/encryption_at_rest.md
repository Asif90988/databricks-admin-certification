# Encryption at Rest in Databricks

This document provides a comprehensive guide for implementing and managing encryption at rest in Databricks. Encryption at rest is a critical security control that protects data from unauthorized access if physical storage is compromised.

## Overview of Encryption at Rest

Encryption at rest ensures that data stored on disk is encrypted and can only be accessed with the appropriate encryption keys. In Databricks, encryption at rest applies to several storage layers:

1. **DBFS (Databricks File System)**: Data stored in the underlying cloud storage
2. **Local Storage**: Temporary data on cluster nodes
3. **EBS Volumes**: Attached storage volumes for clusters
4. **Metastore Data**: Metadata about tables and views

## Encryption Options in Databricks

Databricks provides several options for encryption at rest:

### 1. Default Encryption

**Description:**
- Managed by Databricks
- Uses cloud provider's default encryption mechanisms
- Minimal configuration required

**Implementation:**
- Enabled by default for all Databricks deployments
- Uses AWS S3 server-side encryption for DBFS
- Uses EBS encryption for attached volumes

**Advantages:**
- Simple to implement
- No key management overhead
- Transparent to users

**Limitations:**
- Limited control over encryption keys
- May not meet strict compliance requirements
- No customer-managed key rotation

### 2. AWS KMS Integration (BYOK)

**Description:**
- Bring Your Own Key (BYOK) approach
- Uses customer-managed keys in AWS KMS
- Provides greater control over encryption

**Implementation:**
- Configure AWS KMS keys
- Set up Databricks to use customer-managed keys
- Implement key rotation policies

**Advantages:**
- Full control over encryption keys
- Ability to revoke access by disabling keys
- Meets stricter compliance requirements
- Audit trail for key usage

**Limitations:**
- Additional configuration complexity
- Key management overhead
- Potential for service disruption if keys are mismanaged

## Implementation Steps

### Step 1: Assess Encryption Requirements

Before implementing encryption at rest, assess your requirements:

1. **Compliance Needs**:
   - Identify regulatory requirements (GDPR, HIPAA, PCI DSS, etc.)
   - Determine internal security policies
   - Document encryption strength requirements

2. **Key Management Approach**:
   - Decide between Databricks-managed or customer-managed keys
   - Determine key rotation frequency
   - Identify key access control requirements

3. **Scope of Encryption**:
   - Identify which data requires encryption
   - Determine encryption requirements for different data types
   - Plan for encryption of existing data

### Step 2: Configure AWS KMS for BYOK (Optional)

If using customer-managed keys, configure AWS KMS:

1. **Create KMS Key**:
   ```bash
   aws kms create-key --description "Databricks BYOK Encryption Key"
   ```

2. **Create Key Alias**:
   ```bash
   aws kms create-alias --alias-name alias/databricks-encryption --target-key-id <key-id>
   ```

3. **Configure Key Policy**:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "Enable IAM User Permissions",
         "Effect": "Allow",
         "Principal": {
           "AWS": "arn:aws:iam::<account-id>:root"
         },
         "Action": "kms:*",
         "Resource": "*"
       },
       {
         "Sid": "Allow Databricks to use the key",
         "Effect": "Allow",
         "Principal": {
           "AWS": "arn:aws:iam::<account-id>:role/databricks-role"
         },
         "Action": [
           "kms:Encrypt",
           "kms:Decrypt",
           "kms:ReEncrypt*",
           "kms:GenerateDataKey*",
           "kms:DescribeKey"
         ],
         "Resource": "*"
       }
     ]
   }
   ```

4. **Enable Key Rotation (Recommended)**:
   ```bash
   aws kms enable-key-rotation --key-id <key-id>
   ```

### Step 3: Configure DBFS Encryption

Configure encryption for the Databricks File System (DBFS):

#### Using Default Encryption

Default encryption is automatically enabled for DBFS using the cloud provider's encryption mechanisms.

#### Using Customer-Managed Keys (BYOK)

1. **Navigate to the Databricks Account Console**
2. **Go to Security & Governance > Encryption**
3. **Select "Use a customer-managed key"**
4. **Enter the AWS KMS key ARN**
5. **Save the configuration**

### Step 4: Configure Local Disk Encryption

Configure encryption for local disks on cluster nodes:

1. **Navigate to Compute > Clusters**
2. **Create or edit a cluster**
3. **Expand the Advanced Options section**
4. **Enable "Local disk encryption"**
5. **Save the cluster configuration**

**Cluster JSON Configuration**:
```json
{
  "cluster_name": "Encrypted Cluster",
  "spark_version": "11.3.x-scala2.12",
  "node_type_id": "i3.xlarge",
  "enable_local_disk_encryption": true
}
```

**API Configuration**:
```python
import requests

api_url = "https://your-databricks-instance/api/2.0/clusters/create"
headers = {
  "Authorization": f"Bearer {token}"
}
data = {
  "cluster_name": "Encrypted Cluster",
  "spark_version": "11.3.x-scala2.12",
  "node_type_id": "i3.xlarge",
  "enable_local_disk_encryption": True
}
response = requests.post(api_url, headers=headers, json=data)
```

### Step 5: Configure EBS Volume Encryption

Configure encryption for EBS volumes attached to cluster nodes:

1. **Navigate to Compute > Clusters**
2. **Create or edit a cluster**
3. **Expand the Advanced Options section**
4. **Under AWS Settings, configure EBS encryption**
5. **Save the cluster configuration**

**Cluster JSON Configuration**:
```json
{
  "cluster_name": "EBS Encrypted Cluster",
  "spark_version": "11.3.x-scala2.12",
  "node_type_id": "i3.xlarge",
  "aws_attributes": {
    "ebs_encryption": true
  }
}
```

### Step 6: Configure Metastore Encryption

If using Unity Catalog, configure encryption for the metastore:

1. **Navigate to the Databricks Account Console**
2. **Go to Data > Metastores**
3. **Create or edit a metastore**
4. **Configure encryption settings**
5. **Specify the AWS KMS key ARN for encryption**
6. **Save the metastore configuration**

## Verification and Monitoring

### 1. Verify Encryption Configuration

Verify that encryption is properly configured:

1. **Check DBFS Encryption**:
   - Navigate to the Account Console > Security & Governance > Encryption
   - Verify the encryption status and key information

2. **Check Cluster Encryption**:
   - Navigate to Compute > Clusters
   - View cluster details and verify encryption settings
   - Check the "Local disk encryption" setting

3. **Check Metastore Encryption**:
   - Navigate to Data > Metastores
   - View metastore details and verify encryption settings

### 2. Monitor Encryption Status

Implement monitoring for encryption status:

1. **AWS CloudTrail Logs**:
   - Monitor KMS key usage events
   - Set up alerts for unauthorized key access attempts
   - Track key rotation events

2. **Databricks Audit Logs**:
   - Monitor encryption configuration changes
   - Track cluster creation with encryption settings
   - Audit metastore encryption changes

3. **Regular Compliance Checks**:
   - Implement scheduled reviews of encryption settings
   - Verify that all required data is encrypted
   - Check for encryption configuration drift

## Key Management Best Practices

### 1. Key Rotation

Implement regular key rotation to enhance security:

1. **Automated Rotation**:
   - Configure AWS KMS for automatic key rotation
   - Set appropriate rotation frequency (e.g., annually)
   - Monitor rotation events

2. **Manual Rotation Process**:
   - Create a new KMS key
   - Update Databricks encryption settings to use the new key
   - Verify that data remains accessible
   - Retire the old key after transition period

### 2. Key Access Control

Implement strict access controls for encryption keys:

1. **Principle of Least Privilege**:
   - Limit key management permissions to authorized personnel
   - Use IAM roles with specific key permissions
   - Implement separation of duties

2. **Key Usage Monitoring**:
   - Set up CloudWatch alerts for key usage
   - Monitor for unusual access patterns
   - Implement automated responses to suspicious activities

### 3. Key Backup and Recovery

Implement key backup and recovery procedures:

1. **Documentation**:
   - Document key ARNs and aliases
   - Maintain key usage inventory
   - Document recovery procedures

2. **Recovery Testing**:
   - Regularly test key recovery procedures
   - Verify that data remains accessible after recovery
   - Update procedures based on test results

## Troubleshooting Common Issues

### 1. Access Denied to KMS Key

**Symptoms:**
- "Access Denied" errors when accessing encrypted data
- Cluster startup failures with key access errors

**Solutions:**
- Verify KMS key policy allows access from Databricks role
- Check IAM permissions for the Databricks role
- Ensure the key is enabled and not scheduled for deletion
- Verify the correct key ARN is configured in Databricks

### 2. Encryption Performance Impact

**Symptoms:**
- Slower cluster startup times
- Reduced I/O performance

**Solutions:**
- Use instance types with hardware encryption support
- Optimize data access patterns
- Consider using instance store for temporary data
- Implement appropriate caching strategies

### 3. Key Rotation Issues

**Symptoms:**
- Data access failures after key rotation
- Inconsistent encryption behavior

**Solutions:**
- Verify that the new key is properly configured
- Ensure Databricks has permissions to the new key
- Check for proper key alias configuration
- Implement gradual transition to new keys

## Certification Exam Tips

- Understand the difference between default encryption and BYOK
- Know how to configure KMS for Databricks integration
- Be familiar with the encryption options for different storage layers
- Understand key rotation and management best practices
- Know how to troubleshoot common encryption issues
- Be able to implement encryption to meet compliance requirements

## Next Steps

- Review `key_management.md` for detailed information on key management
- Explore `encryption_in_transit.md` for guidance on configuring encryption in transit
- See `regulatory_compliance.md` for information on meeting compliance requirements
- Check `security_monitoring.md` for details on monitoring encryption status
