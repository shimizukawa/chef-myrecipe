#
# Cookbook Name:: myrecipe
# Recipe:: users
#
# Copyright 2013, Takayuki SHIMIZUKAWA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

env_name = node.my_environment #FIXME: chef-solo (11.4.4) did not support "node.chef_environment" yet.
node_name = node.name
hosts_item = data_bag_item('hosts', env_name)
hosts_names = [node_name]

if hosts_item
  id, h = hosts_item.find do |id, h|
    ([id, id.split('.').first] + (h['aliases'] || [])).include?(node_name)
  end
  hosts_names = ([id] + (h['aliases'] || [])) if h
end

envnode_matcher = /^(#{env_name}|\*)\/(#{hosts_names.join('|')}|\*)$/

node.users.each do |user|
  if data_bag('users').include? user
    user_data = data_bag_item('users', user)
  else
    user_data = {}
  end

  if data_bag('secrets').include? user
    secrets = Chef::EncryptedDataBagItem.load('secrets', user)
  else
    secrets = {}
  end

  home_path = user_data['home']
  unless home_path
    if user == 'root'
      home_path = "/root"
    else
      home_path = "/home/#{user}"
    end
  end

  ssh_path = "#{home_path}/.ssh"

  directory ssh_path do
    owner user
    group user
    mode "0700"
  end

### .ssh/(keys as id_rsa)

  (secrets['keys'] || []).each do |secret|
    envnode = secret['envnode'] || ['*/*']
    next unless envnode.any?{|en| en =~ envnode_matcher}

    file "#{ssh_path}/#{secret['name']}" do
      content secret['priv']
      owner user
      group user
      mode "0600"
    end

    file "#{ssh_path}/#{secret['name']}.pub" do
      content secret['pub']
      owner user
      group user
      mode "0644"
    end

  end

## temporary

  file "#{ssh_path}/id_dsa" do
    action :delete
  end
  file "#{ssh_path}/id_dsa.pub" do
    action :delete
  end

### .ssh/config

  if user_data['config']
    config_entries = user_data['config'].select do |entry|
      envnode = entry.delete('envnode') || ['*/*']
      envnode.any?{|en| en =~ envnode_matcher}
    end
    entries = config_entries.map do |entry|
      hosts = [entry.delete('Host')] + (entry.delete('aliases') || [])
      hosts.map do |host|
        t = ["Host #{host}"]
        entry.each{|k,v| t << "  #{k} #{v}"}
        t << ""
        t.join("\n")
      end.join("\n")
    end.join("\n")
    
    file "#{ssh_path}/config" do
      content entries
      owner user
      group user
      mode "0644"
    end
  end

### .ssh/authorized_keys

  if user_data['authorized_keys']
    authkey_entries = user_data['authorized_keys'].select do |entry|
      envnode = entry.delete('envnode') || ['*/*']
      envnode.any?{|en| en =~ envnode_matcher}
    end
    ssh_keys = authkey_entries.map{|entry| entry['keys']}.flatten
    
    template "#{ssh_path}/authorized_keys" do
      owner user
      group user
      mode "0644"
      variables ({
        :ssh_keys => ssh_keys,
        :user => user,
      })
    end
  end

end
