
# your environment
env = "dev"
# aws account number (used while creating topics for sns)
account_num="1234567"
# ami id you want to base your EC2 instance off
ami_id="ami-xxxxxxxx"
# which port will your app server running on EC2 be listening to
web_port="9080"
# probably your laptop rsa key so that you can easily ssh into EC2
key_rsa_pub = "ssh-rsa xxxxxxx"
# what cidr ranges whould your vpc comprise off
vpc_cidr = "10.0.0.0/16"
# cidr of private subnet1
subnet_private1_cidr = "10.0.32.0/20"
# cidr of private subnet2
subnet_private2_cidr = "10.0.16.0/20"
# cidr of public subnet
subnet_public_cidr = "10.0.0.0/20"
# cidr for the world
allow_all_cidr = "0.0.0.0/0"
# rds master db name
master_db_name = "master_db"
# rds master username
master_username = "master_user"
# rds master password
master_password = "master_pass"

