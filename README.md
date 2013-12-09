# Chef practice

## Using Chef Solo

```
$ mkdir chef
$ cd chef
$ bundle init
$ vim Gemfile
  + gem 'chef'
  + gem 'knife-solo'
  + gem 'knife-solo_data_bag'
  + gem 'berkshelf'

$ mv encrypted_data_bag_secret chef-repo/.chef/
```
