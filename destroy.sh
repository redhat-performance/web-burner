for i in {1..35}; do oc delete sriovnetwork sriov-net-ens2f0-$i -n openshift-sriov-network-operator; done
kube-burner destroy --uuid $1
