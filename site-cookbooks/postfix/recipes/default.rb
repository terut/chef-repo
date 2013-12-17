#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/postfix/main.cf' do
  source 'main.cf'
  owner 'root'
  group 'root'
  mode 0644
end

service "mysql" do
  action [ :enable, :start ]
  supports status: true, restart: true, reload: true
  subscribes :restart, "template[main.cf]"
end
