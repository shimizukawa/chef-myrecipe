#
# Cookbook Name:: myrecipe
# Attributes:: mha
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

# node

default["myrecipe"]["mha"]["node"]["packages"] = [
  "perl-DBD-MySQL",
  {
    "name" => "mha4mysql-node-0.54-0.el6.noarch.rpm",
    "url" => "https://mysql-master-ha.googlecode.com/files/mha4mysql-node-0.54-0.el6.noarch.rpm",
  },
]
default["myrecipe"]["mha"]["node"]["work_dir"] = nil
default["myrecipe"]["mha"]["node"]["work_owner"] = nil
default["myrecipe"]["mha"]["node"]["work_group"] = nil

# manager

default["myrecipe"]["mha"]["manager"]["packages"] = []

case node.platform
when "redhat"
  if node.platform_version.start_with? "6."
    default["myrecipe"]["mha"]["manager"]["packages"] += [
      {
        "name" => "perl-Log-Dispatch-2.26-1.el6.rf.noarch.rpm",
        "cookbook" => "myrecipe",
      },
      {
        "name" => "perl-Config-Tiny-2.12-7.1.el6.noarch.rpm",
        "cookbook" => "myrecipe",
      },
    ]
  end

else
  default["myrecipe"]["mha"]["manager"]["packages"] += [
    "perl-Log-Dispatch",
    "perl-Config-Tiny",
  ]

end

default["myrecipe"]["mha"]["manager"]["packages"] += [
  "perl-DBD-MySQL",
  "perl-Parallel-ForkManager",
  {
    "name" => "mha4mysql-node-0.54-0.el6.noarch.rpm",
    "url" => "https://mysql-master-ha.googlecode.com/files/mha4mysql-node-0.54-0.el6.noarch.rpm",
  },
  {
    "name" => "mha4mysql-manager-0.55-0.el6.noarch.rpm",
    "url" => "https://mysql-master-ha.googlecode.com/files/mha4mysql-manager-0.55-0.el6.noarch.rpm",
  }
]

default["myrecipe"]["mha"]["manager"]["work_dir"] = nil
default["myrecipe"]["mha"]["manager"]["work_owner"] = nil
default["myrecipe"]["mha"]["manager"]["work_group"] = nil
default["myrecipe"]["mha"]["manager"]["conf_path"] = "/etc/mha.cnf"
default["myrecipe"]["mha"]["manager"]["log_path"] = "/var/log/masterha.log"
default["myrecipe"]["mha"]["manager"]["log_owner"] = nil
default["myrecipe"]["mha"]["manager"]["log_group"] = nil

