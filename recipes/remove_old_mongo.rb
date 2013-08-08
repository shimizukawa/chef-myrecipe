#
# Cookbook Name:: myrecipe
# Recipe:: remove_old_mongo
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

bash "remove_old_mongodb" do
  user "root"
  code <<-EOH
    mongo --version && mongo --version | awk '{ exit $4 < "2.4" }'
    if [ $? -eq 1 ]
    then
      service mongodb stop
      apt-get -q -y remove mongodb-server mongodb-clients
    fi
  EOH
end
