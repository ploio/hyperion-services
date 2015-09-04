# Hyperion services

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Description

Services to be deployed to [Hyperion][]

Setup your kubernetes master IP :

        $ export K8S_MASTER=x.x.x.x

### Kubernetes UI

    $ kubectl -s $K8S_MASTER:8080 create -f kube-ui/kube-ui-rc.yaml --namespace=kube-system
    $ kubectl -s $K8S_MASTER:8080 create -f -f kube-ui/kube-ui-svc.yaml --namespace=kube-system

    $ kubectl -s $K8S_MASTER:8080 get services --namespace=kube-system
    NAME      LABELS                                                                         SELECTOR          IP(S)           PORT(S)
    kube-ui   k8s-app=kube-ui,kubernetes.io/cluster-service=true,kubernetes.io/name=KubeUI   k8s-app=kube-ui   10.254.254.34   80/TCP

    $ kubectl -s $K8S_MASTER:8080 get rc --namespace=kube-system
    CONTROLLER   CONTAINER(S)   IMAGE(S)                                SELECTOR                     REPLICAS
    kube-ui-v1   kube-ui        gcr.io/google_containers/kube-ui:v1.1   k8s-app=kube-ui,version=v1   1

    $ kubectl -s $K8S_MASTER:8080 get pods --namespace=kube-system
    NAME               READY     STATUS    RESTARTS   AGE
    kube-ui-v1-8l52b   1/1       Running   0          8m

    $ kubectl -s $K8S_MASTER:8080 cluster-info
    Kubernetes master is running at x.x.x.x:8080
    KubeUI is running at x.x.x.x:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui

## Logging

    $ kubectl -s $K8S_MASTER:8080 create -f logging/es-controller.yaml --namespace=kube-system
    $ kubectl -s $K8S_MASTER:8080 create -f logging/es-service.yaml --namespace=kube-system

    $ kubectl -s $K8S_MASTER:8080 get rc --namespace=kube-system
    CONTROLLER                 CONTAINER(S)            IMAGE(S)                                     SELECTOR                                   REPLICAS
    elasticsearch-logging-v1   elasticsearch-logging   gcr.io/google_containers/elasticsearch:1.7   k8s-app=elasticsearch-logging,version=v1   2
    kube-ui-v1                 kube-ui                 gcr.io/google_containers/kube-ui:v1.1        k8s-app=kube-ui,version=v1                 1

    $ kubectl -s $K8S_MASTER:8080 get services --namespace=kube-system
    NAME                    LABELS                                                                                              SELECTOR                        IP(S)           PORT(S)
    elasticsearch-logging   k8s-app=elasticsearch-logging,kubernetes.io/cluster-service=true,kubernetes.io/name=Elasticsearch   k8s-app=elasticsearch-logging   10.254.103.37   9200/TCP
    kube-ui                 k8s-app=kube-ui,kubernetes.io/cluster-service=true,kubernetes.io/name=KubeUI                        k8s-app=kube-ui                 10.254.254.34   80/TCP

    $ kubectl -s $K8S_MASTER:8080 get pods --namespace=kube-system
    NAME                             READY     STATUS    RESTARTS   AGE
    elasticsearch-logging-v1-2tl02   0/1       Pending   0          2m
    elasticsearch-logging-v1-xzvns   0/1       Pending   0          2m
    kube-ui-v1-8l52b                 1/1       Running   0          34m

    $ kubectl -s $K8S_MASTER:8080 cluster-info
    Kubernetes master is running at 10.33.1.174:8080
    Elasticsearch is running at 10.33.1.174:8080/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging
    KubeUI is running at 10.33.1.174:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui


### Monitoring

    $ kubectl -s $K8S_MASTER:8080 create --namespace=admin -f heapster/influxdb-grafana-controller.json
    $ kubectl -s $K8S_MASTER:8080 create --namespace=admin -f heapster/heapster-controller.json
    $ kubectl -s $K8S_MASTER:8080 --namespace=admin get pods
    NAME                                         READY     STATUS    RESTARTS   AGE
    monitoring-influx-grafana-controller-hc0uh   2/2       Running   0          4m


### Kubedash

    $ kubectl -s $K8S_MASTER:8080 create -f kubedash/kube-ui-rc.yaml --namespace=kube-system
    $ kubectl -s $K8S_MASTER:8080 create -f -f kubedash/kube-ui-svc.yaml --namespace=kube-system




## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[Hyperion]: https://github.com/portefaix/hyperion
[LICENSE]: https://github.com/portefaix/hyperion/blob/master/LICENSE
[Issue tracker]: https://github.com/portefaix/hyperion/issues

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/nlamirault/hyperion.svg
