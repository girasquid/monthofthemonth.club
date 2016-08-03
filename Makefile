all:
	terraform plan -state=terraform/terraform.tfstate -var-file=terraform/terraform.tfvars terraform/
apply:
	terraform apply -state=terraform/terraform.tfstate -var-file=terraform/terraform.tfvars terraform/
clean:
	terraform destroy -state=terraform/terraform.tfstate -var-file=terraform/terraform.tfvars terraform/
