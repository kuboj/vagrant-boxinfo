# Vagrant::Boxinfo

Vagrant plugin for displaying box info in vagrant self-hosted environments.

## Installation

Add this line to your application's Gemfile:

```
$ vagrant plugin install vagrant-boxinfo
```

## Usage

```
$ vagrant boxinfo <url or box_name>
```

## Example

Imagine you host vagrant boxes which are used for LAMP development. Different box versions can have different versions of MySQL, PHP, etc.

Suppose you have `metadata.json` with following content on your server:

```json
{
  "name": "lampbox",
  "description": "Vagrant box for LAMP development based on Ubuntu 14.04",
  "versions": [
    {
      "version": "1.0.1",
      "php_version": "5.5.22",
      "mysql_version": "5.6.23",
      "apache_version": "2.4.12",
      "providers": [
        {
          "name": "virtualbox",
          "url": "http://myvagranthost.com/lambox-1.0.1.box",
        }
      ]
    },
    {
      "version": "1.0.0",
      "php_version": "5.5.21",
      "mysql_version": "5.6.22",
      "apache_version": "2.4.12",
      "providers": [
        {
          "name": "virtualbox",
          "url": "http://myvagranthost.com/lambox-1.0.0.box",
        }
      ]
    }
  ]
}
```


```
$ vagrant box list
lampbox    (virtualbox, 1.0.0)

$ vagrant boxinfo lambox

Reading url http://myvagranthost.com/metadata.json...
Box name: lampbox
Description: Vagrant box for LAMP development based on Ubuntu 14.04

1.0.1
    php_version: 5.5.22
    mysql_version: 5.6.23
    apache_version: 2.4.12
    downloaded: false
1.0.0
    php_version: 5.5.21
    mysql_version: 5.6.22
    apache_version: 2.4.12
    downloaded: true
```

If you currently don't have downloaded any version of *lampbox*, you have to pass full url of `metadata.json` to *boxinfo* command.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vagrant-boxinfo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
