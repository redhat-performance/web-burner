oc logs -n openshift-ovn-kubernetes ovnkube-master-6qhlm  -c ovnkube-master | grep -i throttling  | wc -l
oc logs -n openshift-ovn-kubernetes ovnkube-master-qcwqc   -c ovnkube-master | grep -i throttling | wc -l
oc logs -n openshift-ovn-kubernetes ovnkube-master-zhfr7   -c ovnkube-master | grep -i throttling | wc -l
