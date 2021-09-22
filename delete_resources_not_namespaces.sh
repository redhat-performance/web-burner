#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Pass kube-burner UUID to script"
    exit 1
fi
cat << EOF > cfg_del.yml
jobs:
  - name: remove-objects
    jobType: delete
    objects:
      - kind: Deployment
        labelSelector: {kube-burner-uuid: ${1}}
        apiVersion: apps/v1

      - kind: Pod
        labelSelector: {kube-burner-uuid: ${1}}

      - kind: Secret
        labelSelector: {kube-burner-uuid: ${1}}

      - kind: ConfigMap
        labelSelector: {kube-burner-uuid: ${1}}

      - kind: Service
        labelSelector: {kube-burner-uuid: ${1}}
EOF
kube-burner init -c cfg_del.yml --uuid $(uuidgen)

