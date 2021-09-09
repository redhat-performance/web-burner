POD=ovnkube-master-mvs24
set -x
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker000-r640 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker001-r640 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker002-fc640 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker003-fc640 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker004-fc640 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker005-fc640 | wc -l
set +x
for i in {006..200}; do oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-route-list GR_worker$i-fc640 | wc -l; done
set -x
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-policy-list ovn_cluster_router | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-nbctl lr-policy-list ovn_cluster_router | grep 501 | wc -l
oc exec -n openshift-ovn-kubernetes -it $POD -- ovn-sbctl --no-leader-only lflow-list | wc -l
set +x
for i in $(oc get po -n served-ns -o json | jq '.items[].metadata.name' | tr -d \"); do oc describe po -n served-ns $i | grep annotations; done | wc -l
