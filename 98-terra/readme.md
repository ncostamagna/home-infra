# Run 
```sh
cd 98-terra                                           
rm -rf .terraform .terraform.lock.hcl
TFENV_ARCH=arm64 terraform init
terraform plan 
```