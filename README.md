# kube-burner-templates

* Install a healthy cluster
* Run webfuse with bigip and create 35 test namespace using ICNI1.0
* Install kube-burner v0.11 
* ICNI1.0
	* Run kubeburner using node density and cluster density config
* ICNI2.0
	* Create 64 VFs on worker-lb nodes using `sriov_policy.yaml` with correct PF
	* lable worker-lb nodes `oc lable node worker002-fc640 serving=""` 
	* Run kubeburner config `cfg_icni2_serving_resource_init.yml` to create ICNI2.0 serving pods and BFD sessions
	* Run workload
