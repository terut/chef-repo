#
# Cookbook Name:: rails
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{ libxml2-devel libxslt-devel ImageMagick-devel xorg-x11-server-Xvfb }.each do |pkg|
  package pkg do
    action :install
  end
end

filename = "atrpms-repo-6-6.el6.x86_64.rpm"

cookbook_file "/tmp/#{filename}" do
  source "#{filename}"
  mode 0644
  # TODO checksum
end


bash 'add atrpms repos' do
  code <<-EOC
    rpm -i /tmp/#{filename}
  EOC
  creates '/etc/yum.repos.d/atrpms.repo'
end

package 'qt47-webkit-devel' do
  action :install
  options '--enablerepo=atrpms-testing'
  not_if { File.exist?('/usr/bin/qmake-qt47') }
end

# capybara-webkit >~ 1.0.0
%w{ qt5-qtwebkit-devel boost-devel libcurl-devel }.each do |pkg|
  package pkg do
    action :install
  end
end
