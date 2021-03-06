#!/usr/bin/env bash

VHOSTS_PROJECT='/vagrant/.vagrant-virtualhosts'

APACHE_MODULES=$(cat $VHOSTS_PROJECT/config/apache-modules.cfg)
APT_PACKAGES=$(cat $VHOSTS_PROJECT/config/apt-packages.cfg)

WEBSITES_PATH="$VHOSTS_PROJECT/config/websites.cfg"
WEBSITES=$(cat $WEBSITES_PATH)

APACHE_SITES_PATH='/etc/apache2/sites-available'

# Create website config file if it doesn’t already exist.
if [[ ! -s $WEBSITES_PATH ]]; then
    touch $WEBSITES_PATH
fi

# Upgrade the machine and install necessary packages.
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y $APT_PACKAGES
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Install Composer (https://askubuntu.com/a/282376)
if [[ $(command -v php) ]]; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi

# For each virtualhost:
# 1. Create the website directory.
# 2. Create the virtual host configuration file.
for website in $WEBSITES
do
    # Create the website directory.
    mkdir -p /vagrant/$website

    # Create the virtual host configuration file based on the example, if the
    # file does not exist already.
    sudo cp -n $VHOSTS_PROJECT/example.com.conf $APACHE_SITES_PATH/$website.conf

    # Update all references to example.com by the current website.
    sed -i s#example.com#$website#g $APACHE_SITES_PATH/$website.conf

    # Let Apache serve this website.
    sudo a2ensite $website.conf

    echo "The local version of $website is at http://$website.local."

    # Add each project dependencies.
    BOOTSTRAP_FILE="/vagrant/$website/bootstrap.sh"

    if [[ -s $BOOTSTRAP_FILE ]]; then
        echo "$BOOTSTRAP_FILE found."

        sudo chmod +x $BOOTSTRAP_FILE
        $BOOTSTRAP_FILE
    fi
done

# Enable often necessary apache modules.
sudo a2enmod $APACHE_MODULES

sudo service apache2 restart
