all: newkey gensecret addsshkey deploy

addsshkey:
	kubectl create -f secret.yaml

deploy:
	kubectl apply -f jumpserver-service.yaml
	kubectl apply -f jumpserver-deployment.yaml

remove:
	kubectl delete -f jumpserver-service.yaml
	kubectl delete -f jumpserver-deployment.yaml

newkey:
	rm -f sshkeys/id_rsa*
	ssh-keygen -q -f sshkeys/id_rsa -N '' -t rsa

eKEY := $(shell cat sshkeys/id_rsa.pub |base64 -w 0 |  tr -d \\n)

gensecret:
	sed 's^PUBLIC_KEY^'"${eKEY}"'^' secret.yaml.tmpl > secret.yaml

.PHONY: newkey gensecret addsshkey deploy remove
