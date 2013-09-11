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

env_name = node.my_environment #FIXME: chef-solo (11.4.4) did not support "node.chef_environment" yet.
item = data_bag_item('hosts', env_name)

if item
  item.each do |id, h|
    next unless h['ipaddr']
    hostsfile_entry h['ipaddr'] do
      hostname id
      aliases h['aliases']
    end
  end
else
  Chef::Log.warn("data_bags: hosts/#{env_name} does not exist.")
end
