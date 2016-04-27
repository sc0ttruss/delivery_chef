# the default location for files for our kitchen setup is in a local share
# ~/chef-kits/chef.  This is mounted to /mnt/share/chef on the target vm
# if you alreddy have these in an rpm repo, set source_files to false
# You can also replae file:// with https:// for remote repos.
default['delivery_chef']['use_package_manager'] = false
default['delivery_chef']['base_package_url'] = 'file:///mnt/share/chef'
default['delivery_chef']['delivery_server_fqdn'] = 'delivery.myorg.chefdemo.net'
default['delivery-chef']['api_fqdn'] = 'chef.myorg.chefdemo.net'
default['delivery_chef']['kitchen_shared_folder'] = '/mnt/share/chef'
# default['delivery-chef']['api_fqdn'] = node['fqdn']

# note the package "name" must match the name used by yum/rpm etc.
# get your package list here https://packages.chef.io/stable/el/7/
default['delivery_chef']['organisation'] = 'myorg'
default['delivery_chef']['packages']['chef-server-core'] = 'chef-server-core-12.5.0-1.el7.x86_64.rpm'
default['delivery_chef']['packages']['manage'] = 'opscode-manage-1.21.0-1.el7.x86_64.rpm'
default['delivery_chef']['packages']['reporting'] = 'opscode-reporting-1.5.6-1.el7.x86_64.rpm'
default['delivery_chef']['packages']['push-jobs'] = 'opscode-push-jobs-server-1.1.6-1.x86_64.rpm'
