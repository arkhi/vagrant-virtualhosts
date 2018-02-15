# Vagrant-virtualhosts

Serve multiple websites with one virtual machine, using Apache virtual hosts.

This setup can be useful if the machine you’re on does not have too much memory or space on the hard drive.

## Notes

- Configuration files and URL assume we use the domain name of the website, but any other name should do, as long as it’s consistent.

- The box used is [bento/ubuntu-16.04](https://app.vagrantup.com/bento/boxes/ubuntu-16.04), which is [supported until April 2021](https://wiki.ubuntu.com/#Releases).

- If you need specific apache modules, you can add them in “[.vagrant-virtualhosts/config/apache-modules.cfg](.vagrant-virtualhosts/config/apache-modules.cfg)”.


- If you need specific softwares in the box, you can add them in “[.vagrant-virtualhosts/config/apt-packages.cfg](.vagrant-virtualhosts/config/apt-packages.cfg)”.

- The virtualhost config files are not overwritten when provisioning, so unless you destroy the box, the modifications done on each of them should remain.

- Commands visible in some steps **can be** used to achieve in code what is written in words. These commands will only work in a [POSIX environment](https://en.wikipedia.org/wiki/POSIX#POSIX-oriented_operating_systems). You can copy/paste the whole block and *it **should** work*™.
    ```sh
    echo "Achieve in code what is written in words."
    ```

## Setup a new website (with virtual hosts)

1. Install Virtualbox and VirtualBox “Extension Pack” from [Virtualbox download page](https://www.virtualbox.org/wiki/Downloads).

1. [Install Vagrant](https://www.vagrantup.com/docs/installation/). If you’re using Microsoft Windows, you can either:
    - [Use the command line](https://www.sitepoint.com/getting-started-vagrant-windows/),
    - [Use a Graphic user interface to manage Vagrant](http://vagrantmanager.com/windows/).

1. [Install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) **(optional)**.

1. Retrieve the files from this repository:
    - If you installed git, clone this repository in the directory which will host your websites. We will name this directory “**www**” in this example.
        ```sh
        git clone https://github.com/arkhi/vagrant-virtualhosts.git www;\
        cd www
        ```
    - Otherwise, you can simply [download the files](https://github.com/arkhi/vagrant-virtualhosts/archive/master.zip) and extract the zip file. After extraction, just rename the folder called “vagrant-virtualhosts-master” into “www”.
        ```sh
        wget https://github.com/arkhi/vagrant-virtualhosts/archive/master.zip;\
        unzip master.zip;\
        mv vagrant-virtualhosts-master www;\
        rm master.zip;\
        cd www
        ```

1. In “[.vagrant-virtualhosts/config/websites.cfg](.vagrant-virtualhosts/config/websites.cfg)”, add one line per website you want to run with this machine. Our website has the domain name “**my-website.com**” in this example.
    ```sh
    echo my-website.com >> .vagrant-virtualhosts/config/websites.cfg
    ```
    The file should end up with something like this, if there is already other websites:
    ```sh
    just-a-website.io
    my-other-website.net
    my-website.com
    ```

1. In the [hostfile on the host machine](https://en.wikipedia.org/wiki/Hosts_(file)#Location_in_the_file_system), add `my-website.com.local` to the list following `192.168.50.4 ` (or create the line).
    ```sh
    sudo sed -i 's#192\.168\.50\.4 #192.168.50.4 my-website.com.local #' /etc/hosts
    ```
    The line in the file should end up with something like this:
    ```sh
    192.168.50.4 my-website.com.local my-other_website.net.local just-a-website.io.local
    ```

1. Provision Vagrant to enable the new website. This might take a *long* while if it’s the first time you run `vagrant up`.
    ```sh
    vagrant up --provision
    ```

    If the website’s directory (`my-website.com`) already exists and contain a file called `bootstrap.sh`, this file will be executed at each provisioning. This allows to do whatever is necessary for this specific project, like installing software.

1. Open [http://my-website.com.local](http://my-website.com.local) in your browser.
