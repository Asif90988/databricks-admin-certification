# AWS S3 Integration Guide for Databricks

This guide provides detailed instructions for configuring and managing AWS S3 integration with Databricks. Proper S3 integration is essential for data lake implementation, cost-effective storage, and seamless data access.

## Integration Architecture

Databricks can access S3 through several authentication mechanisms:

```
┌─────────────────────────────────────────────────────┐
│                  Databricks Workspace               │
└───────────────────────────────────────────────┬─────┘
                                                │
┌───────────────────────────────────────────────▼─────┐
│               Authentication Methods                │
├─────────────────────┬─────────────────┬─────────────┤
│  IAM Instance       │  IAM Cross-     │  Access     │
│  Profiles           │  Account Role   │  Keys       │
└─────────────────────┴─────────────┬───┴─────────────┘
                                    │
┌───────────────────────────────────▼─────────────────┐
│                    Amazon S3                        │
└─────────────────────────────────────────────────────┘
```

## Authentication Methods

### 1. IAM Cross-Account Role (Recommended)

**Description:**
- Uses AWS IAM roles for cross-account access
- Most secure and manageable approach
- Supports temporary credentials with automatic rotation

**Setup Process:**

1. **Create an IAM Role in your AWS Account:**
   - Log in to the AWS Management Console
   - Navigate to IAM > Roles > Create Role
   - Select "Another AWS account" as the trusted entity
   - Enter the Databricks AWS account ID (provided by Databricks)
   - Add an external ID condition (use your Databricks account ID)

2. **Attach Policies to the Role:**
   - Create a custom policy with the necessary S3 permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetLifecycleConfiguration"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetObjectVersion"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

3. **Configure Instance Profile in Databricks:**
   - Navigate to the Databricks admin console
   - Go to "Settings" > "Instance Profiles"
   - Add the IAM role ARN
   - Assign the instance profile to clusters

4. **Use in Spark Code:**
```python
spark.read.parquet("s3a://your-bucket-name/path/to/data")
```

**Advantages:**
- No credential management in code
- Automatic credential rotation
- Fine-grained access control
- Audit trail in AWS CloudTrail

**Limitations:**
- Requires AWS account administration
- More complex initial setup

### 2. Access Keys (Not Recommended for Production)

**Description:**
- Uses AWS access key ID and secret access key
- Simple to implement but less secure
- Useful for testing or development environments

**Setup Process:**

1. **Create an IAM User with Access Keys:**
   - Log in to the AWS Management Console
   - Navigate to IAM > Users > Create User
   - Attach policies for S3 access
   - Generate access keys

2. **Configure in Spark:**
```python
spark.conf.set("fs.s3a.access.key", "YOUR_ACCESS_KEY")
spark.conf.set("fs.s3a.secret.key", "YOUR_SECRET_KEY")
spark.conf.set("fs.s3a.endpoint", "s3.amazonaws.com")
```

3. **Use in Spark Code:**
```python
spark.read.parquet("s3a://your-bucket-name/path/to/data")
```

**Advantages:**
- Simple to implement
- Works in any environment
- No AWS account configuration required

**Limitations:**
- Security risk with long-lived credentials
- Manual credential rotation
- Credentials in code or notebooks
- Limited audit capabilities

### 3. Databricks Credential Passthrough (Enterprise Tier)

**Description:**
- Uses the credentials of the user running the notebook
- Provides user-level access control
- Requires Unity Catalog and Enterprise tier

**Setup Process:**

1. **Configure Unity Catalog:**
   - Set up Unity Catalog with AWS integration
   - Configure storage credentials

2. **Create External Location:**
```sql
CREATE EXTERNAL LOCATION my_s3_location
URL 's3://your-bucket-name'
WITH (CREDENTIAL aws_credential);
```

3. **Grant Permissions:**
```sql
GRANT CREATE TABLE, READ FILES, WRITE FILES
ON EXTERNAL LOCATION my_s3_location
TO group_name;
```

4. **Use in Spark Code:**
```python
spark.read.parquet("s3a://your-bucket-name/path/to/data")
```

**Advantages:**
- User-level access control
- Integrated with Unity Catalog
- Simplified credential management
- Enhanced security and governance

**Limitations:**
- Requires Enterprise tier
- More complex setup
- Additional cost

## S3 Bucket Configuration

### 1. Bucket Policies

Configure bucket policies to control access at the bucket level:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

### 2. CORS Configuration

If you need to access S3 from browser-based applications:

```json
{
  "CORSRules": [
    {
      "AllowedOrigins": ["https://*.cloud.databricks.com"],
      "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
      "AllowedHeaders": ["*"],
      "MaxAgeSeconds": 3000
    }
  ]
}
```

### 3. Lifecycle Policies

Implement lifecycle policies for cost optimization:

```json
{
  "Rules": [
    {
      "ID": "Move to IA after 30 days",
      "Status": "Enabled",
      "Prefix": "data/",
      "Transition": {
        "Days": 30,
        "StorageClass": "STANDARD_IA"
      }
    },
    {
      "ID": "Archive after 90 days",
      "Status": "Enabled",
      "Prefix": "archive/",
      "Transition": {
        "Days": 90,
        "StorageClass": "GLACIER"
      }
    }
  ]
}
```

## Mount Points

### Creating Mount Points

Mount points provide a simplified way to access S3 data:

