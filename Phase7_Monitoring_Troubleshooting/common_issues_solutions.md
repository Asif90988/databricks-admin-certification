# Common Databricks Issues and Solutions

This document provides a comprehensive guide to common issues encountered in Databricks environments and their solutions. It serves as a troubleshooting reference for Databricks administrators.

## Cluster Issues

### 1. Cluster Stuck in Pending State

**Symptoms:**
- Cluster remains in "Pending" state for an extended period
- Cluster creation doesn't complete
- No error messages in the UI

**Possible Causes:**
- Insufficient AWS resources in the selected availability zone
- Network configuration issues
- IAM permission problems
- Instance type availability constraints

**Solutions:**

1. **Check AWS Resource Limits:**
   - Verify EC2 instance limits in the AWS console
   - Request limit increases if necessary
   - Try a different instance type

2. **Verify Network Configuration:**
   ```bash
   # Check security group rules
   aws ec2 describe-security-groups --group-ids sg-xxxxxxxx
   
   # Check subnet configuration
   aws ec2 describe-subnets --subnet-ids subnet-xxxxxxxx
   ```

3. **Validate IAM Permissions:**
   - Ensure the Databricks IAM role has necessary EC2 permissions
   - Check for restrictive IAM policies

4. **Try Different Availability Zone:**
   - Modify subnet selection in cluster configuration
   - Distribute resources across multiple AZs

5. **Check Instance Pool Status:**
   - If using instance pools, verify pool health
   - Check for instance acquisition failures

### 2. Cluster Terminating Unexpectedly

**Symptoms:**
- Clusters terminate without user action
- Jobs fail due to cluster termination
- Intermittent cluster availability

**Possible Causes:**
- Spot instance reclamation
- Autotermination settings
- Resource constraints
- Driver node failures
- Billing issues

**Solutions:**

1. **Check Spot Instance Usage:**
   - Review AWS Spot Instance history
   - Consider using On-Demand instances for critical workloads
   - Configure fallback to On-Demand instances

2. **Verify Autotermination Settings:**
   - Check cluster autotermination configuration
   - Increase timeout for long-running workloads
   - Disable autotermination for critical clusters

3. **Monitor Resource Usage:**
   - Check for memory pressure or disk space issues
   - Increase driver node size if necessary
   - Enable driver logs for analysis

4. **Review Billing Status:**
   - Verify Databricks account status
   - Check for AWS billing issues
   - Ensure payment methods are current

5. **Check Cluster Event Logs:**
   - Navigate to cluster details > Events tab
   - Look for termination reasons
   - Check driver logs for OOM errors

### 3. Slow Cluster Startup

**Symptoms:**
- Clusters take a long time to start
- Inconsistent startup times
- Timeouts during cluster initialization

**Possible Causes:**
- Large init scripts
- Complex library installations
- Instance availability
- Network latency
- Docker image pulls

**Solutions:**

1. **Optimize Init Scripts:**
   - Simplify and optimize initialization scripts
   - Use pre-built images when possible
   - Cache dependencies locally

2. **Use Instance Pools:**
   - Configure instance pools for faster startup
   - Pre-warm pools before peak usage
   - Size pools appropriately

3. **Optimize Library Management:**
   - Use cluster-installed libraries instead of per-notebook
   - Create custom Docker images with pre-installed dependencies
   - Use lightweight libraries when possible

4. **Check Network Performance:**
   - Verify VPC endpoint configuration
   - Optimize network routes
   - Check for bandwidth limitations

5. **Monitor Initialization Logs:**
   - Check init script logs for errors
   - Identify slow-running initialization steps
   - Optimize or parallelize slow steps

## Job Issues

### 1. Job Failures

**Symptoms:**
- Jobs fail consistently or intermittently
- Error messages in job runs
- Unexpected job behavior

**Possible Causes:**
- Code errors
- Resource constraints
- Data issues
- Dependency problems
- Timeout settings

**Solutions:**

1. **Analyze Error Messages:**
   - Check job run logs for specific errors
   - Look for stack traces and exception details
   - Identify patterns in failures

