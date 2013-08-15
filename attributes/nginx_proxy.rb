# Cookbook Name:: myrecipe
# Attributes:: nginx_jenkins
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

default["myrecipe"]["nginx_proxy"]["sites"] = [
#  {
#    "name": "server-name",
#    "host_name": "host-name.localhost.localdomain",
#    "host_aliases": ["backup"],
#    "listen_ports": [80, 8080],
#    "upstream_servers": ["ap1:5000", "ap2:5000"],
#    "www_redirect": false,
#    "client_max_body_size": "1024m",
#    "ssl": true,
#    "ssl_path": "/etc/ssl/private",
#    "ssl_name": "server-name",
#    "basicauth": {
#      "realm": "realm name",
#      "htpasswd": "htpasswd-file"
#    },
#    "locations": {
#      "= /_health": [
#        "return 200 'good.';",
#        "#for health check."
#      ]
#    }
#  }
]
