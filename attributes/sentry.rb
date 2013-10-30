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
default["myrecipe"]["sentry"]["email_address"] = nil

####################
# cache

default["myrecipe"]["sentry"]["cache"] = nil
## for memcached cache
#default["myrecipe"]["sentry"]["cache"]["locations"] = ['127.0.0.1:11211']


####################
# queue & buffer

default["myrecipe"]["sentry"]["use_redis"] = true  #set false if you didn't want to install extra packages relates to redis
default["myrecipe"]["sentry"]["extra_packages"]["redis"] = [
  'redis', 'hiredis', 'nydus'
]

default["myrecipe"]["sentry"]["queue"] = nil
## for redis queue
#default["myrecipe"]["sentry"]["queue"]["broker"] = "redis://localhost:6379/1"

default["myrecipe"]["sentry"]["buffer"] = nil
## for builtin buffer
#default["myrecipe"]["sentry"]["buffer"]["backend"] = "sentry.buffer.base.Buffer"
#default["myrecipe"]["sentry"]["buffer"]["options"] = "{'delay': 5}"
## for redis buffer
#default["myrecipe"]["sentry"]["buffer"]["backend"] = "sentry.buffer.redis.RedisBuffer"
#default["myrecipe"]["sentry"]["buffer"]["options"] = "{'hosts': {0: {'host': 'localhost', 'port': 6379, 'db': 2}}}"

####################
# udp
default["myrecipe"]["sentry"]["use_udp"] = true  #set false if you didn't want to install extra packages relates to udp
default["myrecipe"]["sentry"]["udp_host"] = "0.0.0.0"
default["myrecipe"]["sentry"]["udp_port"] = "9001"
default["myrecipe"]["sentry"]["extra_packages"]["udp"] = [
  'eventlet'
]

