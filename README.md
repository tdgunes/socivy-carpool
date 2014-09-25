socivy-carpool
==============
**We are making world a better place!**

--- 

##Deploy

In order to deploy the web app to the server, please follow these steps:

 1. Make sure you have the [RSAKEYFILE].pem, which is placed as ~/.ssh/[RSAKEYFILE].pem, and `ssh-add ~/.ssh/aws-demo.pem` is executed.
 2. Install the requirements, with `sudo pip install -r requirements.txt`, if you don't have pip, write `sudo easy_install pip`
 3. After the installation of fabric, execute `fab deploy` 




