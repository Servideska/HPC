# Access to ZIH Systems

There are several different ways to access ZIH systems depending on the intended usage:

* [SSH connection](ssh_login.md) is the classical way to connect to the login nodes and work from
    the command line to set up experiments and manage batch jobs
* [Desktop Cloud Visualization](desktop_cloud_visualization.md) provides a virtual Linux desktop
  with access to GPU resources for OpenGL 3D applications
* [WebVNC service](graphical_applications_with_webvnc.md) allows better support for graphical
   applications than SSH with X forwarding
* [JupyterHub service](jupyterhub.md) offers a quick and easy way to work with Jupyter notebooks on
   ZIH systems.

!!! hint

    Prerequisite for accessing ZIH systems is a HPC project and a login. Please refer to the pages
    within [Application for Login and Resources](../application/overview.md) for detailed
    information.

For security reasons, ZIH systems are only accessible for hosts within the domains of TU Dresden.

To access the ZIH systems from outside the campus networks it is recommended to set up a Virtual
Private Network (VPN) connection to enter the campus network. While active, it allows the user
to connect directly to the HPC login nodes.

For more information on our VPN and how to set it up, please visit the corresponding
[ZIH service catalog page](https://tu-dresden.de/zih/dienste/service-katalog/arbeitsumgebung/zugang_datennetz/vpn).

The page [key fingerprints](key_fingerprints.md) holds the up-to-date fingerprints for the login
nodes. Make sure they match.