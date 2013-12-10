home = '/var/lib/jenkins'
target_user = 'jenkins'
target_group = 'jenkins'

directory "#{home}/.ssh" do
  owner target_user
  group target_group
  mode 0700
  action :create
end

template "#{home}/.ssh/config" do
  source 'ssh_config'
  owner target_user
  group target_group
  mode 0700
end

ssh_data = Chef::EncryptedDataBagItem.load('ssh', 'jenkins')

file "#{home}/.ssh/id_dsa" do
  content ssh_data[:private_key]
  action :create
  mode 0600
  owner target_user
  group target_group
end
