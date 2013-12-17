#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
home = '/var/lib/jenkins'
target_user = 'jenkins'
target_group = 'jenkins'

# Setup build environment
# Debian: build-essential autoconf libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev git
# CentOS: gcc-c++ openssl-devel readline libyaml-devel readline-devel zlib zlib-devel
%w{ gcc-c++ openssl-devel readline libyaml-devel readline-devel zlib zlib-devel git-core curl }.each do |pkg|
  package pkg do
    action :install
  end
end

git "#{home}/.rbenv" do
  repository 'git://github.com/sstephenson/rbenv.git'
  reference 'master'
  action :checkout
  user target_user
  group target_group
end

directory "#{home}/.rbenv/plugins" do
  owner target_user
  group target_group
  mode '0755'
  action :create
end

git "#{home}/.rbenv/plugins/ruby-build" do
  repository 'git://github.com/sstephenson/ruby-build.git'
  reference 'master'
  action :checkout
  user target_user
  group target_group
end

bash 'setup enviroment variables' do
  user target_user
  group target_group
  environment 'HOME' => home
  code <<-EOC
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    echo 'eval "$(rbenv init -)"' >> ~/.profile
  EOC
  not_if "grep 'rbenv init' ~/.profile", environment: { 'HOME' => home }
end

bash 'install ruby' do
  user target_user
  group target_group
  environment 'HOME' => home
  code <<-EOC
    . ~/.profile
    rbenv install 2.0.0-p353
    rbenv global 2.0.0-p353
  EOC
  not_if "sudo -u #{target_user} sh -c 'cd ~/;. ~/.profile; rbenv versions | grep 2.0.0-p353'"
end

template "#{home}/.gemrc" do
  source '.gemrc'
  owner target_user
  group target_group
  mode'0644' 
end

bash 'install bundle' do
  user target_user
  group target_group
  environment 'HOME' => home
  code <<-EOC
    . ~/.profile
    gem install bundle
  EOC
  not_if "sudo -u #{target_user} sh -c 'cd ~/;. ~/.profile; gem list | grep bundler'"
end

bash 'update rake' do
  user target_user
  group target_group
  environment 'HOME' => home
  code <<-EOC
    . ~/.profile
    gem update -f rake
    gem cleanup
  EOC
end
