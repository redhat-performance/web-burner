#!/bin/bash

SCALE=$2
BFD=$3

export KUBE_BURNER_RELEASE=${KUBE_BURNER_RELEASE:-0.14.1}
export QPS=${QPS:-20}
export BURST=${BURST:-20}
export SCALE=${SCALE:-1}
export BFD=${BFD:-false}
#The limit count is used to calculate servedlimit and normallimit. For a 120 node cluster the default count is 35, for other size clusters use this formula to calculate. limit count = (35 * cluster_size) // 120
export LIMITCOUNT=${LIMITCOUNT:-35} 

kube_burner_exists=$(which kube-burner)

if [ $? -ne 0 ]; then
    echo "Installing kube-burner"
    wget -O kube-burner.tar.gz https://github.com/cloud-bulldozer/kube-burner/releases/download/v${KUBE_BURNER_RELEASE}/kube-burner-${KUBE_BURNER_RELEASE}-Linux-x86_64.tar.gz
    sudo tar -xvzf kube-burner.tar.gz -C /usr/local/bin/
fi


export KUBECONFIG=/home/kni/clusterconfigs/auth/kubeconfig

if [ $# -eq 0 ]; then
    echo "Pass kube-burner config"
    exit 1
fi

echo "Set Openshift monitoring vars.."
prometheus_url=$(oc get routes -n openshift-monitoring prometheus-k8s --no-headers | awk '{print $2}')
token=$(oc sa get-token -n openshift-monitoring prometheus-k8s)

echo "Lets Delete ICNI2 workloads.."
kube-burner init -c ${1} -t ${token} --uuid $(uuidgen) --prometheus-url https://${prometheus_url} -m workload/metrics_full.yaml 

echo "Pausing for a minute.."
sleep 60 # sleep for a minute before actual workload

echo "Lets Delete SPK pods.."
kube-burner init -c workload/cfg_delete_icni2_serving_resource.yml -t ${token} --uuid 1234