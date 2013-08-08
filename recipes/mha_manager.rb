#
# Cookbook Name:: myrecipe
# Recipe:: mha_manager
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

install_packages node.myrecipe.mha.manager.packages

directory node.myrecipe.mha.manager.work_dir do
  owner node.myrecipe.mha.manager.work_owner
  group node.myrecipe.mha.manager.work_group
  mode 0755
end

directory node.myrecipe.mha.manager.log_path.rpartition('/').first do
  owner node.myrecipe.mha.manager.log_owner
  group node.myrecipe.mha.manager.log_group
  mode 0755
end

template "/etc/init/mha.conf" do
  source "upstart-mha.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables ({
    "work_dir"  => node.myrecipe.mha.manager.work_dir,
    "conf_path" => node.myrecipe.mha.manager.conf_path,
    "log_path"  => node.myrecipe.mha.manager.log_path,
    "run_user"  => node.myrecipe.mha.manager.run_user,
  })
end

service 'mha' do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :start => true, :restart => true, :reload => true, :status => true
  action :start
  subscribes :restart, resources(:template => "/etc/init/mha.conf")
end

