###Email Verifcation Code

This module is currnetly using null resource to run aws cli commands to verify an email and ad a policy to protect the email. There are terraform resoruces currently in development to support this feature. At the moment you have to passin the aws profile. 

### The Verification
If the email you are verifying is not going to be a real mailbox, instead you are going to use the forwarder you need to make sure that your email is included in the SES recipt rule as part of the forwarder module. 

### The Error
Part of this code is putting an policy wrap around the email, this can only happen when the email is verified, when you run the code you will get an error stating the email must be verified, so go and verify it via the email you get and run the code again. 


### The Terraform Work
https://github.com/terraform-providers/terraform-provider-aws/pull/6575
https://github.com/terraform-providers/terraform-provider-aws/pull/5128



<!--- BEGIN_TF_DOCS --->
## Providers



## Inputs



## Outputs


<!--- END_TF_DOCS --->
