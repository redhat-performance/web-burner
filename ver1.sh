POD=ovnkube-master-5rk5p
set -x
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl list bfd | grep up | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl list bfd | grep worker
set +x
