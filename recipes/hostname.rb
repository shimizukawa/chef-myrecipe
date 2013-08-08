#
# Cookbook Name:: myrecipe
# Recipe:: hostname
#
# Copyright https://github.com/NarrativeScience/chef-hosts

# Set the hostname to the node.set_fqdn

fqdn = node['set_fqdn']
if fqdn
  fqdn =~ /^([^.]+)/
  hostname = $1

  case node['platform']
  when "redhat", "centos", "fedora", "suse", "amazon"
    bash "update network file" do
      code <<-EOH
          if [ -z `cat /etc/sysconfig/network | grep HOSTNAME` ]; then
                echo "HOSTNAME=#{hostname}" >> /etc/sysconfig/network
          else
                sed -i -e "s/\\(HOSTNAME=\\).*/\\1#{hostname}/" /etc/sysconfig/network
          fi
          hostname #{hostname}
          EOH
      cwd "/tmp"
    end

  when "debian", "ubuntu" 
    service "hostname" do
      action :none
      provider Chef::Provider::Service::Upstart
    end
  
    file "/etc/hostname" do
      content hostname
      notifies :restart, resources("service[hostname]")
    end

  end

else
  Chef::Log.warn('node[:set_fqdn] needed by recipe[myrecipe::hostname].')
end

