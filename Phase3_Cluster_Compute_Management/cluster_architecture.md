# Databricks Cluster Architecture

This document provides an overview of the Databricks cluster architecture, including the components, execution model, and how they work together to process data.

## Cluster Components

A Databricks cluster consists of two main types of nodes:

### Driver Node

The driver node is the control center of a Databricks cluster:

- Hosts the Spark driver process
- Maintains the SparkSession
- Coordinates work across the cluster
- Stores and processes the results of Spark jobs
- Hosts the notebook execution environment
- Manages the Spark UI and event logs
- Typically requires more memory than worker nodes for complex operations

### Worker Nodes

Worker nodes perform the actual data processing:

- Execute tasks assigned by the driver
- Store data in memory or on disk
- Process data in parallel
- Scale horizontally to handle larger workloads
- Can be added or removed dynamically with autoscaling

## Cluster Modes

Databricks supports different cluster modes to accommodate various workloads:

### Standard Mode

- Multiple worker nodes and one driver node
- Suitable for most production workloads
- Supports parallel processing across workers
- Recommended for large datasets and complex computations

### Single Node Mode

- Only one node that acts as both driver and worker
- Suitable for small datasets and development
- Lower cost but limited scalability
- Good for testing and development

### High Concurrency Mode (Legacy)

- Optimized for multiple concurrent users
- Provides fair scheduling between users
- Limited to SQL and Python workloads
- Being replaced by SQL warehouses

## Execution Model

Databricks uses Apache Spark's execution model:

1. **Driver Program**: The notebook or job running on the driver node
2. **SparkContext**: The entry point for Spark functionality
3. **Cluster Manager**: Allocates resources across the cluster
4. **Executors**: Processes running on worker nodes that execute tasks
5. **Tasks**: Individual units of work that executors perform

### Execution Flow

1. User code runs on the driver node
2. Driver converts operations into a directed acyclic graph (DAG) of tasks
3. Tasks are grouped into stages based on data dependencies
4. Stages are divided into tasks that can run in parallel
5. Tasks are distributed to executors on worker nodes
6. Results are collected back to the driver

## Storage Layers

Databricks clusters interact with multiple storage layers:

### Local Storage

- Instance storage (ephemeral)
- Used for shuffle data and temporary files
- Lost when the cluster terminates
- Faster access but limited capacity

### Databricks File System (DBFS)

- Distributed file system built on top of object storage
- Persists beyond cluster termination
- Accessible across clusters
- Used for notebooks, libraries, and data

### External Storage

- S3, Azure Blob Storage, Google Cloud Storage
- Used for permanent data storage
- Accessible from multiple clusters
- Supports various file formats (Parquet, Delta, etc.)

## Network Architecture

Databricks clusters operate within a specific network configuration:

- Deployed within a VPC/VNET
- Can be configured with public or private access
- Supports VPC/VNET peering for connecting to other resources
- Can be placed in specific subnets
- Security groups control inbound and outbound traffic

## Runtime Versions

Databricks Runtime (DBR) is the set of core components that run on clusters:

- Includes Apache Spark, Delta Lake, and other libraries
- Available in different versions with varying features
- Specialized runtimes for ML, Genomics, etc.
- Photon acceleration engine for SQL workloads
- Regular updates with performance improvements and new features

## Cluster Lifecycle

Understanding the cluster lifecycle is important for administration:

1. **Creation**: Cluster is provisioned with specified configuration
2. **Starting**: Resources are allocated and services are started
3. **Running**: Cluster is operational and executing workloads
4. **Resizing**: Adding or removing worker nodes (manual or autoscaling)
5. **Restarting**: Cluster is stopped and started again
6. **Termination**: Cluster is shut down and resources are released

## Autoscaling

Databricks clusters can automatically scale based on workload:

- Adds workers when there are pending tasks
- Removes workers when they are idle
- Configurable minimum and maximum workers
- Optimizes for both performance and cost
- Different behavior for different workload types

## Cluster Isolation Models

Databricks supports different isolation models for clusters:

### Single-User Clusters

- Dedicated to a single user
- Higher security isolation
- Resources not shared with other users
- Required for certain sensitive workloads

### Shared Clusters

- Multiple users can access the same cluster
- More cost-effective
- Resources shared among users
- Suitable for collaborative environments

## Certification Exam Tips

- Understand the difference between driver and worker nodes
- Know how Spark distributes and executes tasks
- Be familiar with cluster modes and their use cases
- Understand how autoscaling works
- Know the cluster lifecycle and management operations
- Be able to troubleshoot common cluster issues

## Next Steps

- Review the `cluster_creation_template.json` for an example of cluster configuration
- Explore `advanced_cluster_settings.md` for detailed configuration options
- See `cluster_sizing_guidelines.md` for recommendations on sizing clusters for different workloads
