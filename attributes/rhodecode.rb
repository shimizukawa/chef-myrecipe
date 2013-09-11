# Cookbook Name:: myrecipe
# Attributes:: rhodecode
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

default["myrecipe"]["rhodecode"]["work_dir"] = "/var/www/rhodecode"
default["myrecipe"]["rhodecode"]["bind"] = "127.0.0.1:8000"
default["myrecipe"]["rhodecode"]["user"] = "www"
default["myrecipe"]["rhodecode"]["group"] = "www"
default["myrecipe"]["rhodecode"]["workers"] = 2
default["myrecipe"]["rhodecode"]["log_level"] = "info"
default["myrecipe"]["rhodecode"]["ini_cookbook"] = nil
