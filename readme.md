### Description

This crypto trading bot automatically trades cryptocurrencies in Bittrex using the Bittrex API.  The algorithm, found in index.php, searches CoinMarketCap for the top 50 market capitalized coins, and if the volatility is between -4% and 4% for the last week, buy it with 1/50 of your Bittrex balance a maximum of 4 times, once a day at 3pm PST.  The server, a free t2.micro Amazon Linux instance, is created in the us-west-2 region, along with a security group to allow HTTP and SSH access to the instace.

### How to run

1) Install terraform, and set your environment variables path to the location of terraform.exe i.e. C:\Program Files\terraform_0.9.5_windows_amd64

   https://www.terraform.io/downloads.html <br></br>
   https://www.computerhope.com/issues/ch000549.htm

2) Create a new key pair in AWS in the us-west-2 region.  Download the .pem file and place it in this directory.  Convert the .pem file into a .ppk file for accessing the instance later, if you feel you will need to.  Only the .pem key is required though.

   http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html <br></br>
   http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html

3) Create an AWS IAM group that has Administrator access, and add your root IAM user to that account

   http://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html

4) Insert your AWS access key and secret key into main.tf at the top of the file

   http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys

5) Insert your bittrex api key and secret key into index.php at the top of the file

6) Put your key pair name (without the extension) into main.tf for the key_name variable, and add the same key name (with the extension i.e. xxx.pem) for both the private_key variables.

7) Open Powershell, or another shell, and cd into the location of the folder where you've cloned this repo
```
cd C:\Users\athompson\Desktop\bittrex
```

8) Run 
```
terraform apply
```

* Note - to manually invoke index.php, which executes the trades, you can browse http://serverpublicip/index.php, or run
```
curl http://serverpublicip/index.php
```

* Also, the Amazon Linux instance which is created has its clock set to UTC time, so this will create a cron job at 10:00 UTC, or 3 am PST.