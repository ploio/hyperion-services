# Hyperion services

[![License Apache 2][badge-license]][LICENSE][]
![Version][badge-release]

## Configuration

You could use [Docker compose][] to setup a local cluster :

		$ docker-composer up -d
		Creating hyperionservices_etcd_1
		Creating hyperionservices_apiserver_1
		Creating hyperionservices_kubelet_1
		Creating hyperionservices_controller_1
		Creating hyperionservices_proxy_1
		Creating hyperionservices_scheduler_1

		$ docker-compose ps


Then, configure `kubectl`: 

		$ kubectl config set-cluster hyperion --server=http://127.0.0.1:8080
		$ kubectl config set-context hyperion --server=hyperion

Check cluster :

		$ kubectl version
		Client Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.3", GitCommit:"61c6ac5f350253a4dc002aee97b7db7ff01ee4ca", GitTreeState:"clean"}
		Server Version: version.Info{Major:"1", Minor:"1+", GitVersion:"v1.1.1-beta.1", GitCommit:"d3071cbd760a8f8650ff379398c59e71ffcf7085", GitTreeState:"clean"}

Creates namespaces :

        $ kubectl create -f namespaces/namespace-admin.json
        $ kubectl create -f namespaces/namespace-dev.json
        $ kubectl create -f namespaces/namespace-prod.json

        $ kubectl get namespaces
        NAME          LABELS             STATUS
        default       <none>             Active
        development   name=development   Active
        kube-system   name=kube-system   Active
        production    name=production    Active


## Description

Services to be deployed to [Hyperion][]

### Kubernetes UI

    $ kubectl create -f kube-ui/kube-ui-rc.yaml --namespace=kube-system
    $ kubectl create -f kube-ui/kube-ui-svc.yaml --namespace=kube-system

    $ kubectl get services --namespace=kube-system
    NAME      LABELS                                                                         SELECTOR          IP(S)           PORT(S)
    kube-ui   k8s-app=kube-ui,kubernetes.io/cluster-service=true,kubernetes.io/name=KubeUI   k8s-app=kube-ui   10.254.254.34   80/TCP

    $ kubectl get rc --namespace=kube-system
    CONTROLLER   CONTAINER(S)   IMAGE(S)                                SELECTOR                     REPLICAS
    kube-ui-v1   kube-ui        gcr.io/google_containers/kube-ui:v1.1   k8s-app=kube-ui,version=v1   1

    $ kubectl get pods --namespace=kube-system
    NAME               READY     STATUS    RESTARTS   AGE
    kube-ui-v1-8l52b   1/1       Running   0          8m

    $ kubectl cluster-info
    Kubernetes master is running at x.x.x.x:8080
    KubeUI is running at x.x.x.x:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui

## Logging

    $ kubectl create -f logging/es-controller.yaml --namespace=kube-system
    $ kubectl create -f logging/es-service.yaml --namespace=kube-system

    $ kubectl get rc --namespace=kube-system
    CONTROLLER                 CONTAINER(S)            IMAGE(S)                                     SELECTOR                                   REPLICAS
    elasticsearch-logging-v1   elasticsearch-logging   gcr.io/google_containers/elasticsearch:1.7   k8s-app=elasticsearch-logging,version=v1   2
    kube-ui-v1                 kube-ui                 gcr.io/google_containers/kube-ui:v1.1        k8s-app=kube-ui,version=v1                 1

    $ kubectl get services --namespace=kube-system
    NAME                    LABELS                                                                                              SELECTOR                        IP(S)           PORT(S)
    elasticsearch-logging   k8s-app=elasticsearch-logging,kubernetes.io/cluster-service=true,kubernetes.io/name=Elasticsearch   k8s-app=elasticsearch-logging   10.254.103.37   9200/TCP
    kube-ui                 k8s-app=kube-ui,kubernetes.io/cluster-service=true,kubernetes.io/name=KubeUI                        k8s-app=kube-ui                 10.254.254.34   80/TCP

    $ kubectl get pods --namespace=kube-system
    NAME                             READY     STATUS    RESTARTS   AGE
    elasticsearch-logging-v1-2tl02   0/1       Pending   0          2m
    elasticsearch-logging-v1-xzvns   0/1       Pending   0          2m
    kube-ui-v1-8l52b                 1/1       Running   0          34m

    $ kubectl cluster-info
    Kubernetes master is running at 10.33.1.174:8080
    Elasticsearch is running at 10.33.1.174:8080/api/v1/proxy/namespaces/kube-system/services/elasticsearch-logging
    KubeUI is running at 10.33.1.174:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui


### Monitoring

    $ kubectl create --namespace=admin -f heapster/influxdb-grafana-controller.json
    $ kubectl create --namespace=admin -f heapster/heapster-controller.json
    $ kubectl --namespace=admin get pods
    NAME                                         READY     STATUS    RESTARTS   AGE
    monitoring-influx-grafana-controller-hc0uh   2/2       Running   0          4m

### Heapster

	$ kubectl create -f heapster/heapster-service.yaml --namespace=kube-system
	$ kubectl create -f heapster/heapster-controller.yaml --namespace=kube-system
	
	$ kubectl get pods --namespace=kube-system
	NAME               READY     STATUS    RESTARTS   AGE
	heapster-uf1u6     1/1       Running   0          3m
	kube-ui-v1-5gz0m   1/1       Running   0          40m
	
	$ kubectl get rc --namespace=kube-system                                                                                   
	CONTROLLER   CONTAINER(S)   IMAGE(S)                                SELECTOR                      REPLICAS
	heapster     heapster       kubernetes/heapster:canary              k8s-app=heapster,version=v6   1
	kube-ui-v1   kube-ui        gcr.io/google_containers/kube-ui:v1.1   k8s-app=kube-ui,version=v1    1
	
	$ kubectl get services --namespace=kube-system                                                                             
	NAME       LABELS                                                                         SELECTOR           IP(S)           PORT(S)
	heapster   kubernetes.io/cluster-service=true,kubernetes.io/name=Heapster                 k8s-app=heapster   172.17.17.16    80/TCP
	kube-ui    k8s-app=kube-ui,kubernetes.io/cluster-service=true,kubernetes.io/name=KubeUI   k8s-app=kube-ui    172.17.17.138   80/TCP

	$ kubectl cluster-info
	Kubernetes master is running at http://localhost:8080
	Heapster is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/heapster
	KubeUI is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-ui

### Kubedash

    $ kubectl create -f kubedash/kube-config.yaml --namespace=kube-system



## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE][] for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[Hyperion]: https://github.com/portefaix/hyperion
[LICENSE]: https://github.com/portefaix/hyperion-services/blob/master/LICENSE
[Issue tracker]: https://github.com/portefaix/hyperion/issues

[badge-license]: https://img.shields.io/badge/license-Apache_2-green.svg
[badge-release]: https://img.shields.io/github/release/portefaix/hyperion-services.svg
