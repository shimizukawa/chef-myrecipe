#
# Cookbook Name:: myrecipe
# Recipe:: mysql_grants
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

node.myrecipe.mysql_grants.each do |database_name, grant|
  grant.grants_ipaddresses.each do |ipaddr|
    mysqlcmd = "mysql -u root --password=#{node.mysql.server_root_password} -e "
    bash "mysql grant #{database_name} to #{grant.database_account}@#{ipaddr}" do
      code <<-EOH
        #{mysqlcmd} \
        "GRANT ALL PRIVILEGES ON #{database_name}.* \
        TO '#{grant.database_account}'@'#{ipaddr}' \
        IDENTIFIED BY '#{grant.database_password}';"
      EOH
      not_if "#{mysqlcmd} \"show grants for '#{grant.database_account}'@'#{ipaddr}';\" | grep \"ON \`#{database_name}\`.*\""
    end
  end
end
