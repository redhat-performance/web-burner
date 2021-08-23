COUNT=0
for i in `oc get pods -n openshift-ovn-kubernetes | grep ovnkube-node | awk {'print$1'}`
do
    if oc logs $i -c ovn-controller -n openshift-ovn-kubernetes | grep -i unreasonabl ; then
        COUNT=$((COUNT+1))
    fi
done
echo $COUNT