2. **Check Resource Allocation:**
   - Verify cluster sizing is appropriate for the workload
   - Monitor memory usage during job execution
   - Adjust executor and driver memory settings

3. **Validate Data Sources:**
   - Ensure data sources are accessible
   - Check for data quality issues
   - Verify permissions on data sources

4. **Review Dependencies:**
   - Check library versions and compatibility
   - Verify external service availability
   - Test dependencies independently

5. **Adjust Timeout Settings:**
   - Increase job timeout for long-running jobs
   - Configure appropriate retry settings
   - Implement checkpointing for long jobs

### 2. Job Scheduling Issues

**Symptoms:**
- Jobs don't run at scheduled times
- Inconsistent scheduling behavior
- Missed job runs

**Possible Causes:**
- Timezone configuration
- Cluster availability
- Concurrency limits
- Dependency chain issues
- Scheduler service problems

**Solutions:**

1. **Verify Timezone Settings:**
   - Check job timezone configuration
   - Ensure consistency between UI settings and code
   - Account for daylight saving time changes

2. **Check Cluster Availability:**
   - Ensure clusters are available for scheduled jobs
   - Pre-warm clusters before scheduled runs
   - Use dedicated job clusters

3. **Review Concurrency Settings:**
   - Check workspace concurrency limits
   - Stagger job schedules to avoid conflicts
   - Increase concurrency limits if necessary

4. **Validate Job Dependencies:**
   - Check upstream job completion status
   - Implement proper error handling for dependencies
   - Configure appropriate wait times

5. **Monitor Scheduler Service:**
   - Check Databricks service status
   - Review scheduler logs
   - Contact support for persistent issues

### 3. Slow Job Performance

**Symptoms:**
- Jobs take longer than expected to complete
- Increasing job duration over time
- Inconsistent performance

**Possible Causes:**
- Inefficient code
- Data skew
- Resource constraints
- External dependencies
- Network latency

**Solutions:**

1. **Analyze Spark UI:**
   - Review stage details and task metrics
   - Identify bottlenecks and skew
   - Check for spill to disk

2. **Optimize Data Layout:**
   - Implement proper partitioning
   - Use appropriate file formats (Parquet, Delta)
   - Apply Z-ordering for frequently filtered data

3. **Tune Spark Configuration:**
   ```python
   spark.conf.set("spark.sql.shuffle.partitions", "200")
   spark.conf.set("spark.default.parallelism", "100")
   spark.conf.set("spark.sql.adaptive.enabled", "true")
   ```

4. **Implement Caching Strategies:**
   - Cache frequently accessed data
   - Use checkpoint for complex operations
   - Persist intermediate results appropriately

5. **Monitor External Dependencies:**
   - Check latency to external services
   - Implement connection pooling
   - Add timeouts and retries for external calls

## Data Access Issues

### 1. S3 Access Problems

**Symptoms:**
- "Access Denied" errors when accessing S3
- Intermittent S3 connectivity
- Slow S3 operations

**Possible Causes:**
- IAM permission issues
- Bucket policy restrictions
- Endpoint configuration
- Network connectivity
- Credential expiration

**Solutions:**

1. **Verify IAM Permissions:**
   - Check IAM role permissions for S3 access
   - Ensure proper bucket and object permissions
   - Test permissions with AWS CLI

2. **Review Bucket Policies:**
   - Check for restrictive bucket policies
   - Verify IP-based restrictions
   - Check for VPC endpoint policies

3. **Configure S3 Endpoints:**
   - Set up VPC endpoints for S3
   - Configure proper route tables
   - Verify DNS resolution

4. **Optimize S3 Access:**
   ```python
   spark.conf.set("spark.hadoop.fs.s3a.connection.maximum", "200")
   spark.conf.set("spark.hadoop.fs.s3a.fast.upload", "true")
   spark.conf.set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
   ```

5. **Check Credential Management:**
   - Verify instance profile configuration
   - Check for expired credentials
   - Implement credential rotation if using keys

### 2. DBFS Access Issues

**Symptoms:**
- DBFS operations fail
- Permission errors on DBFS paths
- Inconsistent DBFS behavior

