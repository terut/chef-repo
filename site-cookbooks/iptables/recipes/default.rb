#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
file_path = '/etc/sysconfig/iptables'

service 'iptables' do
  action [ :enable, :start ]
  supports status: true, restart: true
end

template file_path do
  source 'iptables.erb'
  owner 'root'
  group 'root'
  mode '600'
  notifies :restart, 'service[iptables]'
end
