#
# Cookbook Name:: myrecipe
# Recipe:: rbenv_prepare
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

if (node.platform == 'redhat' && node.os_version.end_with?('.el6.x86_64'))
  package_files = ['libffi-devel-3.0.5-3.2.el6.x86_64.rpm']
  package_files.each do |package_file|
    package_filepath = "#{Chef::Config[:file_cache_path]}/#{package_file}"
    cookbook_file package_filepath
    rpm_package package_filepath
  end
end