**Possible Causes:**
- Permission configuration
- Path syntax errors
- Underlying S3 issues
- Workspace configuration
- Concurrent access conflicts

**Solutions:**

1. **Check Path Syntax:**
   - Ensure proper DBFS path format (`/dbfs/...` vs `dbfs:/...`)
   - Verify path exists
   - Check for special characters in paths

2. **Verify Permissions:**
   - Check workspace access control settings
   - Verify user permissions on folders
   - Check for inherited permissions

3. **Test Underlying Storage:**
   - Verify S3 bucket accessibility
   - Check bucket permissions
   - Test direct S3 access

4. **Manage Concurrent Access:**
   - Implement proper locking mechanisms
   - Avoid multiple writers to the same files
   - Use Delta Lake for transactional guarantees

5. **Check DBFS Mount Points:**
   - Verify mount point configuration
   - Check credential validity for mounts
   - Remount if necessary

### 3. Unity Catalog Issues

**Symptoms:**
- Table access failures
- Metadata synchronization problems
- Permission errors with Unity Catalog

**Possible Causes:**
- Metastore configuration
- Permission setup
- Credential issues
- Storage access problems
- Catalog synchronization

**Solutions:**

1. **Verify Metastore Configuration:**
   - Check metastore status in account console
   - Verify storage location accessibility
   - Check metastore assignment to workspaces

2. **Review Permission Model:**
   - Verify grants on catalogs, schemas, and tables
   - Check group membership for users
   - Implement proper privilege inheritance

3. **Check Storage Credentials:**
   - Verify storage credential configuration
   - Check external location access
   - Test credential validity

4. **Synchronize Metadata:**
   - Refresh table metadata
   - Validate table definitions
   - Check for schema drift

5. **Implement Proper Isolation:**
   - Use separate catalogs for different environments
   - Implement proper access controls
   - Document catalog organization

## Notebook Issues

### 1. Notebook Execution Failures

**Symptoms:**
- Cells fail to execute
- Unexpected errors in notebooks
- Inconsistent notebook behavior

**Possible Causes:**
- Cluster connectivity
- Library dependencies
- Code errors
- Resource constraints
- Kernel issues

**Solutions:**

1. **Check Cluster Connection:**
   - Verify cluster is running and responsive
   - Detach and reattach notebook to cluster
   - Check for network connectivity issues

2. **Verify Library Dependencies:**
   - Ensure required libraries are installed
   - Check for version conflicts
   - Install missing dependencies

3. **Debug Code Errors:**
   - Add error handling and logging
   - Break complex operations into smaller steps
   - Print intermediate results for debugging

4. **Monitor Resource Usage:**
   - Check for memory pressure
   - Monitor CPU utilization
   - Optimize resource-intensive operations

5. **Restart Kernel if Necessary:**
   - Use "Restart Python" or "Restart Scala" option
   - Clear notebook state
   - Reinitialize variables and connections

### 2. Notebook Performance Issues

**Symptoms:**
- Slow cell execution
- Increasing execution times
- UI responsiveness problems

**Possible Causes:**
- Inefficient code
- Large result sets
- Display function overhead
- Browser limitations
- Network latency

**Solutions:**

1. **Optimize Code Efficiency:**
   - Refactor inefficient algorithms
   - Use vectorized operations
   - Implement proper filtering early in the pipeline

2. **Limit Result Size:**
   - Use `display(df.limit(1000))` instead of showing full datasets
   - Aggregate data before visualization
   - Sample large datasets for exploration

3. **Optimize Visualizations:**
   - Use appropriate visualization types
   - Limit the number of elements in plots
   - Consider external visualization tools for complex visuals

4. **Implement Caching:**
   - Cache intermediate results
   - Use Spark caching appropriately
   - Checkpoint long computation chains

5. **Break Up Complex Notebooks:**
   - Split large notebooks into smaller ones
   - Use notebook workflows
   - Modularize code into functions and libraries

### 3. Collaboration Issues

**Symptoms:**
- Version conflicts
- Lost changes
- Merge conflicts
- Permission problems

