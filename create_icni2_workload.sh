#!/bin/bash

SCALE=$2
BFD=$3

export KUBE_BURNER_RELEASE=${KUBE_BURNER_RELEASE:-0.14.1}
export QPS=${QPS:-20}
export BURST=${BURST:-20}
export SCALE=${SCALE:-1}
export BFD=${BFD:-true}

export vf_serving_factor=140
num_vfs=$(( SCALE*vf_serving_factor))
lb_count=$(((num_vfs+63)/64)) #round up
if [[ $lb_count -lt 4 ]] ; then # minimum 4 lb nodes
    lb_count=4
fi

kube_burner_exists=$(which kube-burner)

if [ $? -ne 0 ]; then
    echo "Installing kube-burner"
    wget -O kube-burner.tar.gz https://github.com/cloud-bulldozer/kube-burner/releases/download/v${KUBE_BURNER_RELEASE}/kube-burner-${KUBE_BURNER_RELEASE}-Linux-x86_64.tar.gz
    sudo tar -xvzf kube-burner.tar.gz -C /usr/local/bin/
fi


export KUBECONFIG=/home/kni/clusterconfigs/auth/kubeconfig
oc create secret generic kubeconfig --from-file=config=/home/kni/clusterconfigs/auth/kubeconfig --dry-run=client --output=yaml > objectTemplates/secret_kubeconfig.yaml

if [ $# -eq 0 ]; then
    echo "Pass kube-burner config"
    exit 1
fi

pushd ./workload

lb_workers=$(oc get nodes | grep worker-lb | awk '{print $1}') # get all worker-lb nodes
lb_workers=($lb_workers)
# Need at least 4 worker-lb nodes for spk pods
if [[ ${#lb_workers[@]} -ge $lb_count ]] ; then
  echo "Found enough worker-lb nodes for spk pods"
else
  echo "Not enough worker-lb nodes, labeling nodes"
  all_workers=$(oc get nodes | grep worker | grep -v worker-lb | awk '{print $1}') # get all worker nodes except worker-lb
  all_workers=($all_workers)
  if [[ $lb_count-${#lb_workers[@]} -gt ${#all_workers[@]} ]]; then
      echo "Not enough nodes to label" # there should be enough unlabelled nodes to label them
      exit 1
  fi
  count=0 
  while [[ $count -le $lb_count-1 ]]; do
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

popd

mkdir -p logs

echo "Lets create SPK pods.."
unbuffer kube-burner init -c workload/cfg_icni2_serving_resource_init.yml -t ${token} --uuid 1234 2>&1 | tee logs/icni2_serving_resource_init_`date +'%Y%m%d%H%M'`.log

echo "Pausing for a minute.."
sleep 60 # sleep for a minute before actual workload

echo "Lets create ICNI2 workloads..$uuid"
unbuffer kube-burner init -c ${1} -t ${token} --uuid $(uuidgen) --prometheus-url https://${prometheus_url} -m workload/metrics_full.yaml 2>&1 | tee logs/icni2_${1}_`date +'%Y%m%d%H%M'`.log
