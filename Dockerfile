FROM centos
COPY . /argo
WORKDIR /argo
ENTRYPOINT ["/bin/bash", "/argo/upgrade-konvoy.sh"]

