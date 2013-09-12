# Cookbook Name:: myrecipe
# Attributes:: sentry
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

default["myrecipe"]["sentry"]["work_dir"] = "/var/www/sentry"
default["myrecipe"]["sentry"]["url_prefix"] = ""
default["myrecipe"]["sentry"]["url_subpath"] = nil
default["myrecipe"]["sentry"]["bind_host"] = "127.0.0.1"
default["myrecipe"]["sentry"]["bind_port"] = "9000"
default["myrecipe"]["sentry"]["udp_host"] = "0.0.0.0"
default["myrecipe"]["sentry"]["udp_port"] = "9001"
default["myrecipe"]["sentry"]["proxy_proto"] = "https"
default["myrecipe"]["sentry"]["user"] = "www"
default["myrecipe"]["sentry"]["group"] = "www"
default["myrecipe"]["sentry"]["workers"] = 2
default["myrecipe"]["sentry"]["log_level"] = "info"
default["myrecipe"]["sentry"]["log_dir"] = "/var/log/sentry"
default["myrecipe"]["sentry"]["ini_cookbook"] = nil
default["myrecipe"]["sentry"]["db_host"] = "localhost"
default["myrecipe"]["sentry"]["db_port"] = 3306
default["myrecipe"]["sentry"]["db_name"] = "sentry"
default["myrecipe"]["sentry"]["db_user"] = "sentry"
default["myrecipe"]["sentry"]["db_passwd"] = "sentry"
default["myrecipe"]["sentry"]["allow_registration"] = false

