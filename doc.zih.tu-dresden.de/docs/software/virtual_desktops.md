# Virtual Desktops

Use WebVNC or NICE DCV to run GUI applications on HPC resources.

|                | WebVNC                                            | DCV                               |
|----------------|-------------------------------------------------------|--------------------------------------------|
| **use case**   | all GUI applications that do **not need** OpenGL      | only GUI applications that **need** OpenGL |
| **partitions** | all\* (except partitions with GPUs (gpu2, hpdlf, ml)  | dcv                                        |

## Launch a Virtual Desktop

| Step | **WebVNC**   | **DCV**              |
|------|--------------|----------------------|
| 1    | Navigate to [https://taurus.hrsk.tu-dresden.de](https://taurus.hrsk.tu-dresden.de). There is our [JupyterHub](../access/jupyterhub.md) instance. |
| 2    | Click on the "advanced" tab and choose a preset: |
| 3    | Optional: Fine tune your session with the available SLURM job parameters or assign a certain project or reservation. Then save your settings in a new preset for future use. |  |
| 4    | Click on `Spawn`. JupyterHub starts now a SLURM job for you. If everything is ready the JupyterLab interface will appear to you. |  |
| 5    | Click on `WebVNC` to start a virtual desktop.  | Click on `DCV` to start a virtual desktop. |
|      | The virtual desktop starts in a new tab or window.  |  |

### Demonstration

<video controls="" width="320" style="border: 1px solid black">
<source src="https://doc.zih.tu-dresden.de/software/misc/start-virtual-desktop-dcv.mp4"
        type="video/mp4" />
<source src="https://doc.zih.tu-dresden.de/software/misc/start-virtual-desktop-dcv.webm"
        type="video/webm" />
</video>

<!--Hier steht ein Video.-->
<!--In der mkdocs.yaml muss aber noch das Plugin mkdocs-video eingetragen werden-->
<!--![type:video](misc/start-virtual-desktop-dcv.mp4)-->

### Using the Quickstart Feature

JupyterHub can start a job automatically if the URL contains certain
parameters.

|              | WebVNC     | DCV   |
|--------------|------------|------------|
| Examples     | [WebVNC](https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'interactive\~cpuspertask\~'2\~mempercpu\~'2583)) | [DCV](https://taurus.hrsk.tu-dresden.de/jupyter/hub/spawn#/>\~(partition\~'dcv\~cpuspertask\~'6\~gres\~'gpu\*3a1\~mempercpu\~'2583)) |
| Description  | `interactive` partition, 2 CPUs with 2583 MB RAM per core, no GPU | `dcv` partition, 6 CPUs with 2583 MB RAM per core, 1 GPU |
| Link creator | Use the spawn form to set your preferred options. The browser URL will be updated with the corresponding parameters. | |

If you close the browser tabs or windows or log out from your local
machine, you are able to open the virtual desktop later again - as long
as the session runs. But please remember that a SLURM job is running in
the background which has a certain time limit.

## Reconnecting to a Session

In order to reconnect to an active instance of WebVNC, simply repeat the
steps required to start a session, beginning - if required - with the
login, then clicking `My Server`, then by pressing the `+` sign on the
upper left corner. Provided your server is still running and you simply
closed the window or logged out without stopping your server, you will
find your WebVNC desktop the way you left it.

## Terminate a Remote Session

| Step | Description |
|------|-------------|
| 1    | Close the VNC viewer tab or window. |
| 2    | Click on File \> Log Out in the JupyterLab main menu. Now you get redirected to the JupyterLab control panel. If you don't have your JupyterLab tab or window anymore, navigate directly to [https://taurus.hrsk.tu-dresden.de/jupyter/hub/home](https://taurus.hrsk.tu-dresden.de/jupyter/hub/home) |
| 3    | Click on `Stop My Server`. This cancels the Slurm job and terminates your session. |

### Demonstration

<video controls="" width="320" style="border: 1px solid black">
<source src="https://doc.zih.tu-dresden.de/software/misc/terminate-virtual-desktop-dcv.mp4"
        type="video/mp4" />
<source src="https://doc.zih.tu-dresden.de/software/misc/terminate-virtual-desktop-dcv.webm"
        type="video/webm" />
</video>

!!! note

    This does not work if you click on the "Logout"-Button in your
    virtual desktop. Instead this will just close your DCV session or cause
    a black screen in your WebVNC window without a possibility to recover a
    virtual desktop in the same Jupyter session. The solution for now would
    be to terminate the whole Jupyter session and start a new one like
    mentioned above.
