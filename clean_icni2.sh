for j in {1..17}; do for i in $(oc get pods -A| grep -i pod-served- | grep -v init| awk '{print $2}' ); do oc delete pod -n $j $i; done; done
