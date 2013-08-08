#
# Cookbook Name:: myrecipe
# Recipe:: hosts
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

hosts = Chef::Util::FileEdit.new("/etc/hosts")
item = data_bag_item('hosts', 'hosts')

env_name = node.my_environment #FIXME: chef-solo (11.4.4) did not support "node.chef_environment" yet.

if item[env_name]
  item[env_name].each do |h|
    next unless h['ipaddr']
    hostsfile_entry h['ipaddr'] do
      hostname h['id']
      aliases h['aliases']
    end
  end
else
  Chef::Log.warn("data_bags: hosts/hosts.json did not have '#{env_name}' key.")
end
