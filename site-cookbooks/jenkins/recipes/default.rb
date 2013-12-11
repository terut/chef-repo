#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'java' do
  action :remove
end

package 'java-1.7.0-openjdk' do
  action :install
end

package 'wget' do
  action :install
end

bash 'add repos' do
  code <<-EOC
    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  EOC
  creates '/etc/yum.repos.d/jenkins.repo'
end

package 'jenkins' do
  action :install
end

service 'jenkins' do
  action [ :enable, :start ]
  supports start: true, stop: true, restart: true
end
