#
# Cookbook Name:: myrecipe
# Recipe:: rhodecode
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

directory node.myrecipe.rhodecode.work_dir do
  owner node.myrecipe.rhodecode.user
  group node.myrecipe.rhodecode.group
  mode "02755"
end

execute "virtualenv #{node.myrecipe.rhodecode.work_dir}" do
  user node.myrecipe.rhodecode.user
  group node.myrecipe.rhodecode.group
  not_if {File.exists? node.myrecipe.rhodecode.work_dir}
end

execute "#{node.myrecipe.rhodecode.work_dir}/bin/pip install python-ldap gunicorn https://rhodecode.com/dl/latest" do
  user node.myrecipe.rhodecode.user
  group node.myrecipe.rhodecode.group
  not_if {File.exists? "#{node.myrecipe.rhodecode.work_dir}/bin/rhodecode-api"}
end

template "#{node.myrecipe.rhodecode.work_dir}/production.ini" do
  source      "rhodecode-production.ini.erb"
  owner       node.myrecipe.rhodecode.user
  group       node.myrecipe.rhodecode.group
  mode        '0644'
  if node.myrecipe.rhodecode.ini_cookbook
    cookbook  node.myrecipe.rhodecode.ini_cookbook
  end
end

execute "#{node.myrecipe.rhodecode.work_dir}/bin/paster upgrade-db production.ini --force-yes" do
  cwd node.myrecipe.rhodecode.work_dir
  user node.myrecipe.rhodecode.user
  group node.myrecipe.rhodecode.group
  subscribes :run, resources(:template => "#{node.myrecipe.rhodecode.work_dir}/production.ini")
end

template "/etc/init/rhodecode.conf" do
  source      "upstart-rhodecode.conf.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :work_dir  => node.myrecipe.rhodecode.work_dir,
    :bind      => node.myrecipe.rhodecode.bind,
    :user      => node.myrecipe.rhodecode.user,
    :group     => node.myrecipe.rhodecode.group,
    :workers   => node.myrecipe.rhodecode.workers,
    :log_level => node.myrecipe.rhodecode.log_level,
  )
end

service 'rhodecode' do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :start => true, :restart => true, :reload => true, :status => true
  action :start
  subscribes :restart, resources(:template => "/etc/init/rhodecode.conf")
end

