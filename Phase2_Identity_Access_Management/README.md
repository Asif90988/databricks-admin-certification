# Phase 2: Identity & Access Management

This phase focuses on configuring authentication and authorization for your Databricks environment. Proper identity and access management is crucial for securing your Databricks deployment and ensuring users have appropriate access to resources.

## Learning Objectives

By the end of this phase, you will be able to:
- Configure authentication methods for Databricks
- Set up user and group management
- Implement role-based access control
- Configure SCIM provisioning for user synchronization
- Understand and implement workspace access control
- Manage personal access tokens

## Prerequisites

- Completed Phase 1: Account & Workspace Administration
- Access to your Databricks account console and workspace
- (Optional) Access to an identity provider (IdP) like Azure AD, Okta, or OneLogin

## Step 1: Authentication Configuration

1. **Authentication Methods Overview**:
   - Understand the available authentication methods:
     - Username/password (default)
     - SAML single sign-on (SSO)
     - OAuth 2.0
   - Review the authentication configuration options in `authentication_methods.md`

2. **Configure SSO (Optional but Recommended)**:
   - Follow the steps in `sso_configuration.md` to set up SAML SSO
   - Configure your identity provider using the provided templates
   - Test SSO authentication

## Step 2: User and Group Management

1. **Manual User Management**:
   - Create users in the account console
   - Assign appropriate roles to users
   - Configure user properties and settings
   - Use the `user_management_template.csv` for bulk user creation

2. **Group Management**:
   - Create groups in the account console
   - Add users to groups
   - Understand group hierarchy and inheritance
   - Use the `group_structure_template.json` for planning your group structure

3. **SCIM Provisioning (Optional)**:
   - Configure SCIM integration with your identity provider
   - Set up user and group synchronization
   - Test SCIM provisioning
   - Follow the steps in `scim_configuration.md`

## Step 3: Role-Based Access Control

1. **Understanding Databricks Roles**:
   - Review the built-in roles and their permissions
   - Understand the role hierarchy
   - See `databricks_roles.md` for detailed role descriptions

2. **Custom Roles (Enterprise Tier)**:
   - Create custom roles with specific permissions
   - Assign custom roles to users and groups
   - Use the `custom_role_template.json` for defining custom roles

3. **Role Assignment**:
   - Assign roles at the account level
   - Assign roles at the workspace level
   - Understand role inheritance and precedence

## Step 4: Workspace Access Control

1. **Workspace Access Modes**:
   - Configure workspace access control settings
   - Understand the differences between:
     - User isolation mode
     - Shared access mode
     - Custom access mode
   - See `workspace_access_modes.md` for details

2. **Object-Level Permissions**:
   - Configure permissions for notebooks, dashboards, and other objects
   - Implement permission inheritance
   - Use the `object_permissions_matrix.md` for reference

## Step 5: Token Management

1. **Personal Access Tokens**:
   - Configure token lifetime and policies
   - Create and manage personal access tokens
   - Implement token rotation practices
   - See `token_management.md` for best practices

2. **OAuth Application Management**:
   - Register OAuth applications
   - Configure OAuth scopes and permissions
   - Manage OAuth tokens

## Best Practices

- Implement the principle of least privilege
- Use groups for permission management rather than individual users
- Implement SSO for enhanced security and user experience
- Regularly audit user access and permissions
- Implement token rotation policies
- Document your identity and access management configuration

## Certification Exam Tips

- Understand the differences between authentication methods
- Know how to configure SAML SSO
- Be familiar with SCIM provisioning
- Understand the built-in roles and their permissions
- Know how to configure workspace access control
- Be familiar with token management and policies

## Templates and Resources

This directory contains the following templates and resources:
- `authentication_methods.md`: Overview of authentication methods
- `sso_configuration.md`: Step-by-step guide for SSO configuration
- `user_management_template.csv`: Template for bulk user creation
- `group_structure_template.json`: Template for planning group structure
- `scim_configuration.md`: Guide for SCIM provisioning
- `databricks_roles.md`: Description of built-in roles
- `custom_role_template.json`: Template for custom role definition
- `workspace_access_modes.md`: Description of workspace access modes
- `object_permissions_matrix.md`: Reference for object-level permissions
- `token_management.md`: Best practices for token management

## Next Steps

Once you've completed this phase, proceed to [Phase 3: Cluster & Compute Management](../Phase3_Cluster_Compute_Management/README.md) to learn how to configure and manage Databricks clusters.
