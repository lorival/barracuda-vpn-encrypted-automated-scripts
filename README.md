# Barracuda VPN: encrypted automated scripts

> I created this repository to simplify my use of barracuda vpn just with username and password in linux distributions debian based.

The goal is simple, instead of having to enter the username and password every time I want to connect or reconnect to barracuda-vpn, I just enter the ``vpn`` command in the terminal.

One RSA key are created as root and the credentials are stored in a encrypted file using this RSA key.

## Prerequisites

### *ohmyzsh*, *make* and this repository
````
$ sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
$ sudo apt-get install make
$ git clone git@github.com:lorival/barracuda-vpn-encrypted-automated-scripts.git
````

### Barracuda VPN version
The version of the package used here for installing the barracuda-vpn is **5.1.4** from **Feb 13, 2020**.

If you want a different version, do the following:
- Access the [barracuda portal](http://dlportal.barracudanetworks.com/), create a credential and login.
- In the left menu click *NAC / VPN Client* and Download the **Barracuda VPN Client ?.?.? for Linux**
- Unzip the downloaded file and move the .deb file to this directory
- Edit the first line of the *Makefile*, putting the name of the new downloaded file
- Follow the normal installation procedures

## Installation procedures

### 1. Install barracuda-vpn and configure the client
````
$ make install
````
> Your root password will be asked to install it

> After the installation the configuration will open automatically:
> - Go to option "Configure Client"
> - In Authentication select: "User/Pass only"
> - In Server Address add your server
> - "Save configuration" and "Exit"

### 2. Generate your credential files with a new key
````
$ make credentials user=value pwd=value
$ make test
````
> - Replace *value* by your credentials
> - The test is just connect and disconnect showing the log

### 3. Configure the bash
````
$ make zshell-configuration
$ source ~/.zshrc
````
## How to use it

### Connect or reconnect
````
$ vpn
````

### Check vpn status or close
````
$ vpn-status
$ vpn-close
````

## Uninstall procedures
> Do this step before configure a new release of this project

### 1. Remove the credential files and key
````
$ make clean
````

### 2. Edit bash (~/.zshrc)
> Remove the lines between the comment and inclusive the comment: # Used to automate barracuda-vpn

## More commands
````
$ make show-credentials
$ make help
````