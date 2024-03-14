# Born to be Wild

Rozpoczynamy zabawę w tworzenie vmek na aws w celu utworzenia CICD w oparciu o najnowsze technologie devops. Poniżej graph prezentujący wstępne założenia:

```mermaid
flowchart LR
A[wordpress] --> G[node exporter]
Z[AWS] --> A
Z --> K
Z --> I
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

aws hosting cicd

dzień trzeci, stawiamy jenkinsa. commit....
testujemy commita2.....
STWORZYC DOCKERFILE -> WGRAC DOCKERFILE NA REPO NASZE -> OD STRONY JENKINSA ZROBIC CI (INTEGRACJA GH Z JENKINSEM - zrobione) I CD (POSTAWIENIE KONTENERA NA BAZIE NASZEGO DOCKERFILE)

dalsze testy i kroki....
dalej dalej....
