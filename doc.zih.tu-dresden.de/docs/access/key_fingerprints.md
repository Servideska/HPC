# Key Fingerprints

!!! hint

    The key fingerprints of login and export nodes can occasionally change. This page holds
    up-to-date fingerprints.

## Login Nodes

The following hostnames can be used to access ZIH systems:

- `taurus.hrsk.tu-dresden.de`
- `tauruslogin3.hrsk.tu-dresden.de`
- `tauruslogin4.hrsk.tu-dresden.de`
- `tauruslogin5.hrsk.tu-dresden.de`
- `tauruslogin6.hrsk.tu-dresden.de`

All of these login nodes share common keys. When connecting, please make sure that the fingerprint
shown matches one of the table.

| Key type | Fingerprint                                         |
|:---------|:----------------------------------------------------|
| RSA      | SHA256:/M1lW1KTOlxj8UFZJS4tLi+8TyndcDqrZfLGX7KAU8s  |
| RSA      | MD5:b8:e1:21:ed:38:1a:ba:1a:5b:2b:bc:35:31:62:21:49 |
| ECDSA    | SHA256:PeCpW/gAFLvHDzTP2Rb93NxD+rpUsyQY8WebjQC7kz0  |
| ECDSA    | MD5:47:7e:24:46:ab:30:59:2c:1f:e8:fd:37:2a:5d:ee:25 |
| ED25519  | SHA256:nNxjtCny1kB0N0epHaOPeY1YFd0ri2Dvt2CK7rOGlXg  |
| ED25519  | MD5:7c:0c:2b:8b:83:21:b2:08:19:93:6d:03:80:76:8a:7b |
{: summary="List of valid fingerprints for login nodes"}

??? example "Connecting with SSH"

    ```console
    marie@local$ ssh taurus.hrsk.tu-dresden.de
    The authenticity of host 'taurus.hrsk.tu-dresden.de (141.30.73.105)' can't be established.
    ECDSA key fingerprint is SHA256:PeCpW/gAFLvHDzTP2Rb93NxD+rpUsyQY8WebjQC7kz0.
    Are you sure you want to continue connecting (yes/no)?
    ```

    In this case, the fingerprint matches the one given in the table. Thus, one can proceed by
    typing 'yes'.

## Export Nodes

The following hostnames can be used to transfer files to/from ZIH systems:

- `taurusexport.hrsk.tu-dresden.de`
- `taurusexport3.hrsk.tu-dresden.de`
- `taurusexport4.hrsk.tu-dresden.de`

All of these export nodes share common keys. When transfering files, please make sure that the
fingerprint shown matches one of the table.

| Key type | Fingerprint                                         |
|:---------|:----------------------------------------------------|
| RSA      | SHA256:Qjg79R+5x8jlyHhLBZYht599vRk+SujnG1yT1l2dYUM  |
| RSA      | MD5:1e:4c:2d:81:ee:58:1b:d1:3c:0a:18:c4:f7:0b:23:20 |
| ECDSA    | SHA256:qXTZnZMvdqTs3LziA12T1wkhNcFqTHe59fbbU67Qw3g  |
| ECDSA    | MD5:96:62:c6:80:a8:1f:34:64:86:f3:cf:c5:9b:cd:af:da |
| ED25519  | SHA256:jxWiddvDe0E6kpH55PHKF0AaBg/dQLefQaQZ2P4mb3o  |
| ED25519  | MD5:fe:0a:d2:46:10:4a:08:40:fd:e1:99:b7:f2:06:4f:bc |
{: summary="List of valid fingerprints for export nodes"}
