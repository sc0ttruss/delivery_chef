#
# Cookbook Name:: delivery_chef
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install the chef package(s)


node['delivery_chef']['packages'].each do |name, versioned_name|
  unless node['delivery_chef']['use_package_manager']
    remote_file "/var/tmp/#{versioned_name}" do
      source "#{node['delivery_chef']['base_package_url']}/#{versioned_name}"
    end
  end
  package name do
    unless node['delivery_chef']['use_package_manager']
      source "/var/tmp/#{versioned_name}"
    end
    action :install
  end
end # Loop

template '/etc/opscode/server.rb' do
  source 'server.rb.erb'
  owner 'root'
  group 'root'
  mode 00744
end

# start all the services

bash 'start all the chef services' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  chef-server-ctl reconfigure
  opscode-push-jobs-server-ctl reconfigure
  chef-manage-ctl reconfigure
  EOH
end
#
# bash 'create a delivery user on the chef Server' do
#  user 'root'
#  cwd '/tmp'
#  code <<-EOH
#  chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' --filename FILE_NAME
#  chef-server-ctl org-create short_name 'full_organization_name' --association_user user_name --filename ORGANIZATION-validator.pem
#  EOH
# end
#
#
