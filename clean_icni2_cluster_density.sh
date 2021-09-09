for i in {1..35}; do oc delete project normal-ns-$i --wait=false; done
for i in {1..2}; do oc delete project app-served-ns-$i --wait=false; done
for j in {34..35}; do for i in $(oc get pods -A| grep -i pod-served- | grep -v init| awk '{print $2}' ); do oc delete pod -n served-ns-$j $i --wait=false; done; done
