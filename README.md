# Born to be Wild

Rozpoczynamy zabawę w tworzenie vmek na aws w celu utworzenia CICD w oparciu o najnowsze technologie devops. Poniżej graph prezentujący wstępne założenia:

```mermaid
flowchart LR
A[wordpress] --> B[.git local]
B --> C[Azure DevOps]
B --> D[Github as backup]
end
A --> G[Dockerfile]
G --> H[Image]
subgraph CD
H --> I[Azure Container Registries Release]
H --> L[docker hub public release]
end
N --> H
```

aws hosting cicd

dzień trzeci, stawiamy jenkinsa. commit....
testujemy commita2.....
STWORZYC DOCKERFILE -> WGRAC DOCKERFILE NA REPO NASZE -> OD STRONY JENKINSA ZROBIC CI (INTEGRACJA GH Z JENKINSEM - zrobione) I CD (POSTAWIENIE KONTENERA NA BAZIE NASZEGO DOCKERFILE)

dalsze testy i kroki....
dalej dalej....
