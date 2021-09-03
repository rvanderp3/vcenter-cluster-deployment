# segments="1 2 3 4 5 6 7 8 9 10 11 12"
# segments="13 14 15 16 17 18 19 20 21 22 23 24"

function installOnSegments() {
for segment in $segments; do 
export segment=$segment
INSTALL_DIR=segment-install-$segment 
rm -rf $INSTALL_DIR
mkdir $INSTALL_DIR
cat install-config.yaml | envsubst > $INSTALL_DIR/install-config.yaml
./openshift-install create cluster --dir $INSTALL_DIR &
done
}

function setupRegistry() {
for segment in $segments; do 
INSTALL_DIR=segment-install-$segment 
export KUBECONFIG=$INSTALL_DIR/auth/kubeconfig
oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Managed"}}'
oc patch config.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"rolloutStrategy":"Recreate","replicas":1}}'

oc create -n openshift-image-registry -f - << EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: image-registry-storage 
spec:
  accessModes:
  - ReadWriteOnce 
  resources:
    requests:
      storage: 100Gi
EOF
 oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"pvc": {"claim": "image-registry-storage"}}}}'
 oc wait --for=condition=Available co/image-registry
 done

for segment in $segments; do 
 INSTALL_DIR=segment-install-$segment 
 export KUBECONFIG=$INSTALL_DIR/auth/kubeconfig
 echo Checking segment $segment
oc wait --for=condition=Available co/image-registry
done
}

function setupSccs() {
for segment in $segments; do 
INSTALL_DIR=segment-install-$segment 
export KUBECONFIG=$INSTALL_DIR/auth/kubeconfig
oc adm policy add-scc-to-group anyuid system:authenticated system:serviceaccounts
oc adm policy add-scc-to-group privileged system:authenticated system:serviceaccounts
done
}

function runE2e() {
for segment in $segments; do 
INSTALL_DIR=segment-install-$segment 
export KUBECONFIG=$INSTALL_DIR/auth/kubeconfig
./openshift-tests run openshift/conformance/parallel -o $INSTALL_DIR/e2e.log &
done
}

function destroyClusters() {
for segment in $segments; do 
export segment=$segment
INSTALL_DIR=segment-install-$segment 
# govc object.destroy ibmcitest$segment*
# govc vm.power --off=true ibmcitest$segment* 
./openshift-install destroy cluster --dir $INSTALL_DIR &
done
}

# Restrict installation account to only have access to the segments in one cluster
function restrictPermissions() {
# NETWORKS=$(govc ls /IBMCloud/network/vcs8e-vcs-8e-management-private/ocp-*)
# for NETWORK in $NETWORKS; do govc permissions.set -group=true -principal Installers@vsphere.local -role NoAccess $NETWORK; done

# NETWORKS=$(govc ls /IBMCloud/network/vcs8e-vcs-8e-workload-private/ocp-*)
# for NETWORK in $NETWORKS; do govc permissions.set -group=true -principal Installers@vsphere.local -role NoAccess $NETWORK; done

# NETWORKS=$(govc ls /IBMCloud/network/vcs8e-vcs-lr-ci-workload-private/ocp-*)
# for NETWORK in $NETWORKS; do govc permissions.set -group=true -principal Installers@vsphere.local -role Admin $NETWORK; done
}

function setupRoutesOnProxy() {
  # SEGMENTS="88 89 90 91 92 93"
  # for SEGMENT in $SEGMENTS; do echo ${SEGMENT}; sudo ip route add z.z.${SEGMENT}.0/24 via y.y.y.${SEGMENT}; done
}