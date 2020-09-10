# Barracuda VPN: encrypted automated scripts

> I created this repository to simplify my use of barracuda vpn by accessing with username and password in linux distributions based on debian.

The goal is simple, instead of having to enter the username and password every time you want to connect or reconnect to barracuda-vpn, just enter the ``vpn`` command in the terminal.

The password is stored in encrypted way and to decrypt you will need your root password.

Instead of memorizing the username and password, you only need to know your root password and only the first time you open a terminal session.

## Prerequisites

### Install *make* and clone this repository
````
$ sudo apt-get install make
$ git clone git@github.com:lorival/barracuda-vpn-encrypted-automated-scripts.git
````

### Barracuda VPN version
The version of the package used here for installing the barracuda-vpn is **5.1.4** from **Feb 13, 2020**.

If you want a different version, do the following:
- Access the [barracuda portal](http://dlportal.barracudanetworks.com/), create a credential and login.
- In the left menu click *NAC / VPN Client* and Download the **Barracuda VPN Client ?.?.? for Linux**
- Unzip the downloaded file and move the .deb file to this directory
- Edit the first line of the Makefile, putting the name of the new downloaded file
- Follow normal installation procedures

## Installation procedures

### 1. Install the barracuda-vpn
````
$ make install
````

### 2. Generate your credential files with a new key
````
$ make credentials user=value pwd=value
$ make test
````
> - Replace *value* by your credentials
> - The root password will be ask to change the owner key to root

### 3. Test the connection
````
$ make test
````
> The test is just connect and disconnect showing the log

### 4. Configure the bash
````
$ make configuration
$ source ~/.zshrc
````

## How to use it

### Connect or reconnect
````
$ vpn
````
> Every new terminal session, you will need to enter your root password for the first time

### Check vpn status or close
````
$ vpn-status
$ vpn-close
````

## Uninstall procedures

### 1. Remove the credential files and key
````
$ make clean
````
> This will remove the credential files and the key

### 2. Edit bash (~/.zshrc)
> Remove the lines between the comment: # Used to automate barracuda-vpn

## Help
````
$ make help
````