**Possible Causes:**
- Concurrent editing
- Workspace permissions
- Revision management
- Notebook export/import issues

**Solutions:**

1. **Implement Version Control:**
   - Use Databricks Repos for Git integration
   - Commit changes regularly
   - Follow Git best practices

2. **Manage Permissions:**
   - Set appropriate notebook permissions
   - Use workspace access control
   - Document ownership and access

3. **Coordinate Collaboration:**
   - Communicate about active development
   - Use branches for parallel work
   - Implement code review processes

4. **Export/Import Properly:**
   - Use DBC format for notebook exports
   - Maintain library dependencies
   - Document environment requirements

5. **Use Revision History:**
   - Leverage notebook revision history
   - Restore previous versions when needed
   - Document significant changes

## Authentication and Authorization Issues

### 1. SSO Configuration Problems

**Symptoms:**
- SSO login failures
- Redirect issues
- User provisioning problems

**Possible Causes:**
- IdP configuration
- SAML settings
- Certificate issues
- Attribute mapping
- Network connectivity

**Solutions:**

1. **Verify IdP Configuration:**
   - Check SAML settings in identity provider
   - Verify entity ID and ACS URL
   - Ensure proper attribute mapping

2. **Check Databricks SSO Settings:**
   - Verify SSO configuration in account console
   - Check SAML response handling
   - Test with specific users

3. **Validate Certificates:**
   - Ensure certificates are valid and not expired
   - Check certificate format and encoding
   - Verify trust chain

4. **Test Network Connectivity:**
   - Ensure connectivity between Databricks and IdP
   - Check for firewall or proxy issues
   - Verify DNS resolution

5. **Review SCIM Provisioning:**
   - Check SCIM token validity
   - Verify user and group mapping
   - Test provisioning and deprovisioning

### 2. Permission and Access Control Issues

**Symptoms:**
- Unexpected access denials
- Permission inconsistencies
- Inability to access resources

**Possible Causes:**
- Role configuration
- Group membership
- Object permissions
- Inheritance issues
- Workspace settings

**Solutions:**

1. **Review Role Assignments:**
   - Check user and group role assignments
   - Verify role permissions
   - Test with different roles

2. **Verify Group Membership:**
   - Check user group memberships
   - Verify group nesting and inheritance
   - Update group assignments as needed

3. **Check Object Permissions:**
   - Review permissions on specific objects
   - Check for permission inheritance
   - Set explicit permissions when necessary

4. **Audit Access Control:**
   - Review access control logs
   - Check for recent permission changes
   - Document permission structure

5. **Implement Least Privilege:**
   - Grant minimum necessary permissions
   - Use groups for permission management
   - Regularly review and audit permissions

### 3. API and Token Issues

**Symptoms:**
- API call failures
- Token authentication errors
- Expired or invalid tokens

**Possible Causes:**
- Token expiration
- Permission scopes
- API version compatibility
- Rate limiting
- Network issues

**Solutions:**

1. **Check Token Validity:**
   - Verify token expiration date
   - Regenerate expired tokens
   - Implement token rotation

2. **Verify Token Permissions:**
   - Check token permission scopes
   - Ensure token has necessary permissions
   - Create purpose-specific tokens

3. **Review API Usage:**
   - Check API version compatibility
   - Verify endpoint URLs
   - Implement proper error handling

4. **Monitor Rate Limits:**
   - Check for rate limiting errors
   - Implement backoff and retry logic
   - Optimize API call frequency

5. **Secure Token Storage:**
   - Use Databricks secrets for token storage
   - Avoid hardcoding tokens in notebooks
   - Implement proper secret rotation

## Performance Optimization

### 1. Spark Performance Tuning

**Symptoms:**
- Slow query execution
- Job execution bottlenecks
- Resource underutilization

**Possible Causes:**
- Suboptimal configurations
- Data skew
- Inefficient joins
- Memory pressure
- Improper parallelism

**Solutions:**

