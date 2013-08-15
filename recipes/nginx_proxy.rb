#
# Cookbook Name:: myrecipe
# Recipe:: nginx_proxy
#
# Copyright 2013, Takayuki SHIMIZUKAWA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in wrhiting, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nginx::source"


node.myrecipe.nginx_proxy.sites.each do |site|

  site_name = "#{site['name']}-#{site['ssl'] ? 'https': 'http'}"

  template "#{node['nginx']['dir']}/sites-available/#{site_name}.conf" do
    source      "nginx_proxy.conf.erb"
    owner       'root'
    group       'root'
    mode        '0644'
    variables(
      :site_name        => site_name,
      :host_name        => site['host_name'] || node['fqdn'],
      :host_aliases     => site['host_aliases'] || [],
      :listen_ports     => site['listen_ports'] || [8080],
      :upstream_servers => site['upstream_servers'] || ['localhost:5000'],
      :www_redirect     => site['www_redirect'] || false,
      :max_upload_size  => site['client_max_body_size'] || nil,
      :ssl              => site['ssl'] || false,
      :ssl_name         => site['ssl_name'] || site['name'],
      :ssl_path         => site['ssl_path'] || node.myrecipe.certificates.path || '/etc/ssl/private',
      :basicauth        => site['basicauth'] || nil,
      :locations        => site['locations'] || {},
      :nested_proxy?    => site['nested_proxy'] || false,
    )
  
    if File.exists?("#{node['nginx']['dir']}/sites-enabled/#{site_name}.conf")
      notifies  :restart, 'service[nginx]'
    end
  end
  
  nginx_site "#{site_name}.conf" do
    notifies :restart, "service[nginx]"
  end

end
