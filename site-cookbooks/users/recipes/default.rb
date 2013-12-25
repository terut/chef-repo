#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'ruby-shadow' do
  action :install
end

user 'dev' do
  comment 'developer'
  home '/home/dev'
  shell '/bin/bash'
  password '$1$YS/DvM0r$UaP1QrRms1m8QvzC5ZjKo1'
  supports manage_home: true
  action [:create, :manage]
end

group 'wheel' do
  action :modify
  members ['dev']
  append true
end

template '/etc/sudoers.d/users' do
  source 'users.erb'
  owner 'root'
  group 'root'
  mode 0440
end
