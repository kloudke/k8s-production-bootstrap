all:
  hosts:
    %{ for index, name in vm_names ~}
    ${name}:
      ansible_host: ${vm_ips[index]}
      ip: ${vm_ips[index]}
      access_ip: ${vm_ips[index]}
    %{ endfor ~}
  children:
    kube_control_plane:
      hosts:
        %{ for name in vm_names ~}
        ${name}:
        %{ endfor ~}
    kube_node:
      hosts:
        %{ for name in vm_names ~}
        ${name}:
        %{ endfor ~}
    etcd:
      hosts:
        %{ for name in vm_names ~}
        ${name}:
        %{ endfor ~}
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}