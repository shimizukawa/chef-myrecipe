#
# Cookbook Name:: myrecipe
# Recipe:: sentry
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

directory node.myrecipe.sentry.work_dir do
  owner node.myrecipe.sentry.user
  group node.myrecipe.sentry.group
  mode "02755"
end

directory node.myrecipe.sentry.log_dir do
  owner node.myrecipe.sentry.user
  group node.myrecipe.sentry.group
  mode "02755"
end

execute "virtualenv #{node.myrecipe.sentry.work_dir}" do
  user node.myrecipe.sentry.user
  group node.myrecipe.sentry.group
  not_if {File.exists? "#{node.myrecipe.sentry.work_dir}/bin/pip"}
end

execute "#{node.myrecipe.sentry.work_dir}/bin/pip install sentry[mysql]" do
  user node.myrecipe.sentry.user
  group node.myrecipe.sentry.group
  not_if {File.exists? "#{node.myrecipe.sentry.work_dir}/bin/sentry"}
end

if node.myrecipe.sentry.use_redis
  execute "#{node.myrecipe.sentry.work_dir}/bin/pip install #{node.myrecipe.sentry.extra_packages.redis.join ' '}" do
    user node.myrecipe.sentry.user
    group node.myrecipe.sentry.group
  end
end

if node.myrecipe.sentry.use_udp
  execute "#{node.myrecipe.sentry.work_dir}/bin/pip install #{node.myrecipe.sentry.extra_packages.udp.join ' '}" do
    user node.myrecipe.sentry.user
    group node.myrecipe.sentry.group
  end
end

template "#{node.myrecipe.sentry.work_dir}/sentry.conf.py" do
  source      "sentry.conf.py.erb"
  owner       node.myrecipe.sentry.user
  group       node.myrecipe.sentry.group
  mode        '0644'
  if node.myrecipe.sentry.ini_cookbook
    cookbook  node.myrecipe.sentry.ini_cookbook
  end
  variables(
    :work_dir  => node.myrecipe.sentry.work_dir,
    :url_prefix => node.myrecipe.sentry.url_prefix,
    :url_subpath => node.myrecipe.sentry.url_subpath,
    :bind_host => node.myrecipe.sentry.bind_host,
    :bind_port => node.myrecipe.sentry.bind_port,
    :proxy_proto => node.myrecipe.sentry.proxy_proto,
    :udp_host  => node.myrecipe.sentry.udp_host,
    :udp_port  => node.myrecipe.sentry.udp_port,
    :user      => node.myrecipe.sentry.user,
    :group     => node.myrecipe.sentry.group,
    :workers   => node.myrecipe.sentry.workers,
    :log_level => node.myrecipe.sentry.log_level,
    :log_dir   => node.myrecipe.sentry.log_dir,
    :db_host   => node.myrecipe.sentry.db_host,
    :db_port   => node.myrecipe.sentry.db_port,
    :db_name   => node.myrecipe.sentry.db_name,
    :db_user   => node.myrecipe.sentry.db_user,
    :db_passwd => node.myrecipe.sentry.db_passwd,
    :allow_registration => node.myrecipe.sentry.allow_registration,
    :email_address => node.myrecipe.sentry.email_address,
    :queue     => node.myrecipe.sentry.queue,
    :buffer    => node.myrecipe.sentry.buffer,
    :use_udp   => node.myrecipe.sentry.use_udp,
    :use_redis => node.myrecipe.sentry.use_redis,
  )
end

execute "#{node.myrecipe.sentry.work_dir}/bin/sentry --config=#{node.myrecipe.sentry.work_dir}/sentry.conf.py upgrade --noinput" do
  user node.myrecipe.sentry.user
  group node.myrecipe.sentry.group
  subscribes :run, resources(:template => "#{node.myrecipe.sentry.work_dir}/sentry.conf.py")
end

template "/etc/init/sentry.conf" do
  source      "upstart-sentry.conf.erb"
  owner       'root'
  group       'root'
  mode        '0644'
end

service 'sentry' do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :start => true, :restart => true, :reload => true, :status => true
  action :start
  subscribes :restart, resources(:template => "/etc/init/sentry.conf")
end


template "/etc/init/sentry-http.conf" do
  source      "upstart-sentry-http.conf.erb"
  owner       'root'
  group       'root'
  mode        '0644'
  variables(
    :work_dir  => node.myrecipe.sentry.work_dir,
    :user      => node.myrecipe.sentry.user,
    :group     => node.myrecipe.sentry.group,
    :log_dir   => node.myrecipe.sentry.log_dir,
  )
end

service 'sentry' do
  provider Chef::Provider::Service::Upstart
  enabled true
  running true
  supports :start => true, :restart => true, :reload => true, :status => true
  action :start
  subscribes :restart, resources(:template => "/etc/init/sentry-http.conf")
end


if node.myrecipe.sentry.use_udp
  template "/etc/init/sentry-udp.conf" do
    source      "upstart-sentry-udp.conf.erb"
    owner       'root'
    group       'root'
    mode        '0644'
    variables(
      :work_dir  => node.myrecipe.sentry.work_dir,
      :user      => node.myrecipe.sentry.user,
      :group     => node.myrecipe.sentry.group,
      :log_dir   => node.myrecipe.sentry.log_dir,
    )
  end

  service 'sentry-udp' do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :start => true, :restart => true, :reload => true, :status => true
    action :start
    subscribes :restart, resources(:template => "/etc/init/sentry-udp.conf")
  end

end

if node.myrecipe.sentry.queue
  template "/etc/init/sentry-celery.conf" do
    source      "upstart-sentry-celery.conf.erb"
    owner       'root'
    group       'root'
    mode        '0644'
    variables(
      :work_dir  => node.myrecipe.sentry.work_dir,
      :user      => node.myrecipe.sentry.user,
      :group     => node.myrecipe.sentry.group,
      :log_dir   => node.myrecipe.sentry.log_dir,
    )
  end

  service 'sentry-celery' do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :start => true, :restart => true, :reload => true, :status => true
    action :start
    subscribes :restart, resources(:template => "/etc/init/sentry-celery.conf")
  end

end

