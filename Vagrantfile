# This guide is optimized for Vagrant 1.7 and above.
# Although versions 1.6.x should behave very similarly, it is recommended
# to upgrade instead of disabling the requirement below.
Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "generic/rhel7"
  #config.vm.box_version = "1.3.4"
 # config.vm.box = "centos/7"

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/hashicorp/vagrant/issues/5005
  config.ssh.insert_key = false

  #config.vm.provision "ansible" do |ansible|
   # ansible.verbose = "v"
    #ansible.playbook = "../rhel_7_ami/playbook.yml"
    # ansible.galaxy_roles_path = '../rhel_7_ami/roles'
    # ansible.galaxy_role_file = "../rhel_7_ami/requirements.yml"
  #end
end
