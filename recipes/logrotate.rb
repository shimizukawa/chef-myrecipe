#
# Cookbook Name:: myrecipe
# Recipe:: logrotate
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

include_recipe "logrotate"

node.myrecipe.logrotate.each do |ll|
  logrotate_app ll['name'] do
    path ll['path']
    enable ll['enable'] || true
    frequency ll['frequency'] || 'weekly'
    rotate ll['rotate']
    create ll['create']
    prerotate ll['prerotate']
    postrotate ll['postrotate']
    sharedscripts ll['sharedscripts']
    options ll['options']
  end
end
