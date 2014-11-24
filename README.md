netdisco
========

Cookbook to install and configure netdisco

This isn't the most elegant cookbook, nor is it a complete solution.  It does manage to stand up the netdisco application inside of Kitchen/vagrant.

To use this cookbook with an existing ChefDk workstation/workflow.

You'll need an Ubuntu-12.04 vagrant box.

- kitchen converge
- kitchen login
  - sudo su netdisco
  - cd ~/perl5/bin
  - ./netdisco-deploy 
     - say yes to all
  - ./netdisco-web start
  - ./netdisco-daemon start

- from your Host browser hit http://192.168.17.17



