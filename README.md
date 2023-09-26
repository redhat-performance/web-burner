# web-burner

* Install a healthy cluster
* Run webfuse with bigip and create 35 test namespace using ICNI1.0
* ICNI1.0
	* Run kube-burner using node density and cluster density config
		* `kube-burner init -c cfg_icni2_cluster_density.yml -t $(kubectl create token -n openshift-monitoring prometheus-k8s) --uuid $(uuidgen) --prometheus-url  https://prometheus-k8s-openshift-monitoring.apps.test82.myocp4.com  -m metrics_full.yml`
* ICNI2.0
	* Run workload
		* `./create_icni2_workload.sh <workload> [scale_factor] [bfd_enabled]`
		* Example: `./create_icni2_workload.sh workload/cfg_icni2_cluster_density2.yml 4 false`

- Index
  - [End Resources](#end-resources)
  - [Run locally on a kind cluster](#run-locally-on-a-kind-cluster)
    - [Without BFD](#without-bfd)
    - [With BFD](#with-bfd)
  - [Run on an AWS OCP cluster](#run-on-an-aws-ocp-cluster)
  - [Run locally on OpenShift Local](#run-locally-on-openshift-local)
  - [Run through Arcaflow](#run-through-arcaflow)

## End Resources
Kube-burner configs are templated to created vz equivalent workload on 120 node cluster.
```shell
.
├── cfg_icni1_f5_cluster_density.yml
	├── 35 f5-served-ns
		└── 30 configmaps, 38 secrets, 3 icni1.0 app pods and services, 25 normal pods and services, 5 deployments with 2 replica pods and services on each namespace
	└── 2 app-served-ns
		├── 1 service(15 ports) with 84 pod endpoints, 1 service(15 ports) with 56 pod endpoints, 1 service(15 ports) with 25 pod endpoints
		├── 3 service(15 ports each) with 24 pod endpoints, 3 service(15 ports each) with 14 pod endpoints
		├── 6 service(15 ports each) with 12 pod endpoints, 6 service(15 ports each) with 10 pod endpoints, 6 service(15 ports each) with 9 pod endpoints
		├── 12 service(15 ports each) with 8 pod endpoints, 12 service(15 ports each) with 6 pod endpoints, 12 service(15 ports each) with 5 pod endpoints
		└── 29 service(15 ports each) with 4 pod endpoints, 29 service(15 ports each) with 6 pod endpoints
├── cfg_icni1_f5_node_density.yml
	├── 35 f5-served-ns
		└── 3 icni1.0 app pods and services on each namespace
	└── 35 normal-ns
		└── 1 service with 60 normal pod endpoints on each namespace
├── cfg_icni2_cluster_density2_single.yml
	├── 20 normal-ns
		└── 30 configmaps, 38 secrets, 38 normal pods and services, 5 deployments with 2 replica pods on each namespace
	├── 1 served-ns
		└── 105 icni2.0 app pods 
	└── 2 app-served-ns
		├── 1 service(15 ports) with 84 pod endpoints, 1 service(15 ports) with 56 pod endpoints, 1 service(15 ports) with 25 pod endpoints
		├── 3 service(15 ports each) with 24 pod endpoints, 3 service(15 ports each) with 14 pod endpoints
		├── 6 service(15 ports each) with 12 pod endpoints, 6 service(15 ports each) with 10 pod endpoints, 6 service(15 ports each) with 9 pod endpoints
		├── 12 service(15 ports each) with 8 pod endpoints, 12 service(15 ports each) with 6 pod endpoints, 12 service(15 ports each) with 5 pod endpoints
		└── 29 service(15 ports each) with 4 pod endpoints, 29 service(15 ports each) with 6 pod endpoints		
├── cfg_icni2_cluster_density2.yml
	├── 20 normal-ns
		└── 30 configmaps, 38 secrets, 38 normal pods and services, 5 deployments with 2 replica pods on each namespace
	├── 35 served-ns
		└── 3 icni2.0 app pods on each namespace
	└── 2 app-served-ns
		├── 1 service(15 ports) with 84 pod endpoints, 1 service(15 ports) with 56 pod endpoints, 1 service(15 ports) with 25 pod endpoints
		├── 3 service(15 ports each) with 24 pod endpoints, 3 service(15 ports each) with 14 pod endpoints
		├── 6 service(15 ports each) with 12 pod endpoints, 6 service(15 ports each) with 10 pod endpoints, 6 service(15 ports each) with 9 pod endpoints
		├── 12 service(15 ports each) with 8 pod endpoints, 12 service(15 ports each) with 6 pod endpoints, 12 service(15 ports each) with 5 pod endpoints
		└── 29 service(15 ports each) with 4 pod endpoints, 29 service(15 ports each) with 6 pod endpoints
├── cfg_icni2_cluster_density3_bz_single.yml - for BZ verfification only
├── cfg_icni2_cluster_density3_bz.yml - for BZ verfification only
├── cfg_icni2_node_density.yml
	└── 35 served-ns
		└── 1 service with 60 icni2.0 pod endpoints on each namespace
├── cfg_icni2_node_density2.yml
	├── 35 served-ns
		└── 3 icni2.0 app pods and services on each namespace
	└── 35 normal-ns
		└── 1 service with 60 normal pod endpoints on each namespace
├── cfg_icni2_serving_resource_init_single.yml
	├── 1 sriov network for serving namespace
	├── 1 serving-ns
		└── 1 frr config map, 1 patch configmap, 4 fake spk pods
	└── 1 served-ns
		└── 1 icni2.0 test pod for bfd session
├── cfg_icni2_serving_resource_init.yml
	├── 35 sriov network for 35 serving namespace
	├── 35 serving-ns
		└── 1 frr config map, 1 patch configmap, 4 fake spk pods on each namespace
	└── 35 served-ns
		└── 1 icni2.0 test pod on each namespace for bfd session
├── cfg_regular_cluster_density.yml
	├── 35 normal-ns
		└── 30 configmaps, 38 secrets, 38 normal pods and services, 5 deployments with 2 replica pods on each namespace
	└── 2 app-served-ns
		├── 1 service(15 ports) with 84 pod endpoints, 1 service(15 ports) with 56 pod endpoints, 1 service(15 ports) with 25 pod endpoints
		├── 3 service(15 ports each) with 24 pod endpoints, 3 service(15 ports each) with 14 pod endpoints
		├── 6 service(15 ports each) with 12 pod endpoints, 6 service(15 ports each) with 10 pod endpoints, 6 service(15 ports each) with 9 pod endpoints
		├── 12 service(15 ports each) with 8 pod endpoints, 12 service(15 ports each) with 6 pod endpoints, 12 service(15 ports each) with 5 pod endpoints
		└── 29 service(15 ports each) with 4 pod endpoints, 29 service(15 ports each) with 6 pod endpoints
└── cfg_regular_node_density.yml
	└── 35 regular-ns
		└── 1 service with 60 normal pod endpoints on each namespace
```

## Run locally on a kind cluster

> For the BFD setup to work you need to configure `docker` to mimic the Scale Lab subnet setup. Configure your `/etc/docker/daemon.json` (rootful docker) or `$HOME/.config/docker/daemon.json` (rootless) as follows:
> ```yaml
> {
>   "bip": "172.17.0.1/16",
>   "default-address-pools":
>   [
>     {"base":"192.168.216.0/21","size":21},
>     {
>       "base" : "172.17.0.0/12",
>       "size" : 16
>     }
>   ]
> }
> ```
> 
> Then restart the docker service:
> ```
> $ docker network prune
> $ sudo systemctl restart docker            # for rootful docker
> $ systemctl restart --user docker.service  # rootless
> ```

First create a local kind cluster with ONV-Kubernetes as CNI:
```
$ git clone https://github.com/ovn-org/ovn-kubernetes.git
$ cd ovn-kubernetes/contrib
$ ./kind.sh --install-cni-plugins --disable-snat-multiple-gws --multi-network-enable
```

> If you want OVN Interconnect (OVN-IC):
> ```
> $ ./kind.sh --install-cni-plugins --disable-snat-multiple-gws --multi-network-enable --enable-interconnect
> ```

Let's take a look at the options:
 - `install-cni-plugins`: Installs additional CNI network plugins
 - `disable-snat-multiple-gws`: Disable SNAT for multiple gws
 - `multi-network-enable`: Installs [Multus-CNI](https://github.com/k8snetworkplumbingwg/multus-cni) on the cluster
 - `enable-interconnect`: Enable interconnect with each node as a zone (only valid if OVN_HA is false)

After some minutes (took 4m), we will have a three node cluster ready for use:
```
$ export KUBECONFIG=$HOME/ovn.conf
$ kubectl get node
NAME                STATUS   ROLES           AGE    VERSION
ovn-control-plane   Ready    control-plane   4h2m   v1.24.0
ovn-worker          Ready    <none>          4h1m   v1.24.0
ovn-worker2         Ready    <none>          4h1m   v1.24.0
```

Check all pods are running:
```
$ kubectl get po  -A
NAMESPACE            NAME                                        READY   STATUS    RESTARTS        AGE
kube-system          coredns-787d4945fb-9tmjx                    1/1     Running   0               4m6s
kube-system          coredns-787d4945fb-mhtpg                    1/1     Running   0               4m6s
kube-system          etcd-ovn-control-plane                      1/1     Running   0               4m19s
kube-system          kube-apiserver-ovn-control-plane            1/1     Running   0               4m18s
kube-system          kube-controller-manager-ovn-control-plane   1/1     Running   0               4m18s
kube-system          kube-multus-ds-c2kfr                        1/1     Running   2 (3m2s ago)    3m14s
kube-system          kube-multus-ds-fpt4v                        1/1     Running   2 (3m1s ago)    3m14s
kube-system          kube-multus-ds-nvmm5                        1/1     Running   1 (2m59s ago)   3m14s
kube-system          kube-scheduler-ovn-control-plane            1/1     Running   0               4m19s
local-path-storage   local-path-provisioner-c8855d4bb-4p2lg      1/1     Running   0               4m6s
ovn-kubernetes       ovnkube-db-79f68fcbc5-k6vww                 2/2     Running   0               3m15s
ovn-kubernetes       ovnkube-master-55cd5bf96b-sx2kr             2/2     Running   0               3m15s
ovn-kubernetes       ovnkube-node-klvbp                          3/3     Running   3 (2m42s ago)   3m15s
ovn-kubernetes       ovnkube-node-qdrcd                          3/3     Running   3 (2m41s ago)   3m15s
ovn-kubernetes       ovnkube-node-tsbf5                          3/3     Running   1 (2m57s ago)   3m15s
ovn-kubernetes       ovs-node-m2jqx                              1/1     Running   0               3m15s
ovn-kubernetes       ovs-node-s5drz                              1/1     Running   0               3m15s
ovn-kubernetes       ovs-node-vbkrp                              1/1     Running   0               3m15s
```

> With IC, OVC pods will look a bit different:
> ```
> kubectl get po -n ovn-kubernetes
> NAME                                     READY   STATUS    RESTARTS   AGE
> ovnkube-control-plane-55b7c744d6-g4z8k   1/1     Running   0          82m
> ovnkube-identity-7dd8c767c-l2m87         1/1     Running   0          82m
> ovnkube-node-277xn                       6/6     Running   0          82m
> ovnkube-node-h9r8n                       6/6     Running   0          82m
> ovnkube-node-nkcn2                       6/6     Running   0          82m
> ovs-node-kg8v9                           1/1     Running   0          82m
> ovs-node-ml8pd                           1/1     Running   0          82m
> ovs-node-s9jdf                           1/1     Running   0          82m
> ```

Label one of the worker nodes for hosting the load balancers:
```
$ kubectl label node ovn-worker node-role.kubernetes.io/worker-spk="" --overwrite=true
node/ovn-worker labeled
```

Cordon the master node to be sure no pods will be scheduled there:
```
$ kubectl cordon ovn-control-plane
node/ovn-control-plane cordoned
```

Clone the web-burner repository:
```
$ git clone https://github.com/redhat-performance/web-burner.git
$ cd web-burner
```

Create a secret from the KUBECONFIG:
```
$ kubectl create secret generic kubeconfig --from-file=config=$KUBECONFIG --dry-run=client --output=yaml > objectTemplates/secret_kubeconfig.yml
```

Make sure kube-burner is installed in the appropiate version:
```
$ kube-burner version
Version: 1.7.8
Git Commit: 910b28640fb28fbee93c923caf43e52ea4895fae
Build Date: 2023-07-04T14:45:38Z
Go Version: go1.19.10
OS/Arch: linux amd64
```

### Without BFD

Export the following variables:
```
$ export BFD=${BFD:-false}
$ export BRIDGE=breth0
$ export BURST=${BURST:-20}
$ export CRD=false
$ export ES_INDEX=${ES_INDEX:-ripsaw-kube-burner}
$ export ES_SERVER=${ES_SERVER:-https://search-perfscale-dev-chmf5l4sh66lvxbnadi4bznl3a.us-west-2.es.amazonaws.com}
$ export LIMITCOUNT=1
$ export PROBE=false
$ export QPS=${QPS:-20}
$ export SCALE=${SCALE:-1}
$ export SRIOV=false
```

Create the load balancing/serving resources (took 2m):
```
$ kube-burner init -c workload/cfg_icni2_serving_resource_init.yml --uuid 1234
time="2023-07-11 09:05:38" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:05:41" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1234" file="job.go:83"
time="2023-07-11 09:05:41" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:05:41" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:05:41" level=info msg="Job init-job: 1 iterations with 1 ConfigMap replicas" file="create.go:87"
...
time="2023-07-11 09:06:54" level=info msg="serving-job: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: Ready 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: ContainersReady 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
...
time="2023-07-11 09:06:56" level=info msg="Indexing finished in 409ms: created=1" file="metadata.go:61"
time="2023-07-11 09:06:56" level=info msg="Finished execution with UUID: 1234" file="job.go:193"
time="2023-07-11 09:06:56" level=info msg="👋 Exiting kube-burner 1234" file="kube-burner.go:96"
```

Check the newly created pods:
```
$ kubectl get po -A | grep serv
served-ns-0          dep-served-init-0-1-init-served-job-768bd7d854-m2s6h   1/1     Running   0               84s
serving-ns-0         dep-serving-0-1-serving-job-5f97f469dc-7wczm           2/2     Running   0               77s
serving-ns-0         dep-serving-0-2-serving-job-7567c7748-f5nxs            2/2     Running   0               77s
serving-ns-0         dep-serving-0-3-serving-job-548bc588c4-77gw7           2/2     Running   0               77s
serving-ns-0         dep-serving-0-4-serving-job-7bbd48ff6-n8jm7            2/2     Running   0               77s
```

Check one of the serving pods for the second interface:
```
$ kubectl exec -n serving-ns-0 -it dep-serving-0-1-serving-job-5f97f469dc-7wczm -- sh
Defaulted container "nobfd" out of: nobfd, patch
sh-4.4$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP group default 
    link/ether 0a:58:0a:f4:00:05 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.0.5/24 brd 10.244.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::858:aff:fef4:5/64 scope link 
       valid_lft forever preferred_lft forever
3: net1@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether e2:18:03:3d:9a:6a brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.219.1/21 brd 192.168.223.255 scope global net1
       valid_lft forever preferred_lft forever
    inet6 fe80::e018:3ff:fe3d:9a6a/64 scope link 
       valid_lft forever preferred_lft forever
sh-4.4$ exit
```

Check the macvlan network attachment definition:
```yaml
$ kubectl get -n serving-ns-0 net-attach-def sriov-net-0 -o yaml
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  creationTimestamp: "2023-09-22T09:17:50Z"
  generation: 1
  labels:
    kube-burner-index: "0"
    kube-burner-job: create-networks-job
    kube-burner-runid: 9fc35e62-f130-4553-9453-b220a09ddaa4
    kube-burner-uuid: "1234"
  name: sriov-net-0
  namespace: serving-ns-0
  resourceVersion: "5329"
  uid: 4e63c28d-faab-4780-8d88-058ae4c6e2fb
spec:
  config: |-
    {
      "cniVersion": "0.3.1",
      "name": "internal-net",
      "plugins": [
        {
          "type": "macvlan",
          "master": "breth0",
          "mode": "bridge",
          "ipam": {
            "type": "static"
          }
        },
        {
          "capabilities": {
            "mac": true,
            "ips": true
          },
          "type": "tuning"
        }
      ]
    }
```

To avoid the disk quota exceeded errors when creating the served/application pods increase maxkeys kernel parameter:
```
$ sudo sysctl -w kernel.keys.maxkeys=5000
```

Create the served/application pods (took 4m):
```
$ kube-burner init -c workload/cfg_icni2_node_density2.yml --uuid 1235
time="2023-07-11 09:09:58" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:10:01" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1235" file="job.go:83"
time="2023-07-11 09:10:01" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:10:01" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:10:01" level=info msg="Job normal-service-job-1: 1 iterations with 1 Service replicas" file="create.go:87"
...
time="2023-07-11 09:14:08" level=info msg="Indexing finished in 4.457s: created=60" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="Indexing finished in 1.12s: created=4" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Ready 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: ContainersReady 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
...
time="2023-07-11 09:14:10" level=info msg="Indexing finished in 236ms: created=1" file="metadata.go:61"
time="2023-07-11 09:14:10" level=info msg="Finished execution with UUID: 1235" file="job.go:193"
time="2023-07-11 09:14:10" level=info msg="👋 Exiting kube-burner 1235" file="kube-burner.go:96"
```

Check the object counts:
```
$ kubectl get po -A | grep serving | grep Running | wc -l
4

$ kubectl get po -A | grep served | grep Running | wc -l
61
```

### With BFD

Export the following variables:
```
$ export BFD=true
$ export BRIDGE=breth0
$ export BURST=${BURST:-20}
$ export CRD=false
$ export ES_INDEX=${ES_INDEX:-ripsaw-kube-burner}
$ export ES_SERVER=${ES_SERVER:-https://search-perfscale-dev-chmf5l4sh66lvxbnadi4bznl3a.us-west-2.es.amazonaws.com}
$ export LIMITCOUNT=1
$ export PROBE=true
$ export QPS=${QPS:-20}
$ export SCALE=${SCALE:-1}
$ export SRIOV=false
```

Create the load balancing/serving resources (took 2m):
```
$ kube-burner init -c workload/cfg_icni2_serving_resource_init.yml --uuid 1234
time="2023-07-11 09:05:38" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:05:41" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1234" file="job.go:83"
time="2023-07-11 09:05:41" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:05:41" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:05:41" level=info msg="Job init-job: 1 iterations with 1 ConfigMap replicas" file="create.go:87"
...
time="2023-07-11 09:06:54" level=info msg="serving-job: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: Ready 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: ContainersReady 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
...
time="2023-07-11 09:06:56" level=info msg="Indexing finished in 409ms: created=1" file="metadata.go:61"
time="2023-07-11 09:06:56" level=info msg="Finished execution with UUID: 1234" file="job.go:193"
time="2023-07-11 09:06:56" level=info msg="👋 Exiting kube-burner 1234" file="kube-burner.go:96"
```

Check the newly created pods:
```
$ kubectl get po -A | grep serv
served-ns-0          dep-served-init-0-1-init-served-job-768bd7d854-m2s6h   1/1     Running   0               84s
serving-ns-0         dep-serving-0-1-serving-job-5f97f469dc-7wczm           2/2     Running   0               77s
serving-ns-0         dep-serving-0-2-serving-job-7567c7748-f5nxs            2/2     Running   0               77s
serving-ns-0         dep-serving-0-3-serving-job-548bc588c4-77gw7           2/2     Running   0               77s
serving-ns-0         dep-serving-0-4-serving-job-7bbd48ff6-n8jm7            2/2     Running   0               77s
```

Check one of the serving pods for:
 - the second interface
 - the second address in the loopback interface (`172.18.0.10/32`)
 - the routes (`kubectl get nodes -o jsonpath='{range .items[*].metadata.annotations}{.k8s\.ovn\.org\/node\-subnets}{.k8s\.ovn\.org\/node\-primary\-ifaddr}{"\n"}{end}' | awk -F'["/]' '{print "ip route " $4"/"$5 " " $9}'`)
 - the BFD session established with the node `ovn-worker2`
```
$ kubectl exec -n serving-ns-0 -it dep-serving-0-1-serving-job-5f97f469dc-7wczm -- sh
Defaulted container "bfd" out of: bfd, patch
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 172.18.0.10/32 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0@if26: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1400 qdisc noqueue state UP group default 
    link/ether 0a:58:0a:f4:01:13 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.244.1.19/24 brd 10.244.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::858:aff:fef4:113/64 scope link 
       valid_lft forever preferred_lft forever
3: net1@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether ce:e5:5b:28:87:43 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.219.1/21 brd 192.168.223.255 scope global net1
       valid_lft forever preferred_lft forever
    inet6 fe80::cce5:5bff:fe28:8743/64 scope link 
       valid_lft forever preferred_lft forever

sh-5.1# ip r
default via 10.244.1.1 dev eth0 
10.96.0.0/16 via 10.244.1.1 dev eth0 
10.244.0.0/24 nhid 18 via 192.168.216.2 dev net1 proto 196 metric 20 
10.244.0.0/16 via 10.244.1.1 dev eth0 
10.244.1.0/24 dev eth0 proto kernel scope link src 10.244.1.19 
10.244.2.0/24 nhid 17 via 192.168.216.3 dev net1 proto 196 metric 20 
100.64.0.0/16 via 10.244.1.1 dev eth0 
192.168.216.0/21 dev net1 proto kernel scope link src 192.168.219.1

sh-5.1# vtysh -c "show bfd peers brief" | grep up
160369874  192.168.219.1                            192.168.216.2                           up             
807179051  192.168.219.1                            192.168.216.3                           up
```

Let’s check everything was properly created from the OVN perspective (BFD sessions, ECMP BFD entries):
```
$ POD=$(kubectl get pod -n ovn-kubernetes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep ovnkube-db-) ; kubectl exec -ti $POD -n ovn-kubernetes -c nb-ovsdb -- bash

[root@ovn-control-plane ~]# ovn-nbctl list bfd
_uuid               : c8aa4838-943b-4734-a5b4-e249ae0355b4
detect_mult         : []
dst_ip              : "192.168.221.1"
external_ids        : {}
logical_port        : rtoe-GR_ovn-worker2
min_rx              : []
min_tx              : []
options             : {}
status              : up

_uuid               : 3e81efed-ed95-46fe-a49a-67a13f940158
detect_mult         : []
dst_ip              : "192.168.222.1"
external_ids        : {}
logical_port        : rtoe-GR_ovn-worker2
min_rx              : []
min_tx              : []
options             : {}
status              : up

_uuid               : 5206243a-1158-496a-8d5f-abcfb783af5b
detect_mult         : []
dst_ip              : "192.168.219.1"
external_ids        : {}
logical_port        : rtoe-GR_ovn-worker2
min_rx              : []
min_tx              : []
options             : {}
status              : up

_uuid               : e92cb12e-95d0-4fe4-9f7e-7dc5843d3389
detect_mult         : []
dst_ip              : "192.168.220.1"
external_ids        : {}
logical_port        : rtoe-GR_ovn-worker2
min_rx              : []
min_tx              : []
options             : {}
status              : up

[root@ovn-control-plane ~]# ovn-nbctl lr-route-list GR_ovn-worker2
IPv4 Routes
Route Table <main>:
               10.244.0.5             192.168.219.1 src-ip rtoe-GR_ovn-worker2 ecmp ecmp-symmetric-reply bfd
               10.244.0.5             192.168.220.1 src-ip rtoe-GR_ovn-worker2 ecmp ecmp-symmetric-reply bfd
               10.244.0.5             192.168.221.1 src-ip rtoe-GR_ovn-worker2 ecmp ecmp-symmetric-reply bfd
               10.244.0.5             192.168.222.1 src-ip rtoe-GR_ovn-worker2 ecmp ecmp-symmetric-reply bfd
         169.254.169.0/29             169.254.169.4 dst-ip rtoe-GR_ovn-worker2
            10.244.0.0/16                100.64.0.1 dst-ip
                0.0.0.0/0             192.168.216.1 dst-ip rtoe-GR_ovn-worker2

[root@ovn-control-plane ~]# ovn-nbctl lr-route-list GR_ovn-worker
IPv4 Routes
Route Table <main>:
         169.254.169.0/29             169.254.169.4 dst-ip rtoe-GR_ovn-worker
            10.244.0.0/16                100.64.0.1 dst-ip
                0.0.0.0/0             192.168.216.1 dst-ip rtoe-GR_ovn-worker
```

From the app/served pod you should be able to ping the IP set on the loopback interface of the lb/serving pod:
```
$ kubectl exec -n served-ns-0 dep-served-init-0-1-init-served-job-58b4ff5b99-cgtkw -- ping -c 1 172.18.0.10
PING 172.18.0.10 (172.18.0.10) 56(84) bytes of data.
64 bytes from 172.18.0.10: icmp_seq=1 ttl=62 time=0.074 ms
--- 172.18.0.10 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.074/0.074/0.074/0.000 ms
```

Check the macvlan network attachment definition:
```yaml
$ kubectl get -n serving-ns-0 net-attach-def sriov-net-0 -o yaml
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  creationTimestamp: "2023-09-22T09:17:50Z"
  generation: 1
  labels:
    kube-burner-index: "0"
    kube-burner-job: create-networks-job
    kube-burner-runid: 9fc35e62-f130-4553-9453-b220a09ddaa4
    kube-burner-uuid: "1234"
  name: sriov-net-0
  namespace: serving-ns-0
  resourceVersion: "5329"
  uid: 4e63c28d-faab-4780-8d88-058ae4c6e2fb
spec:
  config: |-
    {
      "cniVersion": "0.3.1",
      "name": "internal-net",
      "plugins": [
        {
          "type": "macvlan",
          "master": "breth0",
          "mode": "bridge",
          "ipam": {
            "type": "static"
          }
        },
        {
          "capabilities": {
            "mac": true,
            "ips": true
          },
          "type": "tuning"
        }
      ]
    }
```

To avoid the disk quota exceeded errors when creating the served/application pods increase maxkeys kernel parameter:
```
$ sudo sysctl -w kernel.keys.maxkeys=5000
```

Create the served/application pods (took 4m):
```
$ kube-burner init -c workload/cfg_icni2_node_density2.yml --uuid 1235
time="2023-07-11 09:09:58" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:10:01" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1235" file="job.go:83"
time="2023-07-11 09:10:01" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:10:01" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:10:01" level=info msg="Job normal-service-job-1: 1 iterations with 1 Service replicas" file="create.go:87"
...
time="2023-07-11 09:14:08" level=info msg="Indexing finished in 4.457s: created=60" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="Indexing finished in 1.12s: created=4" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Ready 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: ContainersReady 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
...
time="2023-07-11 09:14:10" level=info msg="Indexing finished in 236ms: created=1" file="metadata.go:61"
time="2023-07-11 09:14:10" level=info msg="Finished execution with UUID: 1235" file="job.go:193"
time="2023-07-11 09:14:10" level=info msg="👋 Exiting kube-burner 1235" file="kube-burner.go:96"
```

Check the object counts:
```
$ kubectl get po -A | grep serving | grep Running | wc -l
4

$ kubectl get po -A | grep served | grep Running | wc -l
61
```

## Run on an AWS OCP cluster

Let's assume an AWS OCP cluster with ovn-networking:
```
$ kubectl get node
NAME                                         STATUS   ROLES               AGE   VERSION
ip-10-0-150-202.us-west-2.compute.internal   Ready    worker              21h   v1.23.3+e419edf
ip-10-0-156-247.us-west-2.compute.internal   Ready    master              21h   v1.23.3+e419edf
ip-10-0-190-123.us-west-2.compute.internal   Ready    worker              21h   v1.23.3+e419edf
```

Label one of the worker nodes for hosting the load balancers:
```
$ kubectl label node ip-10-0-150-202.us-west-2.compute.internal  node-role.kubernetes.io/worker-spk="" --overwrite=true
node/ip-10-0-150-202.us-west-2.compute.internal labeled
```

Clone the web-burner repository:
```
$ git clone https://github.com/redhat-performance/web-burner.git
$ cd web-burner
```

Create a secret from the KUBECONFIG:
```
$ kubectl create secret generic kubeconfig --from-file=config=$KUBECONFIG --dry-run=client --output=yaml > objectTemplates/secret_kubeconfig.yml
```

Export the following variables:
```
$ export BFD=${BFD:-false}
$ export BRIDGE=${BRIDGE:-br-ex}
$ export BURST=${BURST:-20}
$ export ES_INDEX=${ES_INDEX:-ripsaw-kube-burner}
$ export ES_SERVER=${ES_SERVER:-https://search-perfscale-dev-chmf5l4sh66lvxbnadi4bznl3a.us-west-2.es.amazonaws.com}
$ export LIMITCOUNT=1
$ export PROBE=false
$ export QPS=${QPS:-20}
$ export SCALE=${SCALE:-1}
$ export SRIOV=false
```

Make sure kube-burner is installed in the appropiate version:
```
$ kube-burner version
Version: 1.7.8
Git Commit: 910b28640fb28fbee93c923caf43e52ea4895fae
Build Date: 2023-07-04T14:45:38Z
Go Version: go1.19.10
OS/Arch: linux amd64
```

Create the load balancing/serving resources:
```
$ kube-burner init -c workload/cfg_icni2_serving_resource_init.yml --uuid 1234
time="2023-07-11 09:05:38" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:05:41" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1234" file="job.go:83"
time="2023-07-11 09:05:41" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:05:41" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:05:41" level=info msg="Job init-job: 1 iterations with 1 ConfigMap replicas" file="create.go:87"
...
time="2023-07-11 09:06:54" level=info msg="serving-job: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: Ready 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:06:54" level=info msg="serving-job: ContainersReady 50th: 50358 99th: 54357 max: 54357 avg: 51857" file="pod_latency.go:168"
...
time="2023-07-11 09:06:56" level=info msg="Indexing finished in 409ms: created=1" file="metadata.go:61"
time="2023-07-11 09:06:56" level=info msg="Finished execution with UUID: 1234" file="job.go:193"
time="2023-07-11 09:06:56" level=info msg="👋 Exiting kube-burner 1234" file="kube-burner.go:96"
```

Check the newly created lb pods:
```
$ kubectl get po -n serving-ns-0
NAME                                           READY   STATUS    RESTARTS   AGE
dep-serving-0-1-serving-job-5ccd8c9d86-n7lwt   2/2     Running   0          16m
dep-serving-0-2-serving-job-5bc5476d45-l6lhd   2/2     Running   0          16m
dep-serving-0-3-serving-job-7645fb549f-tqtlf   2/2     Running   0          16m
dep-serving-0-4-serving-job-7769dccf77-dxjpf   2/2     Running   0          16m
```

Check the macvlan network attachment definition:
```
$ kubectl get net-attach-def -n serving-ns-0
NAME          AGE
sriov-net-0   17m
 
$ kubectl describe net-attach-def -n serving-ns-0
Name:         sriov-net-0                                                                                                                                                                                         
Namespace:    serving-ns-0                                                                              
Labels:       kube-burner-index=0          
              kube-burner-job=create-networks-job
              kube-burner-uuid=1234                                                                     
Annotations:  <none>                     
API Version:  k8s.cni.cncf.io/v1    
Kind:         NetworkAttachmentDefinition                                                               
Metadata:                       
  Creation Timestamp:  2023-08-03T08:16:31Z
  Generation:          1                 
  Managed Fields:             
    API Version:  k8s.cni.cncf.io/v1                                                                    
    Fields Type:  FieldsV1    
    fieldsV1:                            
      f:metadata:               
        f:labels:                                                                                       
          .:                             
          f:kube-burner-index:  
          f:kube-burner-job:                                                                            
          f:kube-burner-uuid:            
      f:spec:                                                                                           
        .:                                                                                              
        f:config:                                                                                       
    Manager:         kube-burner                                                                                                                                                                                
    Operation:       Update                                                                                                                                                                                     
    Time:            2023-08-03T08:16:31Z
  Resource Version:  395173
  UID:               37e11ee8-5074-48c7-bdad-9a5821f042c6                                                                                                                                                       
Spec:                   
  Config:  {            
  "cniVersion": "0.3.1",                                                                                                                                                                                        
  "name": "internal-net",
  "plugins": [          
    {                   
      "type": "macvlan",
      "master": "br-ex",                                                                                                                                                                                        
      "mode": "bridge",
      "ipam": {        
        "type": "static"
      }                                                                                                                                                                                                         
    },                
    {                 
      "capabilities": {                                                                                                                                                                                         
        "mac": true,
        "ips": true
      },
      "type": "tuning"
    }
  ]
}
Events:  <none>
```

Create the served/application pods:
```
$ kube-burner init -c workload/cfg_icni2_node_density2.yml --uuid 1235
time="2023-07-11 09:09:58" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:10:01" level=info msg="🔥 Starting kube-burner (1.7.8@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1235" file="job.go:83"
time="2023-07-11 09:10:01" level=info msg="📈 Creating measurement factory" file="factory.go:51"
time="2023-07-11 09:10:01" level=info msg="Registered measurement: podLatency" file="factory.go:83"
time="2023-07-11 09:10:01" level=info msg="Job normal-service-job-1: 1 iterations with 1 Service replicas" file="create.go:87"
...
time="2023-07-11 09:14:08" level=info msg="Indexing finished in 4.457s: created=60" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="Indexing finished in 1.12s: created=4" file="pod_latency.go:193"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Initialized 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: Ready 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: PodScheduled 50th: 0 99th: 0 max: 0 avg: 0" file="pod_latency.go:168"
time="2023-07-11 09:14:09" level=info msg="normal-job-1: ContainersReady 50th: 207326 99th: 233786 max: 233786 avg: 169819" file="pod_latency.go:168"
...
time="2023-07-11 09:14:10" level=info msg="Indexing finished in 236ms: created=1" file="metadata.go:61"
time="2023-07-11 09:14:10" level=info msg="Finished execution with UUID: 1235" file="job.go:193"
time="2023-07-11 09:14:10" level=info msg="👋 Exiting kube-burner 1235" file="kube-burner.go:96"
```

Check the object counts:
```
$ kubectl get po -A | grep serving | grep Running | wc -l
4

$ kubectl get po -A | grep served | grep Running | wc -l
61
```

## Run locally on OpenShift Local

OpenShift Local (formally CRC) does not yet support ovn-kubernetes as CNI (see [crc#2294](https://github.com/crc-org/crc/issues/2294)).

## Run through Arcaflow

[arcaflow-plugin-kube-burner](https://github.com/redhat-performance/arcaflow-plugin-kube-burner) can be used to run the web-burner workload in containers.

1. Clone [the arcaflow kube-burner repository](https://github.com/redhat-performance/arcaflow-plugin-kube-burner)
2. cd arcaflow-plugin-kube-burner
3. Copy and Paste the openshift/kubernetes cluster's kubeconfig file content into the configs/webburner_input.yaml and configs/webburner_cleanup.yaml files.
4. Create the container with `docker build -t arca-web-burner .`
5. To run a web-burner workload `cat configs/webburner_input.yaml | docker run -i arca-web-burner -s run-web-burner --debug -f -`
6. To delete a web-burner workload `cat configs/webburner_input.yaml | docker run -i arca-kube-burner -s delete-web-burner --debug -f -`  
