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

# start all the services

bash 'start all the chef services' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  chef-server-ctl reconfigure
  opscode-push-jobs-server-ctl reconfigure
  EOH
end

bash 'start all the chef services' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  opscode-manage-ctl reconfigure --accept-license
  opscode-reporting-ctl reconfigure --accept-license
  EOH
end

template '/etc/opscode/chef-server.rb' do
  source 'server.rb.erb'
  owner 'opscode'
  group 'root'
  mode 00640
end

bash 'start all the chef services' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  chef-server-ctl reconfigure
  EOH
end

# Create a Chef user for Delivery to use
# Create an organisation
# Add delivery to myorg

bash 'create a delivery user on the chef Server' do
user 'root'
cwd '/tmp'
code <<-EOH
chef-server-ctl user-create delivery Delivery myorg delivery@email.fake random_password  --filename /etc/opscode/delivery.pem
chef-server-ctl org-create myorg 'myorg' --association_user delivery --filename myorg-validator.pem
chef-server-ctl org-user-add myorg delivery
EOH
end

# copy credentials somewhere safe, needs more work,
# will be fine in testkitchen, but nowhere else

remote_file '/mnt/share/chef/delivery.pem' do
  source 'file:///etc/opscode/delivery.pem'
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['delivery_chef']['kitchen_shared_folder']}") }
  # checksum 'abc123'
end

remote_file '/mnt/share/chef/supermarket.json' do
  source 'file:///etc/opscode/oc-id-applications/supermarket.json'
  owner 'root'
  group 'root'
  mode 00755
  only_if { ::File.directory?("#{node['delivery_chef']['kitchen_shared_folder']}") }
  # checksum 'abc123'
end