1. **Optimize Parallelism:**
   ```python
   # Adjust shuffle partitions based on data size
   spark.conf.set("spark.sql.shuffle.partitions", "200")
   
   # Set default parallelism
   spark.conf.set("spark.default.parallelism", "100")
   
   # Enable adaptive query execution
   spark.conf.set("spark.sql.adaptive.enabled", "true")
   ```

2. **Tune Memory Settings:**
   ```python
   # Adjust memory fraction for execution
   spark.conf.set("spark.memory.fraction", "0.8")
   
   # Set memory overhead
   spark.conf.set("spark.executor.memoryOverhead", "2g")
   
   # Configure spill threshold
   spark.conf.set("spark.sql.shuffle.spill.threshold", "5000")
   ```

3. **Optimize Join Strategies:**
   - Use broadcast joins for small tables
   - Implement proper join hints
   - Reorder joins for efficiency

4. **Address Data Skew:**
   - Identify skewed keys
   - Implement salting for skewed joins
   - Use repartitioning strategies

5. **Leverage Caching:**
   - Cache frequently accessed data
   - Use appropriate storage levels
   - Unpersist when data is no longer needed

### 2. I/O Optimization

**Symptoms:**
- Slow data reading/writing
- Storage bottlenecks
- Network congestion

**Possible Causes:**
- Inefficient file formats
- Poor partitioning
- Network limitations
- Storage throughput
- Serialization overhead

**Solutions:**

1. **Use Efficient File Formats:**
   - Convert data to Parquet or Delta format
   - Implement compression (Snappy, GZIP)
   - Use columnar storage for analytical queries

2. **Optimize Partitioning:**
   - Partition data by frequently filtered columns
   - Avoid over-partitioning (too many small files)
   - Implement partition pruning

3. **Tune I/O Configurations:**
   ```python
   # Optimize S3 connections
   spark.conf.set("spark.hadoop.fs.s3a.connection.maximum", "200")
   
   # Enable fast upload
   spark.conf.set("spark.hadoop.fs.s3a.fast.upload", "true")
   
   # Configure buffer size
   spark.conf.set("spark.hadoop.fs.s3a.buffer.dir", "/tmp")
   spark.conf.set("spark.hadoop.fs.s3a.fast.buffer.size", "1MB")
   ```

4. **Implement Data Locality:**
   - Process data close to storage
   - Use instance storage for temporary data
   - Consider data placement strategies

5. **Optimize Serialization:**
   - Use Kryo serialization for better performance
   - Register custom classes
   - Tune serialization buffer sizes

### 3. Resource Allocation

**Symptoms:**
- Resource contention
- Uneven resource utilization
- Cluster inefficiency

**Possible Causes:**
- Improper sizing
- Inefficient autoscaling
- Resource hogging
- Concurrent workloads
- Imbalanced allocation

**Solutions:**

1. **Right-Size Clusters:**
   - Match instance types to workload requirements
   - Balance memory and CPU resources
   - Consider specialized instances for specific workloads

2. **Optimize Autoscaling:**
   - Set appropriate min/max workers
   - Configure scale-up and scale-down behavior
   - Monitor scaling events and adjust

3. **Implement Workload Isolation:**
   - Separate interactive and automated workloads
   - Use job clusters for batch processing
   - Implement resource pools for fair sharing

4. **Monitor Resource Utilization:**
   - Track CPU, memory, and I/O usage
   - Identify resource bottlenecks
   - Adjust allocation based on utilization patterns

5. **Implement Fair Scheduling:**
   - Configure fair scheduler pools
   - Set appropriate resource allocation
   - Prioritize critical workloads

## Certification Exam Tips

- Understand common cluster issues and their solutions
- Know how to troubleshoot job failures and performance problems
- Be familiar with data access troubleshooting techniques
- Understand authentication and authorization troubleshooting
- Know how to optimize Spark performance
- Be able to implement effective monitoring and alerting

## Next Steps

- Review `systematic_troubleshooting.md` for a structured approach to problem-solving
- Explore `advanced_diagnostics.md` for deeper diagnostic techniques
- See `monitoring_overview.md` for proactive issue detection
- Check `alert_configuration.md` for setting up alerts for common issues
