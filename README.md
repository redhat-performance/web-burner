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
