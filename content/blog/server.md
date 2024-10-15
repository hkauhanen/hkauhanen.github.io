---
title: "How to set up a server for online experiments"
date: 2023-04-24
draft: true
tags: ["computing", "experiments", "servers", "linux", "diy"]
---

## Motivation

Online experiments are becoming more and more common, and wonderful tools now exist that assist the researcher in setting them up. One common obstacle remains, however, and that pertains to setting up and configuring a server for the online experiment. University departments often lack such dedicated infrastructure, and even when they do have it, guidance, administration and troubleshooting may be difficult to access. On the other hand, using a commercial cloud-based solution may turn out to be too expensive, not flexible enough, or both.

This guide outlines how to set up one's own Linux-based server and how to integrate it with an online experiment coded in jsPsych. This is not overwhelmingly difficult to do, as long as one has some experience using the command line in Linux. The prerequisites are not extensive:

* Suitable server hardware
* A linux distribution
* A domain name
* A working internet connection

For the purposes of this tutorial, I am using an old HP Z400 Workstation which I acquired in FIXME for about 160 euros. It has an Intel Xeon W3680 processor with six cores running at 3.3 GHz and 12 GB of DDR3 RAM. It is not the fastest computer anymore, nor the most economical, but for this price, such a configuration is hard to beat in terms of your bang for buck value. My Z400 has two conventional 250GB hard drives which I am going to set up for RAID mirroring (see below); if you are happy to do away with RAID, then even a single hard drive or SSD suffices.

