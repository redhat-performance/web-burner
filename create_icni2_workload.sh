#!/bin/bash

export KUBECONFIG=/home/kni/clusterconfigs/auth/kubeconfig

if [ $# -eq 0 ]; then
    echo "Pass kube-burner config"
    exit 1
fi

pushd ./workload

lb_workers=$(oc get nodes | grep worker-lb | awk '{print $1}') # get all worker-lb nodes
lb_workers=($lb_workers)
# Need at least 4 worker-lb nodes for spk pods
if [[ ${#lb_workers[@]} -ge 4 ]] ; then
  echo "Found 4 worker-lb nodes for spk pods"
else
  echo "Not enough worker-lb nodes, labeling nodes"
  all_workers=$(oc get nodes | grep worker | grep -v worker-lb | awk '{print $1}') # get all worker nodes except worker-lb
  all_workers=($all_workers)
  count=0 
  while [[ $count -le 3 ]]; do
    echo "Label worker nodes.."
    oc label node ${all_workers[$count]} node-role.kubernetes.io/worker-lb="" --overwrite=true
    count=$((count+1))
  done
fi

# Find the right SR-IOV PF
sriov_nic=""
for i in $(oc get nodes | grep worker-lb | awk '{print $1}')
do 
  nic=$(ssh -i /home/kni/.ssh/id_rsa -o StrictHostKeyChecking=no core@$i "sudo ovs-vsctl list-ports br-ex | head -1")
  if [[ $sriov_nic == "" ]]; then
    echo "Setting SR-IOV PF to $nic"
    export sriov_nic=$nic
  elif [[ $sriov_nic != $nic ]]; then
    echo "SR-IOV PF is not matching with other worker-lb nodes"
    exit 1
  fi
done

# Applying SR-IOV Network Node policy
echo "Creating SRIOVNetworkNodePolicy.."
envsubst < sriov_policy.yaml | oc apply -f -
sleep 60 # sleep for 60 seconds before checking for status

echo "Waiting for the worker-lb node to be ready.."
for mcp in $(oc get mcp worker-lb worker --ignore-not-found --no-headers | awk '{print $1}')
do 
  oc wait --for=condition=Updated --timeout=3600s mcp $mcp
  echo "Nice! $mcp is updated"
done

echo "Set Openshift monitoring vars.."
prometheus_url=$(oc get routes -n openshift-monitoring prometheus-k8s --no-headers | awk '{print $2}')
token=$(oc sa get-token -n openshift-monitoring prometheus-k8s)

for i in {1..35}; do oc new-project serving-ns-$i; done

for i in {1..35}; do oc create secret -n serving-ns-$i generic kubeconfig --from-file=config=/home/kni/clusterconfigs/auth/kubeconfig; done

echo "Lets create SPK pods.."
kube-burner init -c cfg_icni2_serving_resource_init.yml -t ${token} --uuid 1234

echo "Pausing for a minute.."
sleep 60 # sleep for a minute before actual workload

popd

echo "Lets create ICNI2 workloads..$uuid"
kube-burner init -c ${1} -t ${token} --uuid $(uuidgen) --prometheus-url https://${prometheus_url} -m metrics_full.yaml 


