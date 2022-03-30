# Connecting with SSH

## Connecting from Windows with PuTTY

Homepage: https://www.putty.org

### 1. Download and install PuTTY

To download go https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

Picture putty_download.png

Pick the installer suiting best your current system and run it afterwards. Follow the instructions
and finish the process. You should be able to see the following interface after starting the PuTTYapplication.

Picture putty_config

### 2. Start a new ssh-seccion

2.1 Quick start

1) Open PuTTY and insert the IP or hostname into the specified textbox and change the port as
needed.

Picture putty_quickstart

2) Click "Open" to start your new session. A Terminal will open up as new window. This action will do
basicly the same as using the command `ssh taurus.hrsk.tu-dresden.de:22` on a linux system.

Picture putty_login

3) After inserting your ZIH-Login and password it will log you into the targeted system.

2.2 Configured session

You can preconfigure some values to save time while the login in the future

Step 1 - Define the connection target

We start again by defining the hostname or IP and the port we want to connect to. But this time
we wont just open the session right away.

Picture putty_config1

Step 2 - Set an username

Use the tree-navigation on the left side to navigate to `Connection`->`Data`. There you will find a
textbox, which allows to set an `Auto-login username`. After entering your username the
application will basicly perform the same action as the command `ssh user@taurus.hrsk.tudresden.de:22` on a linux system.

Picture_putty_config2

Step 3 - Set a SSH-key

**Note**: For being able to use a ssh-key to lo into a system, you have to register the key on the
system before! Simply add the public-key to `~/.ssh/authorized_keys` and use the following
format.


```console
# <key-type> <public key> <comment>
ssh-ed25519 <public key> myuser@mylocalhost
```
To configure the ssh-key to use, naviagte to `Connection-SSH-Auth`. You will see a Textbox for `Private key file for authentifikation`. Insert the path to your local key-file or brows it using the `Browse...` Button. This will do the same as the command `ssh -i .ssh/id_red25519 user@taurus.hrsk.tudresden.de:22` on a linux system.

Picture purry_config3

Step 4 - Enable X-Forwarding (optional)

To enable X-forwarding navigate to `Connection`->`SSH`->`X11`. You will find a checkbox for `Enable X11 forwarding`. Simply put the tick in the checkbox and continue.

Picture putty_x11

Step 5 - Store your configuration

To store your current built configuration go back to the `session`-tab. There you can set a custom
name to store your configuration as. Insert this name into the `Saved Sessions`-Textbox. The Click
the `Save`-Button.

Picture putty_save

Afterwards you will see the configuration in the Listbox below.

**Note**: You can start a configured session by doubleclicking its name inside the listbox.

**Note**: You can alter your saved configurations by selecting its name inside the listbox and clicking
the `Load`-Button. To save the changes you have to save it again under the same name. This will
overwrite the old configuration permanetly.

**Note**: To deleted a configuration you have to select the session inside the listbox and click the
`Delete`-Button. This will remove the configured session permanetly.

## SSH Key Fingerprints

The page [key fingerprints](key_fingerprints.md) holds the up-to-date fingerprints for the login
nodes. Make sure they match.
