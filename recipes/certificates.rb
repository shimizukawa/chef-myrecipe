#
# Cookbook Name:: myrecipe
# Recipe:: certificates
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
hosts_item = data_bag_item('hosts', 'hosts')
hosts_names = [node_name]

if hosts_item[env_name]
  h = hosts_item[env_name].find do |h|
    ([h['id'], h['id'].split('.').first] + (h['aliases'] || [])).include?(node_name)
  end
  hosts_names = ([h['id']] + (h['aliases'] || [])) if h
end

envnode_matcher = /^(#{env_name}|\*)\/(#{hosts_names.join('|')}|\*)$/



directory node.myrecipe.certificates.path do
  owner "root"
  group "root"
  mode "02700"
end


data_bag("certificates").each do |id|
  certs = Chef::EncryptedDataBagItem.load("certificates", id)

  (certs['keys'] || []).each do |secret|
    envnode = secret['envnode'] || ['*/*']
    next unless envnode.any?{|en| en =~ envnode_matcher}

    %w(key csr crt).each do |type|
      file "#{node.myrecipe.certificates.path}/#{secret['filename']}.#{type}" do
        content secret[type]
        owner "root"
        group "root"
        mode "0600"
      end
    end
  end

end
