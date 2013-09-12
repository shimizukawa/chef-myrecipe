myrecipe Cookbook
===================

My recipe collection in one cookbook. NEED TO SPLIT BY RECIPE.

Requirements
------------

* depends "hostsfile" cookbook.
* depends "logrotate" cookbook.
* depends "rbenv" cookbook.


Attributes
----------

* `node["my_environment"]` - environment name for setup data select that will be used by myrecipe::hosts and myrecipe::users.

* `node["myrecipe"]["networking"]["gatewaydev"]` - set GATEWAYDEV to /etc/sysconfig/network. default is nil.

* `node["myrecipe"]["install_packages"]` - packages for install. default is [].

  for example:

    "install_packages": [
        "some-rpm-package.rpm",  //will convert to {"name": "some-rpm-package.rpm"}
        {
            "name": "some-rpm-package.rpm",  //required
            "cookbook": "target-cookbook",   //optional: use localfile if provided
            "url": "http://someurl.example.com/file/path.rpm"  //optional: download package if provided
        },
        {"name": "librarian-chef",            "provider": "gem"},
        {"name": "chef",                      "version": ">=11.6.0", "provider": "gem"},
        {"name": "knife-solo-0.3.0.pre4.gem", "cookbook": "myrecipe"},
        { ... }
    ]

* `node["myrecipe"]["install_local_gems"]["rbenv"]` - default is "global".
* `node["myrecipe"]["install_local_gems"]["gems"]` - gem files to install from cookbook_file. default is [].
* `node["myrecipe"]["install_local_gems"]["cookbook"]` - cookbook for files default is nil (current cookbook).


* `node["myrecipe"]["mysql_grants"]` - mysql grants users. default is:

    {
      "mydb"=> {
        "grants_ipaddresses" => [],
        "database_account" => "",
        "database_password" => ""
      }
    }

* `node["myrecipe"]["mysql_databases"]` - mysql database names to create. default is [].
* `node["myrecipe"]["mysql_extraconf"]` - mysql extra configuration settings. default is {}.

    {
      "section": {
        "key1": 1,
        "key2": "value2"
      }
    }

* `node["myrecipe"]["certificates"]["path"]` - certificates path. path permission will become 02700.

* `node["myrecipe"]["mha"]["node"]["packages"]` - packages are defined for mha node. see attributes.
* `node["myrecipe"]["mha"]["master"]["packages"]` - packages are defined for mha node. see attributes.

* `node["myrecipe"]["logrotate"] - setup logrotate.d file information array

    [
      {
         "name": "mysql-slow",
         "path": "/var/log/mysql/slow.log",
         "options": ["missingok", "notifempty"],
         "frequency": "daily",
         "create": "0640 mysql mysql",
         "rotate": 90
      }
    ]

* `node["myrecipe"]["nginx_proxy"]["sites"]` - nginx application proxy site array

    [
      {
        "name": "server-name",            //required
        "host_name": "example.jp",        //default is node['fqdn']
        "host_aliases": ["backup"],       //default is []
        "listen_ports": [80, 8080],       //default is [8080]
        "upstream_servers": [],           //default is ['localhost:5000']
        "www_redirect": false,            //default is false
        "client_max_body_size": "1024m",  //default is nil
        "ssl": true,                      //default is false
        //if ssl is true, /etc/ssl/server-name.(key|crt) will be used.
        "ssl_path": "/etc/ssl/private",   //default is nil (using myrecipe.certificates.path)
        "ssl_name": "server-name",        //for key, crt file. default is nil (using name value)
        "basicauth": {                    //default is nil
          "realm": "realm-name",
          "htpasswd": "htpasswd-file-path"
        },
        "locations": {                    //default is {}
          "= /_health": [
            "return 200 'good.';",
            "#for health check."
          ]
        },
        "nested_proxy": false             //default is false. It is effective for ELB.
      }
   ]

* `node["myrecipe"]["rhodecode"]["work_dir"]` - default is "/var/www/rhodecode"
* `node["myrecipe"]["rhodecode"]["bind"]` - default is "127.0.0.1:8000"
* `node["myrecipe"]["rhodecode"]["user"]` - default is "www"
* `node["myrecipe"]["rhodecode"]["group"]` - default is "www"
* `node["myrecipe"]["rhodecode"]["workers"]` -  default is 2
* `node["myrecipe"]["rhodecode"]["log_level"]` - default is "info"
* `node["myrecipe"]["rhodecode"]["ini_cookbook"]` - default is nil

Data bags
----------

file `data_bags/hosts/<my_environment>.json` used by `myrecipe::hosts`.

example1, `data_bags/hosts/personal.json`:
```json
{
  "id": "personal",
  "host-workstation": {
    "ipaddr": "192.168.1.1",
    "aliases": [
      "host-ap1",
      "host-ap2",
      ...
    ]
  }
}
```

example2, `data_bags/hosts/production.json`:
```json
{
  "id": "production",
  "host-workstation": {
    "ipaddr": "10.0.0.1"
  },
  "host-ap1": {
    "ipaddr": "10.0.0.2",
  }
}
```


file `data_bags/certificates/certificates.json` used by `myrecipe::certificates`:

```json
{
  "id": "certificates",
  "keys": [
    {
      "filename": "jenkins",
      "key": "-----BEGIN RSA PRIVATE KEY-----\nMIICXQIBAKBgQDRmqAbqW...",
      "csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIIBsCCARsAQAwcEL...",
      "crt": "-----BEGIN CERTIFICATE-----\nMIICWzCCAcQCCDjBUDiSKQgAN...",
      "envnode": [
        "bpvm/*"
      ]
    },
    {
      "filename": "rhodecode",
      "key": "-----BEGIN RSA PRIVATE KEY-----\nMIICXQBAABgQM1sIOvCqA...",
      "csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIBxjCASCAQwgYxCA...",
      "crt": "-----BEGIN CERTIFICATE-----\nMIICgzCCAeCCQrHh3AMoijNBk...",
      "envnode": [
        "bpvm/*"
      ]
    }
  ]
}
```

Recipes
-------

* `myrecipe::install_packages` - install packages
* `myrecipe::rbenv_prepare` - preparation for rbenv depends libraries
* `myrecipe::install_local_gems` - install gems from cookbook_file
* `myrecipe::certificates` - setup /etc/ssl files from data_bags.
* `myrecipe::users` - setup .ssh/config, authorized_keys, secret keys for users from data_bags. You need set node.users = ['user', 'names'] to work this feature.
* `myrecipe::hostname` - setup hostname from node[:set_fqdn] that need to prepare.
* `myrecipe::hosts` - setup /etc/hosts from data bag under hosts
* `myrecipe::networking` - network setting
* `myrecipe::gemrc` - setup gemrc file at /etc/gemrc for disabling rdoc compiling.
* `myrecipe::logrotate` - setup logrotate.d file.
* `myrecipe::mysql_grants` - grant users for mysql
* `myrecipe::mysql_databases` - create mysql databases
* `myrecipe::mysql_extraconf` - create extra configuration file that work with mysql recipe.
* `myrecipe::mysql` - create some configuration file.
* `myrecipe::nginx_proxy` - setup nginx proxy site setting.
* `myrecipe::rhodecode` - setup rhadcode application.
* `myrecipe::remote_old_mongo` - uninstall old (before 2.4) mongodb packages.
* `myrecipe::sentry` - install sentry.



Usage
-----
#### myrecipe::default

Just include `myrecipe::<any sub recipe>` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[myrecipe]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Takayuki Shimizukawa
License: Apache 2.0
