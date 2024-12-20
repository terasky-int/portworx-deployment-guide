# Portworx Common Questions

This document provides detailed answers to common questions about Portworx.
---

### 1. Explain the replication mechanism for volume replicas

Portworx uses synchronous replication to maintain data redundancy and ensure high availability. When a volume is created with a specified replication factor (e.g., 3 replicas), Portworx automatically replicates data across different nodes. Each write operation to the volume is mirrored to all replicas in real-time, ensuring data consistency across replicas. This mechanism allows data to remain accessible even if one or more nodes fail, as long as a majority of replicas are still available.

---

### 2. Is the replication synchronous?

Yes, the replication in Portworx is synchronous. This means that all replicas are updated at the same time with each write operation. When data is written to a volume, it is simultaneously replicated to the specified number of replicas. The write operation is only acknowledged as successful once all replicas confirm they have received the data. Synchronous replication ensures data consistency across replicas but may introduce slight latency based on network performance and distance between nodes.

#### Additional Resources
* [Volume creation](https://docs.portworx.com/portworx-enterprise/reference/cli/create-and-manage-volumes#create-volumes)

---

### 3. How does the mechanism deal with whole zone failure? 

If you have a volume with three replicas distributed across three zones and one zone fails, the volume will still be available for reading and writing as long as a majority of the replicas are accessible (i.e., at least two out of three). In this scenario, Portworx’s quorum mechanism allows the volume to stay online as long as more than half of the replicas are active. However, if a second zone were to fail, the volume would become unavailable since quorum would be lost.

To maximize resilience, Portworx leverages a volume placement strategy that spreads replicas across separate failure domains (like availability zones). By distributing replicas across zones, Portworx minimizes the risk of a single failure affecting all copies of the data. If one zone fails, the remaining replicas can continue handling read and write operations. However, if a second zone fails, quorum is lost, making the volume temporarily inaccessible until the failed zones recover or replicas are rebalanced.

#### Additional Resources
* [Volume Placement Strategy](https://docs.portworx.com/portworx-enterprise/operations/operate-kubernetes/storage-operations/create-pvcs/volume-placement-strategies)

---

### 4. When does the operator use NFS?

Shared Storage Volumes: Portworx can create shared volumes (enabled with "sharedv4") using NFS to allow multiple pods or nodes to mount the same volume concurrently. This is useful for applications that require simultaneous read/write access from multiple instances, like certain databases or web applications.

Note that NFS volumes in Portworx may not provide the same level of performance or consistency as replicated block volumes.

---

### 5. What is the role of each pod in the operator?

In a typical Portworx deployment, several pods have specific roles to manage and maintain the storage cluster:

- **Portworx Pod**: This is the main storage pod that manages storage resources, handles data replication, and provides block and file storage services to applications.
- **Stork Pod**: Stork (Storage Orchestration Runtime for Kubernetes) assists with scheduling, disaster recovery, and migration of applications using Portworx. It helps to ensure high availability and data resilience.
- **KVDB Pod**: If using an internal KVDB, this pod provides a distributed key-value store to manage the state and metadata of the Portworx cluster. External KVDB configurations will rely on an external key-value store instead.
- **Portworx Operator Pod**: The operator pod automates the installation, updates, and management of Portworx components on the cluster.
  
Each pod plays a critical role in ensuring that Portworx runs reliably, supports storage orchestration, and maintains high availability.

---

### 6. Explanation of `storkctl` and `stork` usage in Portworx

**storkctl** is a command-line interface for managing Stork, the Portworx storage orchestrator. Stork integrates tightly with Kubernetes and provides advanced scheduling, disaster recovery, and migration capabilities for stateful applications.

**Usage**:
- **Volume Snapshots**: Storkctl allows users to create and manage snapshots of volumes, enabling point-in-time recovery and backups.
- **Disaster Recovery**: Stork facilitates application failover and replication across clusters, allowing you to set up backup policies and disaster recovery workflows.
- **Application Migration**: It supports migration of applications and their data from one Kubernetes cluster to another, useful for cloud migration and hybrid cloud setups.

Stork works as an extension to Kubernetes, enhancing the capabilities of Portworx to handle storage-specific requirements for containerized applications.

#### Additional Resources
* [Stork](https://docs.portworx.com/portworx-enterprise/operations/operate-kubernetes/storage-operations/stork)

---

### 7. What is the recommended size for a KVDB dedicated disk?

The recommended size for a dedicated KVDB disk is depended on:
* If IOPS are independent of disk size, the **minimum recommended size is 32 GB and a minimum of 450 IOPs**.
* If IOPS are dependent on disk size, the **recommended size is 150 GB to ensure you get a minimum of 450 IOPs**.

#### Additional Resources
* [Internal KVDB for Portworx on bare metal](https://docs.portworx.com/portworx-enterprise/platform/kubernetes/bare-metal/bare-metal/operations/kvdb-for-portworx/internal-kvdb)


--- 

### 8. What are the images that the operator consists of?

[List of all the images](./portworx-images.md)

#### Additional Resources
* https://install.portworx.com/PORTWORX_VERSION/air-gapped?kbver=KUBERNETES_VERSION

--- 

### 9. What are the images that the PX-Central consists of?

[List of all the images](./px-central-images.md)

#### Additional Resources
* [PX-Central Images List](https://github.com/portworx/helm/blob/master/raw_images_list.txt)

--- 

### 10. Set Portworx parameters to immediately replicate a volume back to two replicas without waiting 24 hours

1. **`repl-move-timeout`**:
    **Time threshold**, defaults to 24 hours (1440 minutes).
    Note: Set to 10 minutes (per Portworx recommendation).

2. **Do not adjust** `repl-move-timestamp-records-threshold` (per Portworx recommendation).
    **Data threshold**, based on the amount of data needing resync, approximately XX GB.
    Note: **Do not adjust** (per Portworx recommendation).

---

### 11. What happens if overprovisioning occurs and space runs out in a PVC.

The storage system has two thresholds:

- **80% Capacity**: When storage reaches 80% usage, an alert is triggered.
- **90% Capacity**: At 90% usage, the volume will switch to read-only mode by default.

Notes: 
* The thresholds can be modifyed.
* In order to get the volume out of read-only mode:
    - Run **pxctl volume update <new_size>**, then restart the pod.

---

### 12. What happens if overprovisioning occurs and space runs out in the storage pool.

#### Additional Resources
* [Implications on environment](https://docs.portworx.com/portworx-enterprise/operations/operate-kubernetes/storage-operations/manage-storagepool.html#implications-of-a-full-pool)

---

### 13. Do I actuuly need all the images?

Per Portworx recommendation, yes all the images are needed.

---

### 14. How to set up monitoring?

Follow the guide below

#### Additional Resources
* [Monitoring in Portworx](https://docs.portworx.com/portworx-enterprise/platform/openshift/ocp-bare-metal/set-ocp-prometheus)

---

This concludes the common questions on Portworx. For further assistance, please consult the Portworx documentation or contact support.