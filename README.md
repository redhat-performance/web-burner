# kube-burner-templates

* Install a healthy cluster
* Run webfuse with bigip and create 35 test namespace using ICNI1.0
* Install kube-burner v0.11 
* ICNI1.0
	* Run kubeburner using node density and cluster density config
* ICNI2.0
	* Create 64 VFs on worker-lb nodes(4) using `sriov_policy.yaml` with correct PF
	* lable worker-lb nodes `oc lable node worker002-fc640 serving=""` 
	* create `serving-ns` namespace and create a secret kubeconfig - `for i in {1..35}; do oc create secret -n serving-ns-$i generic kubeconfig --from-file=config=/home/kni/clusterconfigs/auth/kubeconfig; done`
	* Run kubeburner config `cfg_icni2_serving_resource_init.yml` to create ICNI2.0 serving pods and BFD sessions
	* Run workload
