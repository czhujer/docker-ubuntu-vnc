# Ubuntu Desktop in Docker

Ubuntu 22.04 in Docker with novnc in the simplest way.

### Features


### Run
- build the image
```shell
make podman-build
```

- check the image
```
$ podman manifest inspect ubuntu-vnc
{
    "schemaVersion": 2,
    "mediaType": "application/vnd.oci.image.index.v1+json",
    "manifests": [
        {
            "mediaType": "application/vnd.oci.image.manifest.v1+json",
            "size": 2571,
            "digest": "sha256:4703776162dd427d07579f2ef9090a79b1598ad15e1360c14e3113bcb2570180",
            "platform": {
                "architecture": "amd64",
                "os": "linux"
            }
        }
    ]
}
```
