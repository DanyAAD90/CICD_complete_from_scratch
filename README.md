# Born to be Wild
Rozpoczynamy zabawę w tworzenie vmek na aws w celu utworzenia CICD w oparciu o najnowsze technologie devops. Poniżej graph prezentujący wstępne założenia:

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
## Tworzenie instancji na AWS
Dane techniczne free tier eligible
```
AMI = ami-07d9b9ddc6cd8dd30
instance type = t2.micro
key pair = aws_hosting
security group = vpc-0bb5a3a12797eabae (launch-wizard-1)
volumes = storage 8GiB
```


aws hosting cicd

dzień trzeci, stawiamy jenkinsa. commit....
testujemy commita2.....
STWORZYC DOCKERFILE -> WGRAC DOCKERFILE NA REPO NASZE -> OD STRONY JENKINSA ZROBIC CI (INTEGRACJA GH Z JENKINSEM - zrobione) I CD (POSTAWIENIE KONTENERA NA BAZIE NASZEGO DOCKERFILE)

dalsze testy i kroki....
dalej dalej....