For the OS I am using Debian 12 (stable, codeword "bookworm"). Most of the following tutorial remains valid for other Linux distributions, although annoyingly things such as the locations of configuration files and the commands for utilizing package managers and such will have to be adapted. (Note that for server applications, stability is paramount: hence I don't recommend using unstable or testing releases of distributions.)


## Step 1: Booting the installer and partitioning disks

After fetching the installation image from <https://debian.org> and burning it onto a suitable installation medium (such as a USB stick), the first step is to boot the computer into the Debian installation program. To do this, you will need to access the computer's BIOS to make sure that the computer boots from your installation medium.

The installer will first ask a few questions about language and locale, and configures network access (I will assume that the computer is physically wired to a router, as most servers would be). After this, the installer asks you to provide the computer's hostname. Here you may already provide your domain name, which for the purposes of this tutorial I will take to be *coolexperiment.com*.

Next, you need to pick a root password as well as make one ordinary user account. Later on, I will assume that you may wish to set a number of virtual hosts on the same server (so as to have it potentially handle more than one website), and will assume that each such virtual host will be assigned a username. Let us assume that the username for the experiment we are now setting up is *myexp*.

Next up, we need to partition the disk(s). If you have just one, empty disk, it makes sense to follow the "Guided - use entire disk" option and let the installer handle partitioning -- and continue to Step 2 below.


## Optional: RAID and LVM

In what follows, however, I am going to assume that two physical hard drives are present, and that we wish to set them up in a RAID-1 configuration. This is a redundancy feature. It simply means that the two hard drives will *mirror* each other: whatever gets written to one gets written to the other as well. This way, damage to one physical hard drive will not lead to irretrievable loss of data. Read more at FIXME.

To do this, we now select "Manual" and proceed to partition the disks manually. In the following dialog box, double-click on the first disk in order to create a new empty partition. Then double-click on the newly appeared "FREE SPACE" in order to divide this into two partitions. First, create a 1 GB primary partition. Use the ext4 file system and set the mount point at /boot. Then allocate the remaining space (in my case, 249 GB) for a second primary partition with file system ext4 and mount point /.

Then carry out the exact same procedure with the second hard drive.

Here is what the partition table on my system looked like after the above steps:

FIXME: image

Next, double-click on "Configure software RAID", select "Yes" and "Continue". Then double-click on "Create MD device", choose "RAID1", give 2 for the number of active devices, 0 for the number of spare devices. Then choose the two /boot partitions as the active devices of the current MD device (in my case, /dev/sda1 and /dev/sdb2).

Then click on "Cread MD device" again to create the second device, which is going to bind the two remaining partitions together. Again, choose "RAID1", give 2 for the number of active and 0 for the number of spare devices, and bind the two remaining partitions (/dev/sda2 and /dev/sdb2).

Finally, select "Finish". After this, the partition table should like something like the following:

FIXME: image

We still need to set up the first RAID device to be used as the /boot partition. To do this, double-click on the free space under it, select to use the space as an ext4 journaling file system, and set the mount point as /boot.

Do *not* finish partitioning yet -- in the next step, we are going to set up LVM.

Next, we are going to set up LVM (Logical Volume Manager) on the second (non-boot) RAID device, so that creating and resizing partitions will be easier in the future, should the need to arise.

To do this, now double-click on "Configure the Logical Volume Manager". Click on "Create volume group" and give it a name, for instance *server*. Then select device /dev/md1 as the device for this volume group. 

Next, we need to create logical volumes for at least the root file system and swap space. We will first create the swap space; since I have 12 GB of RAM, I am going to allocate 16 GB of swap space on the RAID device. To do this, I double-click on "Create logical volume", select the *server* volume group, give the new logical volume the name *server-swap*, and enter 16G as its size. We then repeat these steps to create a volume for the root file system: that is, double-click on "Create logical volume", select *server*, give the new volume the name *server-root* and allocate all remaining space to it. Then double-click "Finish".

At this point, the partition table will look as follows:

FIXME: image

We still need to attach file systems to the logical volumes. To do this, double-click on the free space under *server-root*, choose to use the space as an ext4 journaling file system, and set the mount point as /. Double-click "Done setting up the partition" to return to the partition table. Do the same with *server-swap*, but instead of using it as ext4, select "swap area" instead.

The partitioning table will finally look like this:

FIXME: image

You may now select "Finish partitioning and write changes to disk".


## Step 2: Finishing the installation

The installation should now continue as usual. First, the base system will be installed, after which you will be prompted to select a mirror for use by the package manager. After this, more software is installed.

You will finally reach the "Software selection" dialogue. I am going to assume that no graphical user interface is required -- the computer being a server -- and hence untick the boxes "Debian desktop environment" and "GNOME". However, the boxes "web server", "SSH server", and "standard system utilities" should be ticked:

FIXME: image

The installer will finally ask about where to install the GRUB boot loader; assuming no other operating system is present on the hard drives, you should select "Yes" (install to primary drive), click "Continue", and select /dev/sda as the target.

After a few moments, the installation will complete. Remove the USB stick or other installation medium and click "Continue" to reboot.


## Step 3: First boot

If all went well, you should now be able to log in using either the root password (using *root* as username) or using the non-root user we created (*myexp*). I'm going to assume you log in as root, which will facilitate the following configuration steps.

First, we need to install a few packages that will come in handy later:

```txt
# apt install apache2-mpm-itk certbot net-tools php
```

Since we ticked the "web server" box during installation, a version of Apache is already installed and running. To verify this, use `ifconfig` to display the IP address of your new server:

```txt
# ifconfig
```

Then, using a second computer with internet access, fire up a web browser and navigate to that IP address. You should be greeted with the default Apache Debian landing page:

FIXME: image


## Step 5: Configuring Apache

That default landing page is located in `/var/www/html/index.html`. In principle, you could put all the files you wish to serve from your new server in this directory. In practice, however, it makes sense to configure separate virtual hosts. This makes it possible for one and the same piece of hardware run several different websites simultaneously, should the need to arise.

On Debian, the configuration files for virtual hosts reside in `FIXME`. Debian also provides a suite of commands for administering virtual hosts: in particular, `a2ensite` is used to enable a new site.

Recall how we created a single non-root user during installation, with username `myexp`? I am now going to assume that the virtual host we set up for our online experiment serves files from this user's home directory. For this purpose, we will create a folder for the to-be-served files as well as a folder for log files, and give them the correct permissions:

```txt
# mkdir /home/myexp/www
# chown myexp:myexp /home/myexp/www
# mkdir /home/myexp/www-log
# chmod go-w /home/myexp/www-log
```

Next, we create the file `/etc/apache2/sites-available/coolexperiment.com.conf` with the following contents (recall I'm assuming *coolexperiment.com* for the domain name):

```apache
<VirtualHost * >
    DocumentRoot    /home/myexp/www
    ServerName      coolexperiment.com
    ServerAlias     www.coolexperiment.com
    ErrorLog        /home/myexp/www-log/error.log
    CustomLog       /home/myexp/www-log/access.log combined
    ServerAdmin     EMAIL
    <Directory "/home/myexp/www/">
        AllowOverride All
    </Directory>
</VirtualHost>
```

You should replace `EMAIL` with a valid email address in the above template.

To launch the virtual host, execute the following commands:

```txt
# a2dissite 000-default
# a2ensite coolexperiment.com
# systemctl reload apache2
```


## Step 6: Setting up HTTPS


## Step 7: Installing PHP


## Step 8: A sample experiment


## Optional: MySQL


## Optional: SSH


## How much does it cost?


## Further reading

To figure out the above stuff, I made extensive use of Michael Kofler's excellent Linux book (in German; I understand there is an English edition, but it is seriously *veraltet*):

> Kofler, Michael (2021) *Linux: Das umfassende Handbuch*, 17th edition. ADDRESS: Rheinwerk Computing.
