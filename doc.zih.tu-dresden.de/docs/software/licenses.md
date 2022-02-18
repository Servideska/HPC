# External Licenses

It is possible (please [contact the support team](../support/support.md) first) for users to install
their own software and use their own license servers, e.g. FlexLM. The outbound IP addresses from
ZIH systems are:

- compute nodes: NAT via 141.76.3.193
- login nodes: 141.30.73.102-141.30.73.105

The IT department of the external institute has to open the firewall for license communications
(might be multiple ports) from ZIH systems and enable handing-out license to these IPs and login.

The user has to configure the software to use the correct license server. This can typically be done
by environment variable or file.

!!! attention

    If you are using software we have installed, but bring your own license key (e.g.
    commercial ANSYS), make sure that to substitute the environment variables we are using as default!
    (To verify this, run `printenv|grep licenses` and make sure that you dont' see entries refering to
    our ZIH license server.)

## How to adjust the license setting

Most programs, that work with the FlexLM license manager,
can be instructed to look for another license server,
by overwriting the environment variable "LM_LICENSE_SERVER".
Do note that not all proprietary software looks for that environment variable.

!!! example "Changing the license server"
    ```console
    marie@compute$ export LM_LICENSE_SERVER=12345@example.com
    ```
    Here "12345" is the port on which the license server is listening,
    while "example.com" is the network addresss of the license server.

Some licensed software comes with a license file,
it can be similarly specified like this:

!!! example "Changing license"
    ```console
    export LM_LICENSE_SERVER=/path/to/my/license/file.dat
    ```
