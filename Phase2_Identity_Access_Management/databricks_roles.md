# Databricks Built-in Roles and Permissions

This document provides a comprehensive overview of the built-in roles in Databricks and their associated permissions. Understanding these roles is crucial for implementing proper access control in your Databricks environment.

## Role Hierarchy

Databricks roles follow a hierarchical structure, with higher-level roles inheriting permissions from lower-level roles:

```
ACCOUNT_ADMIN
    |
    ├── ACCOUNT_USER
    |       |
    |       └── WORKSPACE_ADMIN
    |               |
    |               └── WORKSPACE_USER
    |
    └── METASTORE_ADMIN (Unity Catalog)
```

## Detailed Role Descriptions

### ACCOUNT_ADMIN

**Description:** The highest level of access in Databricks. Account administrators have full control over the Databricks account and all workspaces.

**Key Permissions:**
- Manage account settings and configurations
- Create, modify, and delete workspaces
- Manage users and groups at the account level
- Assign roles to users and groups
- Configure authentication and SSO
- Manage billing and usage
- Access all workspaces
- Perform all actions that other roles can perform

**When to Assign:**
- Assign to a limited number of trusted administrators
- Typically assigned to IT administrators or cloud platform teams
- Should follow the principle of least privilege

### ACCOUNT_USER

**Description:** Users with this role can access the account console but have limited administrative capabilities.

**Key Permissions:**
- View account settings
- View workspace list
- Access workspaces they are assigned to
- Cannot create or modify workspaces
- Cannot manage users or groups at the account level

**When to Assign:**
- Assign to users who need to access multiple workspaces
- Useful for team leads who need visibility into the account but not full administrative control

### WORKSPACE_ADMIN

**Description:** Administrators of specific workspaces with full control over workspace resources.

**Key Permissions:**
- Manage workspace settings
- Create, modify, and delete clusters
- Create, modify, and delete instance pools
- Manage workspace users and groups
- Assign workspace-level permissions
- Access all notebooks and jobs in the workspace
- Manage secrets and credentials
- Configure workspace-level integrations

**When to Assign:**
- Assign to team leads or project managers
- Typically responsible for a specific workspace or project
- Should be limited to users who need to manage workspace resources

### WORKSPACE_USER

**Description:** Standard users who can access and use workspace resources based on their assigned permissions.

**Key Permissions:**
- Access the workspace
- Create and run notebooks (if granted)
- Create and run jobs (if granted)
- Use existing clusters (if granted)
- Create personal clusters (if granted)
- Access data based on permissions

**When to Assign:**
- Assign to most users who need to work in Databricks
- Default role for data scientists, analysts, and engineers

### METASTORE_ADMIN (Unity Catalog)

**Description:** Administrators of the Unity Catalog metastore with full control over data governance.

**Key Permissions:**
- Create, modify, and delete catalogs
- Create, modify, and delete schemas
- Manage data access permissions
- Configure storage credentials
- Manage external locations
- Audit data access

**When to Assign:**
- Assign to data governance teams
- Typically responsible for data security and compliance
- Should be limited to users who need to manage data governance

## Custom Roles (Enterprise Tier)

In the Enterprise tier, you can create custom roles with specific permissions. Custom roles allow for more granular access control and can be tailored to your organization's specific needs.

**Example Custom Roles:**
- **Cluster Manager:** Can create and manage clusters but cannot access notebooks
- **Job Scheduler:** Can create and manage jobs but cannot create clusters
- **Read-Only Analyst:** Can view notebooks and dashboards but cannot modify them
- **Data Steward:** Can manage data access permissions but cannot create resources

## Permission Matrix

| Permission | ACCOUNT_ADMIN | ACCOUNT_USER | WORKSPACE_ADMIN | WORKSPACE_USER | METASTORE_ADMIN |
|------------|---------------|--------------|-----------------|----------------|-----------------|
| Manage Account Settings | ✓ | - | - | - | - |
| Create Workspaces | ✓ | - | - | - | - |
| Manage Account Users | ✓ | - | - | - | - |
| View Account Console | ✓ | ✓ | - | - | ✓ |
| Manage Workspace Settings | ✓ | - | ✓ | - | - |
| Create Clusters | ✓ | - | ✓ | Configurable | - |
| Manage Instance Pools | ✓ | - | ✓ | - | - |
| Manage Workspace Users | ✓ | - | ✓ | - | - |
| Create Notebooks | ✓ | - | ✓ | ✓ | - |
| Run Jobs | ✓ | - | ✓ | Configurable | - |
| Manage Secrets | ✓ | - | ✓ | - | - |
| Manage Metastore | ✓ | - | - | - | ✓ |
| Manage Data Permissions | ✓ | - | - | - | ✓ |

## Role Assignment Best Practices

1. **Principle of Least Privilege:**
   - Assign the minimum level of access required for users to perform their job functions
   - Regularly review and audit role assignments

2. **Role Separation:**
   - Separate administrative roles from regular user roles
   - Implement segregation of duties for sensitive operations

3. **Group-Based Assignment:**
   - Assign roles to groups rather than individual users
   - Use groups to represent functional teams or projects

4. **Documentation:**
   - Document role assignments and justifications
   - Maintain an up-to-date inventory of administrative users

5. **Regular Review:**
   - Periodically review role assignments
   - Remove unnecessary privileges when they are no longer needed

## Certification Exam Tips

- Understand the hierarchy of built-in roles
- Know the key permissions associated with each role
- Be familiar with best practices for role assignment
- Understand how to create and manage custom roles (Enterprise tier)
- Know how to audit and review role assignments

## Next Steps

- Review the `custom_role_template.json` for examples of custom role definitions
- Explore `workspace_access_modes.md` for information on workspace access control
- See `object_permissions_matrix.md` for details on object-level permissions
