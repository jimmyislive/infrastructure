# End to End Infrastructure setup

This terraform script will set up an end-to-end infrastructure set up which you can use for most projects.

It comprises of:
 * A VPC
 * One public subnet
 * Two private subnets
 * Associated security groups, routing tables etc
 * EC2 instance in the public subnet
 * RDS instance in the private subnet
 * ElastiCache cluster in the private subnet
 * SNS topics and their subscriptions
 * Elastic IP attached to EC2 instance
 
## Steps

1. Clone this repo
2. Fill in values for variables in terraform.tfvars and creds.sh
3. `source creds.sh`
4. `terraform get`
5. `terraform plan`
     This will do a dry-run and show you all the resources that will get created.
6. `terraform apply`
     This actually creates the resources mentioned in step (4)
     
*NOTE*: The sns topics are subscribed to by lambda functions which are not included in this terraform script.
        It should be a simple enhancement to this script or you can create it manually.
        
## Access

After 'terraform apply' runs succesfully, you can get the following info:
 
 `terraform output aws_eip_web_ip` - elastic ip of EC2 instance
 `terraform output aws_db_instance_address` - address of rds instance
 `terraform output aws_elasticache_cluster_node_address` - address of node in redis cluster
 
### To log into your instance:

  `ssh -i ~/.ssh/id_rsa ubuntu@<ip address from previous step>`
  
  *NOTE*: The ~/.ssh/id_rsa should correspond to the public key you specified in your terraform.tfvars file
   
### To connect to rds from your EC2 instance 
  *NOTE*: Assuming you have the psql libs installed in the base image which this instance was derived from    
          Since it is in a private subnet you cannot connect to it from the internet. 
          Log into your EC2 instance first and then
    
   `psql -h <rds address> -U master_user -d master_db`
   
### To connect to the redis elasti cache instance:

  SSH into EC2 and then do:
    
  `redis-cli -h <redis host address from previous step>`

## Destroy

Once you are done, if you want to tear everything down:

  `terraform destroy`
