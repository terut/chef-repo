#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version = '5.5.35-1'
suffix = 'el6.x86_64.rpm'

config_file_path = '/etc/my.cnf'
mysql_home = '/var/lib/mysql'
%w{ MySQL-shared MySQL-client MySQL-devel MySQL-server }.each do |pkg|
  filename = "#{pkg}-#{version}.#{suffix}" 
  cookbook_file "/tmp/#{filename}" do
    source "#{filename}"
    mode 0644
    # TODO checksum
  end

  package pkg do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{filename}"
    options "--force"
  end
end

template config_file_path do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode 0644
end

execute 'mysql_install_db' do
  command 'mysql_install_db'
  action :run
  not_if { File.exists?("#{mysql_home}/mysql/user.frm") }
end

service "mysql" do
  action [ :enable, :start ]
  supports status: true, restart: true, reload: true
  subscribes :restart, "template[my.cnf]"
end

mysql_jenkins = Chef::EncryptedDataBagItem.load('mysql', 'jenkins')

bash 'mysql_secure_installation' do
  code <<-EOC
    mysqladmin drop test -f
    mysql -e "DELETE FROM mysql.user WHERE User='';"
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -e "SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{mysql_jenkins[:root_password]}')"
    mysql -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{mysql_jenkins[:root_password]}')"
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{mysql_jenkins[:root_password]}')"
    mysqladmin flush-privileges -p#{mysql_jenkins[:root_password]}
  EOC
  action :run
  only_if "mysql -u root -e 'show databases'"
end
