# Elemental 3 demo based on openSUSE Tumbleweed

This is just a repository to keep an openSUSE Tumbleweed single node demo for Elemental3.

From the checkout folder just run the build script:

```bash
$ ./build_cmd.sh
```

The script requires all container images required for the build to be already preloaded in to the container
store. By default the script assumes the rootless podman container store is being used. Elemental requires
the podman socket to be active and available to interact with the local storage.

The podman user service can be easily started with `systemctl --user start podman.service`.

Finally, the script also assumes a default libvirt setup (tested on openSUSE TW only) including
virt-install utility.
