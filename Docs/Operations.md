# Operations on Portworx

## Table of Contents

- [Node Removal/Decommission from Cluster](#node-removaldecommission-from-cluster)
- [Enter maintenance mode](#put-node-in-maintenance-mode)
- [Add nodes to cluster](#add-nodes-to-portworx-cluster)

---

## Node Removal/Decommission from Cluster

To decommission a node from the cluster:

1. **Prepare the Node**: Cordon the node, then delete any running pods on it, and add the label `px/enabled: remove` to the node. Ensure all pods are successfully running on other nodes.
2. **Remove Node from Cluster**: Use `pxctl cluster remove`.
3. **Wipe Node Data**:
   - SSH into the node and execute:
     ```bash
     pxctl service node-wipe --all
     ```
   - Stop and disable Portworx, then delete Portworx data and configuration files:
     ```bash
     sudo systemctl stop portworx
     sudo systemctl disable portworx
     rm -rf /etc/pwx/
     umount /opt/pwx/oci
     rm -rf /opt/pwx
     sudo rm -f /etc/systemd/system/portworx*
     ```
   - Identify and wipe disks:
     ```bash
     blkid | grep pxpool
     wipefs -af <disk-name>
     ```
4. **Finalize**: Uncordon the node.

---

## Put node in maintenance mode

The attached guide will provide a detailed explianation on how to put node in a maintenance mode.

**Importent Notes**: 
- When a node enters maintenance mode, all PVCs (Persistent Volume Claims) attached to it will switch to read-only mode.
- For OS upgrade while in maintenance mode - Make sure the kernal is compatible with Portworx. For the [list](https://docs.portworx.com/portworx-enterprise/reference/supported-kernels).

### Additional Resources
* [enter-maintenance-mode](https://docs.portworx.com/portworx-enterprise/operations/operate-kubernetes/troubleshooting/enter-maintenance-mode)

---

## Add nodes to Portworx cluster

In order to add a node to Portworx cluster add the following labels on the node.

```bash
oc label node <node-name> px/service=restart --overwrite
oc label node <node-name> px/enabled=true --overwrite 
```

### Additional Resources
[Add node to Portworx cluster](https://docs.portworx.com/portworx-enterprise/platform/openshift/ocp-bare-metal/operations/k8s-node-rejoin#restart-the-portworx-pod-on-your-node-by-cleaning-up-labels)

---
