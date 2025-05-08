# Databricks Authentication Methods

This document provides an overview of the authentication methods available in Databricks and guidance on when to use each method.

## Available Authentication Methods

### 1. Username/Password Authentication

**Description:**
- Default authentication method
- Users log in with email address and password
- Passwords must meet complexity requirements

**Configuration:**
- Enabled by default
- Can be disabled if SSO is configured
- Password policies can be configured at the account level

**Best For:**
- Small teams or proof-of-concept deployments
- Environments without an existing identity provider
- Testing and development environments

**Limitations:**
- Manual user management
- No centralized identity management
- Limited security features compared to SSO

### 2. SAML Single Sign-On (SSO)

**Description:**
- Integration with external identity providers using SAML 2.0
- Users authenticate through their organization's identity provider
- Supports major identity providers like Azure AD, Okta, OneLogin, etc.

**Configuration:**
- Requires configuration in both Databricks and the identity provider
- Can be configured at the account level
- Supports just-in-time user provisioning

**Best For:**
- Enterprise environments
- Organizations with existing identity providers
- Environments requiring enhanced security
- Compliance with security policies

**Advantages:**
- Centralized user management
- Enhanced security with MFA through IdP
- Simplified user experience (single sign-on)
- Automated user provisioning and deprovisioning

### 3. OAuth 2.0

**Description:**
- Authentication using OAuth 2.0 protocol
- Primarily used for API access and integrations
- Supports token-based authentication

**Configuration:**
- Configure OAuth applications in the account console
- Define scopes and permissions
- Generate client credentials

**Best For:**
- API integrations
- Automated workflows
- Service-to-service authentication
- CI/CD pipelines

**Limitations:**
- Not typically used for end-user authentication
- Requires careful management of tokens and secrets

## Authentication Method Selection Guide

| Factor | Username/Password | SAML SSO | OAuth 2.0 |
|--------|-------------------|----------|-----------|
| Ease of Setup | High | Medium | Medium |
| Security | Basic | High | High |
| User Experience | Basic | Excellent | N/A (for services) |
| Centralized Management | No | Yes | N/A |
| MFA Support | Limited | Yes (via IdP) | N/A |
| Audit Capabilities | Basic | Advanced | Advanced |
| Automation Potential | Low | High (with SCIM) | High |

## Implementation Recommendations

### For Small Teams or POCs:
- Start with username/password authentication
- Consider migrating to SSO as the team grows

### For Enterprise Environments:
- Implement SAML SSO from the beginning
- Configure SCIM provisioning for user synchronization
- Use OAuth for service accounts and API integrations

### For Hybrid Environments:
- Configure both SSO and username/password authentication during transition
- Gradually migrate users to SSO
- Set a deadline for full SSO migration

## Certification Exam Tips

- Know how to configure each authentication method
- Understand the security implications of each method
- Be familiar with the integration points between Databricks and identity providers
- Know how to troubleshoot authentication issues
- Understand how authentication methods interact with workspace access control

## Next Steps

- Review `sso_configuration.md` for detailed steps on setting up SAML SSO
- Explore `scim_configuration.md` for user provisioning automation
- See `token_management.md` for best practices on managing access tokens
