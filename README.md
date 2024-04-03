# Born to be Wild
Realizacja wykonania kompletnego CICD od podstaw.

```mermaid
flowchart LR
A[wordpress] --> G[node exporter]
Z[AWS] --> X[terraform]
X --> A
X --> K
X --> J
subgraph CI
A --> O[git local]
O --> P[git push]
P --> K[jenkins]
K --> L[pipeline]
L --> N[erase old and paste new repo git]
N --> A
end
subgraph Monitoring
G --> H[prometheus]
H --> I[grafana]
I --> J[dashboard cpu ram]
end
A --> D[docker-compose]
D --> E[Image]
subgraph CD
E --> F[docker hub public release]
end
```
### Konfiguracja instancji aws_wordpress_tf
instalacja skryptów w folderze /wordpress:
```
install.sh
docker-compose.yml
```
### Konfiguracja instancji aws_jenkins_tf
instalacja skryptów:
```
skrypt
```
### Konfiguracja instancji aws_grafana_tf
instalacja skryptów:
```
skrypt
```
### Automatyzacja tworzenia instancji Terraform
Dane techniczne free tier eligible potrzebne do skonstruowania main.ft:
```
AMI = ami-07d9b9ddc6cd8dd30
instance type = t2.micro
key pair = aws_hosting
security group = vpc-0bb5a3a12797eabae (launch-wizard-1)
volumes = storage 8GiB
```
zmienne w main.tf znajdują się w terraform.tfvars.
## MFA
Instalacja na terraform oraz aws cli. \
Skonfigurowanie IAM, grupy, usera na koncie AWS. \
Konfiguracja pliku config w ~/.aws/config. \
Logowanie do konta aws:
```
cd ~/.aws/
aws sso login --profile default
```
oraz sprawdzenie, czy widoczne są instancje:
```
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress]'
```
Dodanie usera ubuntu do root:
```
sudo usermod -aG root ubuntu
sudo reboot
```
Uruchomienie procesu automatyzacji:
```
cd ~/terraform
terraform init
terraform plan -lock=false
terraform apply -lock=false
```
Do usuwania zasobów:
```
terraform destroy -lock=false
```
jednakże to nie działa na aws.
Automat zwraca public_dns oraz public_ip utworzonych instancji.

## Instalacja Wordpress za pomocą Ansible-Galaxy
należy zedytować poniższe pliki:
```
1. /roles/server/tasks/main.yml
2. /roles/php/tasks/main.yml
3. /roles/mysql/defaults/main.yml
4. /roles/mysql/tasks/main.yml
5. /roles/wordpress/tasks/main.yml
6. /roles/wordpress/handlers/main.yml
```
próba wejscia
```
ansible-playbook -i 1.2.3.4, --private-key /home/ubuntu/tf_provisioning/aws_hosting.pem /home/ubuntu/tf_provisioning/wordpress/playbook.yaml
```
### Proces instalacji Wordpress
Terraform kopiuje i za pomocą scp wkleja plik preintall.sh na nowo utworzoną maszynę. Wykonuje na niej wstępne konfiguracjie, w tym dodaje bazy mysql usera ubuntu do uwierzytelnienia w bazach danych. Następnie wykonywany jest playbook.yml który uruchamia usługę.

## Problemy
W przeglądarce pod adresem
```
http://1.2.3.4/wp-admin/install.php
```
witnieje tylko 404 oraz serwer apache nie jest dostępny.

notatki:
```
aws hosting cicd

dzień trzeci, stawiamy jenkinsa. commit....
testujemy commita2.....
STWORZYC DOCKERFILE -> WGRAC DOCKERFILE NA REPO NASZE -> OD STRONY JENKINSA ZROBIC CI (INTEGRACJA GH Z JENKINSEM - zrobione) I CD (POSTAWIENIE KONTENERA NA BAZIE NASZEGO DOCKERFILE)

dalsze testy i kroki....
dalej dalej....
```

