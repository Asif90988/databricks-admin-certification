# SAML SSO Configuration Guide for Databricks

This guide provides step-by-step instructions for configuring SAML Single Sign-On (SSO) between Databricks and your identity provider (IdP).

## Prerequisites

- Administrator access to your Databricks account
- Administrator access to your identity provider (Azure AD, Okta, OneLogin, etc.)
- Basic understanding of SAML 2.0 concepts
- SSL certificate for SAML signing (if required by your IdP)

## Configuration Process Overview

1. Gather information from Databricks for your IdP
2. Configure SAML application in your IdP
3. Gather information from your IdP for Databricks
4. Configure SAML in Databricks account console
5. Test the SSO integration
6. Configure user provisioning (optional)

## Detailed Configuration Steps

### Step 1: Gather Information from Databricks

1. Log in to the Databricks account console
2. Navigate to **Settings** > **Security** > **SAML SSO**
3. Note the following information:
   - **Relay State**: `https://accounts.cloud.databricks.com`
   - **ACS URL**: `https://accounts.cloud.databricks.com/saml/acs`
   - **Entity ID**: `https://accounts.cloud.databricks.com`
   - **SAML Request Binding**: HTTP-POST
   - **Name ID Format**: Email Address

### Step 2: Configure SAML Application in Your IdP

#### For Azure AD:

1. Log in to the Azure portal
2. Navigate to **Azure Active Directory** > **Enterprise applications** > **New application**
3. Search for "Databricks" in the gallery or select **Create your own application**
4. Configure the application with the information from Step 1
5. Set up user attributes and claims:
   - **Name ID**: user.mail or user.userprincipalname
   - **First Name**: user.givenname
   - **Last Name**: user.surname
   - **Email**: user.mail
6. Assign users and groups to the application

#### For Okta:

1. Log in to the Okta admin console
2. Navigate to **Applications** > **Applications** > **Add Application**
3. Search for "Databricks" or select **Create New App** > **SAML 2.0**
4. Configure the application with the information from Step 1
5. Set up attribute statements:
   - **Name ID**: user.email
   - **firstName**: user.firstName
   - **lastName**: user.lastName
   - **email**: user.email
6. Assign the application to users and groups

#### For OneLogin:

1. Log in to the OneLogin admin portal
2. Navigate to **Applications** > **Add App**
3. Search for "Databricks" or select **Custom Connector** > **SAML**
4. Configure the application with the information from Step 1
5. Set up attribute mappings:
   - **Name ID**: Email
   - **First Name**: First Name
   - **Last Name**: Last Name
   - **Email**: Email
6. Assign the application to users and groups

### Step 3: Gather Information from Your IdP

After configuring the application in your IdP, collect the following information:

- **SAML SSO URL**: The endpoint where Databricks will send SAML requests
- **Issuer URL**: The entity ID of your IdP
- **X.509 Certificate**: The public certificate used to verify SAML responses

### Step 4: Configure SAML in Databricks

1. Return to the Databricks account console
2. Navigate to **Settings** > **Security** > **SAML SSO**
3. Enable SAML SSO
4. Enter the information collected from your IdP:
   - **SAML SSO URL**
   - **Issuer URL**
   - **X.509 Certificate**
5. Configure additional settings:
   - **Sign SAML Requests**: Recommended to enable
   - **Require Encrypted Assertions**: Optional but recommended
   - **Enable Just-in-Time User Provisioning**: Enable to automatically create users on first login
6. Save the configuration

### Step 5: Test the SSO Integration

1. Create a test user in your IdP and assign the Databricks application
2. Click the **Test SSO** button in the Databricks account console
3. Verify that you can successfully authenticate through your IdP
4. Check that user attributes are correctly mapped

### Step 6: Configure User Provisioning (Optional)

For automated user provisioning, configure SCIM integration:

1. Navigate to **Settings** > **User Provisioning**
2. Enable SCIM provisioning
3. Generate a SCIM token
4. Configure SCIM in your IdP using the token and SCIM endpoint
5. Test user provisioning by creating a new user in your IdP

## Troubleshooting Common Issues

### SAML Response Validation Failed

- Verify the X.509 certificate is correctly configured
- Check that the Issuer URL matches exactly
- Ensure the Name ID format is set to Email Address

### User Cannot Access Databricks After Authentication

- Verify the user is assigned to the application in your IdP
- Check that the user has the appropriate role in Databricks
- Ensure Just-in-Time provisioning is enabled if the user doesn't exist in Databricks

### Attributes Not Mapping Correctly

- Verify attribute mappings in your IdP configuration
- Check SAML response for correct attribute names and formats
- Ensure required attributes are included in the SAML assertion

## Best Practices

- Test SSO configuration with a limited set of users before full deployment
- Configure a backup administrator account with username/password authentication
- Regularly rotate the SCIM token if using automated provisioning
- Monitor SSO login attempts for potential issues
- Document your SSO configuration for future reference

## Certification Exam Tips

- Understand the SAML authentication flow
- Know how to configure SAML SSO in Databricks
- Be familiar with common IdP integrations (Azure AD, Okta, OneLogin)
- Understand the relationship between SSO and user provisioning
- Know how to troubleshoot common SSO issues

## Next Steps

- Configure SCIM provisioning using the `scim_configuration.md` guide
- Set up role-based access control for SSO users
- Implement MFA through your identity provider
