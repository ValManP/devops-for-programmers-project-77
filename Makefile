init:
	terraform -chdir=terraform init -backend-config=secrets.backend.tfvars

validate:
	terraform -chdir=terraform validate

plan:
	terraform -chdir=terraform plan

apply:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

edit-vault:
	ansible-vault edit --vault-password-file ansible/vault-password ansible/group_vars/all/vault.yml

generate-vars:
	ansible-playbook --vault-password-file ansible/vault-password ansible/terraform.yml

install:
	ansible-galaxy install -r ansible/requirements.yml

deploy:
	ansible-playbook -i ansible/inventory.ini -v --vault-password-file ansible/vault-password ansible/playbook.yml
