#
# Cookbook Name:: myrecipe
# Definition:: mha_package
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

define :install_packages, :action => :install do
  packages = params[:name]

  case params[:action]
  when :install
    packages.each do |pkg|
      if pkg.kind_of? String
        pkg = {"name" => pkg}
      end
    
      package_src = nil
    
      if pkg['cookbook']
        package_src = "#{Chef::Config[:file_cache_path]}/#{pkg['name']}"
        cookbook_file package_src do
          cookbook pkg['cookbook']
        end
    
      elsif pkg['url']
        package_src = "#{Chef::Config[:file_cache_path]}/#{pkg['name']}"
        remote_file package_src do
          source pkg['url']
        end
    
      end
    
      package pkg['name'] do
        source package_src
      end
    
    end

  end
end

