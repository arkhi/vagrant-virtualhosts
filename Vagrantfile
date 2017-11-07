Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.host_name = "localhost"
  config.vm.hostname = "ubuntu-16.04"
  config.vm.post_up_message = "You can access the box with http://192.168.50.4/ or with any of the vhosts."

  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.synced_folder "./", "/vagrant",
    id: "vagrant-root",
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"],
    nfs: false

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 3306, host: 3307

  config.vm.provision :shell, path: ".vagrant-virtualhosts/bootstrap.sh"

  config.vm.provider :virtualbox do |vb|
    vb.name = "ubuntu-16.04"
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end