```python
# Using IAM role (recommended)
dbutils.fs.mount(
  source = "s3a://your-bucket-name/path",
  mount_point = "/mnt/your-mount-name",
  extra_configs = {
    "fs.s3a.aws.credentials.provider": "com.amazonaws.auth.InstanceProfileCredentialsProvider"
  }
)

# Using access keys (not recommended for production)
dbutils.fs.mount(
  source = "s3a://your-bucket-name/path",
  mount_point = "/mnt/your-mount-name",
  extra_configs = {
    "fs.s3a.access.key": dbutils.secrets.get(scope="aws", key="access_key"),
    "fs.s3a.secret.key": dbutils.secrets.get(scope="aws", key="secret_key")
  }
)
```

### Managing Mount Points

```python
# List mount points
display(dbutils.fs.mounts())

# Unmount a mount point
dbutils.fs.unmount("/mnt/your-mount-name")
```

### Mount Point Best Practices

1. **Use Secrets for Credentials:**
   - Store credentials in Databricks secrets
   - Reference secrets in mount configurations
   - Never hardcode credentials

2. **Implement Mount Point Management:**
   - Create a central notebook for mount point management
   - Document mount points and their purposes
   - Implement consistent naming conventions

3. **Consider Security Implications:**
   - Mount points are workspace-wide
   - All users with workspace access can access mounted data
   - Use Unity Catalog for fine-grained access control

## Performance Optimization

### 1. S3A Connector Configuration

Optimize the S3A connector for better performance:

```python
spark.conf.set("fs.s3a.connection.maximum", "200")
spark.conf.set("fs.s3a.connection.timeout", "300000")
spark.conf.set("fs.s3a.attempts.maximum", "20")
spark.conf.set("fs.s3a.connection.establish.timeout", "5000")
spark.conf.set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
```

### 2. Data Format Optimization

Choose appropriate data formats:

- **Parquet**: Columnar format with compression, ideal for analytical queries
- **Delta Lake**: Adds ACID transactions and time travel to Parquet
- **ORC**: Alternative columnar format with good compression
- **Avoid**: CSV, JSON for large datasets due to performance limitations

### 3. Partitioning Strategy

Implement effective partitioning:

```python
# Writing partitioned data
df.write.partitionBy("year", "month").parquet("s3a://your-bucket/data")

# Reading with partition pruning
spark.read.parquet("s3a://your-bucket/data").filter("year = 2023 AND month = 5")
```

### 4. S3 Committer

Use the optimized S3 committer for better write performance:

```python
spark.conf.set("spark.hadoop.fs.s3a.committer.name", "magic")
spark.conf.set("spark.sql.sources.commitProtocolClass", "org.apache.spark.internal.io.cloud.PathOutputCommitProtocol")
spark.conf.set("spark.sql.parquet.output.committer.class", "org.apache.spark.internal.io.cloud.BindingParquetOutputCommitter")
```

## Security Considerations

### 1. Encryption

Configure encryption for data at rest:

```python
# Server-side encryption with S3-managed keys (SSE-S3)
spark.conf.set("fs.s3a.server-side-encryption-algorithm", "AES256")

# Server-side encryption with KMS-managed keys (SSE-KMS)
spark.conf.set("fs.s3a.server-side-encryption-algorithm", "SSE-KMS")
spark.conf.set("fs.s3a.server-side-encryption.key", "arn:aws:kms:region:account:key/key-id")
```

### 2. Access Logging

Enable S3 access logging:

1. Create a logging bucket
2. Configure the source bucket to log to the logging bucket
3. Analyze logs for security monitoring and compliance

### 3. Network Security

Implement network-level security:

1. Configure S3 VPC endpoints for private access
2. Use bucket policies to restrict access to specific VPC endpoints
3. Implement IP-based restrictions in bucket policies

## Troubleshooting Common Issues

### 1. Access Denied Errors

**Symptoms:**
- "Access Denied" errors when accessing S3
- Permission-related exceptions

**Solutions:**
- Verify IAM role or user permissions
- Check bucket policies
- Ensure the correct credentials are being used
- Validate cross-account trust relationships
- Check for bucket encryption requirements

### 2. Performance Issues

**Symptoms:**
- Slow read or write operations
- Timeout errors
- Job failures on large datasets

**Solutions:**
- Optimize S3A connector settings
- Use appropriate data formats (Parquet, Delta)
- Implement effective partitioning
- Check for small file issues
- Consider using instance pools with instance storage

### 3. Mount Point Failures

**Symptoms:**
- Mount point creation fails
- "No such mount point" errors
- Intermittent access issues

**Solutions:**
- Verify credentials and permissions
- Check for bucket existence and accessibility
- Ensure mount point naming is correct
- Restart clusters after credential changes
- Consider using direct S3 paths instead of mounts

## Certification Exam Tips

- Understand the different authentication methods for S3 access
- Know how to configure IAM roles for cross-account access
- Be familiar with mount point creation and management
- Understand security best practices for S3 integration
- Know how to troubleshoot common S3 access issues
- Be familiar with performance optimization techniques

## Next Steps

- Explore `dbfs_architecture.md` for understanding how DBFS integrates with S3
- Review `mount_point_creation.md` for detailed mount point examples
- See `unity_catalog_overview.md` for information on Unity Catalog integration with S3
- Check `data_security_best_practices.md` for additional security considerations
