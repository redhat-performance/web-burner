echo "NBDB leader elections:"
for p in $(oc get pod -o name -l app=ovnkube-master -n openshift-ovn-kubernetes); do oc -n openshift-ovn-kubernetes exec -c nbdb $p -- ovn-appctl -t /var/run/ovn/ovnnb_db.ctl cluster/status OVN_Northbound | egrep "Term|timer"; done
echo
echo "SBDB leader elections:"
for p in $(oc get pod -o name -l app=ovnkube-master -n openshift-ovn-kubernetes); do oc -n openshift-ovn-kubernetes exec -c sbdb $p -- ovn-appctl -t /var/run/ovn/ovnsb_db.ctl cluster/status OVN_Southbound | egrep "Term|timer"; done
