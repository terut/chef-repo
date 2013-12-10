#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version = "redis-2.8.2"
deflate_filename = "#{version}.tar.gz"
working_directory = '/tmp/src'

directory working_directory do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

cookbook_file "#{working_directory}/#{deflate_filename}" do
  source "#{deflate_filename}"
  mode 0644
end

bash 'inflate redis' do
  cwd working_directory
  code <<-EOC
    tar -zxf #{deflate_filename}
  EOC
  not_if { File.exist? ("#{working_directory}/#{version}") }
end

bash 'install redis' do
  cwd working_directory
  code <<-EOC
    cd #{version}
    make
    make install
  EOC
  not_if { File.exist? ("/usr/local/bin/redis-server") }
end

directory '/etc/redis' do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

template '/etc/redis/6379.conf' do
  source 'redis.conf'
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/init.d/redis_6379' do
  source 'redis_init_script'
  owner 'root'
  group 'root'
  mode 0755
end

service 'redis_6379' do
  action [ :enable, :start ]
  subscribes :restart, "template[redis.conf]"
end
