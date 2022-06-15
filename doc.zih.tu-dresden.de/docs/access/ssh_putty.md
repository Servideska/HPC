# Connecting from Windows with PuTTY

PuTTY is a free and open-source terminal emulator, serial console and network file transfer
application, supports several network protocols, including SCP, SSH. Visit the
[homepage](https://www.putty.org) for more information.

## Download and install

Download the installer suiting best your current system and run it afterwards. Follow the
instructions for installation.

![Downloading PuTTY](misc/putty1_download.png) 

## Start a new SSH session

1.  Start PuTTY and insert the "Host Name" (`taurus.hrsk.tu-dresden.de`) and leave the default
    port (22).

    ![Settings for SSH connection in PuTTY](misc/putty2_quickstart.png)

1.  Click "Open" to start a new session. A terminal window will open up.

    ![Login in PuTTY](misc/putty3_login.png)

1.  After entering your ZIH login and password you will be logged in to one of the login nodes.

## Configured start a new SSH session

You can preconfigure some values. It will save your time during your connections in the future.

1. Define the connection target. To do so, start PuTTY, define the hostname (taurus.hrsk.tu-dresden.de) and the port (22).

![Settings for SSH connection in PuTTY](misc/putty2_quickstart.png)

2. Set your user name. For that choose the tab "Connection" &#8594; "Data" in the navigation tree on the left.
Insert your user name into the text field "Auto-login username".
The application will basically perform the same action as the command `ssh marie@taurus.hrsk.tudresden.de:22` in Terminal.

![Auto-login username in PuTTY](misc/putty4_username.png)

3. Set a SSH-key (optional and recommended for security reason).

    **Note**: For being able to use a SSH key to login to HPC, you have to register the key on the
    system before!

    Add the public-key to `~/.ssh/authorized_keys` and use the following format.

    ```console
    # <key-type> <public key> <comment>
    ssh-ed25519 <public key> myuser@mylocalhost
    ```

    To configure the SSH key to use, navigate to "Connection" &#8594; "SSH" &#8594; "Auth" in the tree left.
    You will see a text field for "Private key file for authentification".
    Insert the path to your local key-file or brows it using the button "Browse...".
    This will do the same as the command `ssh -i .ssh/id_red25519 marie@taurus.hrsk.tudresden.de:22` in Terminal.

![SSH-key in PuTTY](misc/putty5_key.png)

4. Enable X-forwarding (optional). To do so, navigate to "Connection" &#8594; "SSH" &#8594; "X11" in the tree left. Put the tick in the checkbox for "Enable X11 forwarding".

![X-forwarding in PuTTY](misc/putty6_x11.png)

1. Save your configurations. Go back to the "Session" in the tree left. Insert a name into the text field "Saved Sessions" and click
the button "Save". Afterwards you will see the name in the list below.

![Saving settings in PuTTY](misc/putty7_save.png)

Now, you can start a configured session by double-clicking its name in the list.

You can change your saved configuration by selecting its name in the list and clicking the button
"Load". Make your changes and save it again under the same name. This will overwrite the old
configuration permanently.

You can delete a saved configurations by clicking the button "Delete". This will remove the
configured session permanently.

**Enjoy!**
