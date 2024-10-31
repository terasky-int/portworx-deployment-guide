# Portworx Best Practices

This document provides detailed best practices for Portworx.
---

## 1. How frequently should we upgrade the Portworx cluster?

It is recommended to upgrade the Portworx cluster approximately every 6 months to the latest feature release line to ensure access to new features, bug fixes, and security patches. Additionally, within that release line, apply maintenance updates as they are released to maintain security and stability. Regular upgrades help in keeping compatibility with the latest Kubernetes/OpenShift versions and leveraging the newest Portworx capabilities.

### Additional Resources
* [Portworx Upgrade Recommendations](https://docs.portworx.com/portworx-enterprise/support/support-policy#upgrade-recommendations-and-support-policy)


## 2. Should we use an internal or external KVDB in a bare-metal OpenShift air-gapped environment?

For a bare-metal OpenShift environment in an air-gapped setup, Portworx generally recommends using an **internal KVDB**. This is because:

- **Internal KVDB** simplifies the setup, reducing the dependency on external systems, which is advantageous in isolated or restricted environments.
- **External KVDB** may add complexity in air-gapped environments since it requires additional networking and security configurations to ensure connectivity and redundancy.

However, if you have a robust external KVDB setup that can meet high availability and performance requirements, it can still be a viable option.

## 3. Recommended Disk Configuration for Portworx Storage

- For production environments, use **dedicated SSDs** or NVMe drives for Portworx storage to ensure optimal I/O performance.
- If possible, provision **separate storage for KVDB** to ensure that it has dedicated resources for handling metadata operations. This is especially important if using an internal KVDB.

## 4. Replication Factor for Volumes

- For single-zone clusters, a **replication factor of 2** can provide redundancy, though 3 is preferred when resources allow.
- In multi-zone setups, configure a **replication factor of 3** to ensure high availability and data durability.

## 5. Monitoring and Alerting

- Use **Prometheus and Grafana** to monitor Portworx cluster health and performance.
- Set up **alerts for critical metrics** (e.g., node failures, storage capacity issues) to respond quickly to potential issues.

## 6. Network Configuration Best Practices

- For production clusters, use **separate network interfaces** for data and management traffic to prevent congestion and improve performance.
- Ensure that all nodes in the cluster have low-latency network connectivity, as Portworx performance is heavily dependent on network speed.
