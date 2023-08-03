# web-burner

* Install a healthy cluster
* Run webfuse with bigip and create 35 test namespace using ICNI1.0
* ICNI1.0
	* Run kubeburner using node density and cluster density config
		* `kube-burner init -c cfg_icni2_cluster_density.yml -t $(kubectl create token -n openshift-monitoring prometheus-k8s) --uuid $(uuidgen) --prometheus-url  https://prometheus-k8s-openshift-monitoring.apps.test82.myocp4.com  -m metrics_full.yml`
* ICNI2.0
	* Run workload
		* `./create_icni2_workload.sh <workload> [scale_factor] [bfd_enabled]`
		* Example: `./create_icni2_workload.sh workload/cfg_icni2_cluster_density2.yml 4 false`

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

### Run locally on a kind cluster

First create a local kind cluster with ONV-Kubernetes as CNI:
```
$ git clone https://github.com/ovn-org/ovn-kubernetes.git
$ cd ovn-kubernetes/contrib
$ ./kind.sh --install-cni-plugins --disable-snat-multiple-gws --multi-network-enable
```

Let's take a look at the options:
 - `install-cni-plugins`: Installs additional CNI network plugins
 - `disable-snat-multiple-gws`: Disable SNAT for multiple gws
 - `multi-network-enable`: Installs [Multus-CNI](https://github.com/k8snetworkplumbingwg/multus-cni) on the cluster

After some minutes (took 4m), we will have a three node cluster ready for use:
```
$ cd
$ export KUBECONFIG=$(pwd)/ovn.conf
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

Label one of the worker nodes for hosting the load balancers:
```
$ kubectl label node ovn-worker node-role.kubernetes.io/worker-spk="" --overwrite=true
node/ovn-worker labeled
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
$ export KUBE_BURNER_RELEASE=${KUBE_BURNER_RELEASE:-1.7.2}
$ export QPS=${QPS:-20}
$ export BURST=${BURST:-20}
$ export SCALE=${SCALE:-1}
$ export BFD=${BFD:-false}
$ export SRIOV=false
$ export BRIDGE=breth0
$ export LIMITCOUNT=1
$ export ES_SERVER=${ES_SERVER:-https://search-perfscale-dev-chmf5l4sh66lvxbnadi4bznl3a.us-west-2.es.amazonaws.com}
$ export ES_INDEX=${ES_INDEX:-ripsaw-kube-burner}
```

Make sure kube-burner is installed in the appropiate version:
```
$ kube-burner version
Version: 1.7.2
Git Commit: 910b28640fb28fbee93c923caf43e52ea4895fae
Build Date: 2023-07-04T14:45:38Z
Go Version: go1.19.10
OS/Arch: linux amd64
```

Create the load balancing/serving resources (took 2m):
```
kube-burner init -c workload/cfg_icni2_serving_resource_init.yml --uuid 1234
time="2023-07-11 09:05:38" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:05:41" level=info msg="🔥 Starting kube-burner (1.7.2@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1234" file="job.go:83"
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
kube-system          kube-apiserver-ovn-control-plane                       1/1     Running   0               9m38s
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
```
$ kubectl get net-attach-def -n serving-ns-0
NAME          AGE
sriov-net-0   3m16s
 
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
  Creation Timestamp:  2023-07-11T07:05:43Z
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
    Time:            2023-07-11T07:05:43Z
  Resource Version:  1514
  UID:               0eb97ddc-3134-40dc-930b-b9534a060b66
Spec:
  Config:  {
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
Events:  <none>
```

To avoid the disk quota exceeded errors when creating the served/application pods increase maxkeys kernel parameter:
```
echo 5000 | sudo tee /proc/sys/kernel/keys/maxkeys
```

Create the served/application pods (took 4m):
```
$ kube-burner init -c workload/cfg_icni2_node_density2.yml --uuid 1235
time="2023-07-11 09:09:58" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:10:01" level=info msg="🔥 Starting kube-burner (1.7.2@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1235" file="job.go:83"
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

### Run on an AWS OCP cluster

Let's assume AWS OCP IPI installed cluster with ovn-networking:
```
$ kubectl get node
NAME                                         STATUS   ROLES               AGE   VERSION
ip-10-0-122-165.us-west-2.compute.internal   Ready    workload            21h   v1.23.3+e419edf
ip-10-0-150-202.us-west-2.compute.internal   Ready    worker              21h   v1.23.3+e419edf
ip-10-0-156-247.us-west-2.compute.internal   Ready    master              21h   v1.23.3+e419edf
ip-10-0-190-123.us-west-2.compute.internal   Ready    worker              21h   v1.23.3+e419edf
```

Label one of the worker nodes for hosting the load balancers:
```
$ kubectl label node ip-10-0-150-202.us-west-2.compute.internal  node-role.kubernetes.io/worker-spk="" --overwrite=true
node/ovn-worker labeled
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
$ export KUBE_BURNER_RELEASE=${KUBE_BURNER_RELEASE:-1.7.2}
$ export QPS=${QPS:-20}
$ export BURST=${BURST:-20}
$ export SCALE=${SCALE:-1}
$ export BFD=${BFD:-false}
$ export SRIOV=false
$ export BRIDGE=${BRIDGE:-br-ex}
$ export LIMITCOUNT=1
$ export ES_SERVER=${ES_SERVER:-https://search-perfscale-dev-chmf5l4sh66lvxbnadi4bznl3a.us-west-2.es.amazonaws.com}
$ export ES_INDEX=${ES_INDEX:-ripsaw-kube-burner}
```

Make sure kube-burner is installed in the appropiate version:
```
$ kube-burner version
Version: 1.7.2
Git Commit: 910b28640fb28fbee93c923caf43e52ea4895fae
Build Date: 2023-07-04T14:45:38Z
Go Version: go1.19.10
OS/Arch: linux amd64
```

Create the load balancing/serving resources:
```
kube-burner init -c workload/cfg_icni2_serving_resource_init.yml --uuid 1234
time="2023-07-11 09:05:38" level=info msg="📁 Creating indexer: elastic" file="metrics.go:40"
time="2023-07-11 09:05:41" level=info msg="🔥 Starting kube-burner (1.7.2@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1234" file="job.go:83"
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
time="2023-07-11 09:10:01" level=info msg="🔥 Starting kube-burner (1.7.2@910b28640fb28fbee93c923caf43e52ea4895fae) with UUID 1235" file="job.go:83"
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

### Run locally on OpenShift Local

OpenShift Local (formally CRC) does not yet support ovn-kubernetes as CNI (see [crc#2294](https://github.com/crc-org/crc/issues/2294)).

### Run through Arcaflow

[arcaflow-plugin-kube-burner](https://github.com/redhat-performance/arcaflow-plugin-kube-burner) needs to support some additional variables (see [arcaflow-plugin-kube-burner#5](https://github.com/redhat-performance/arcaflow-plugin-kube-burner/issues/5)).
