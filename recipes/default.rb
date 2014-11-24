#
# Cookbook Name:: netdisco
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.
include_recipe "postgresql::server"
include_recipe "database::postgresql"


node["netdisco"]["dependancies"].each do | p |
  package p do
  	action :install
  end
end

service "apache2" do
	action [ :enable, :start ]
end

httpd_module 'headers' do
  action :create
end

httpd_module 'proxy' do
  action :create
end

httpd_module 'proxy_http' do
  action :create
end

template "/etc/apache2/httpd.conf" do
	source "httpd.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, "service[apache2]"
end

group "netdisco" do
	gid 2000
	action :create
end

user "netdisco" do
	comment "netdisco User"
	uid 2001
	gid 2000
	password "netdisco"
	home node["netdisco"]["home"]
	shell "/bin/bash"
	action :create
end

directory "#{node["netdisco"]["home"]}" do
	owner "netdisco"
	group "netdisco"
	mode "0755"
	action :create
end

postgresql_connection_info = {:host => "localhost",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

# Create a postgresql user but grant no privileges
# to verify on the box: >psql >\du will list all users
postgresql_database_user 'netdisco' do
  connection postgresql_connection_info
  password   node["netdisco"]["database"]["password"]
  action     :create
  notifies :restart, "service[postgresql]", :delayed
end

postgresql_database 'netdisco' do
  connection postgresql_connection_info
  action :create 
end


postgresql_database_user 'netdisco' do
  connection    postgresql_connection_info
  database_name 'netdisco'
  privileges    [:all]
  action        :grant
  notifies :restart, "service[postgresql]", :delayed
end

directory "#{node["netdisco"]["home"]}/perl5" do
	owner "netdisco"
	group "netdisco"
	mode "0755"
	action :create
end

execute "curl netdisco" do
	command "curl -L http://cpanmin.us/ | perl - --notest --local-lib #{node["netdisco"]["home"]}/perl5 App::Netdisco"
# This may blow up in our face cause it's gonna run curl as root
# I'm having an issue because "Can't write to cpanm home '/home/vagrant/.cpanm': You should fix it with chown/chmod first."
#    user "netdisco"
#    group "netdisco"
    cwd "#{node["netdisco"]["home"]}"
	action :run
	#TODO only_if
end

directory "#{node["netdisco"]["home"]}/bin" do
	owner "netdisco"
	group "netdisco"
	mode "0755"
	action :create
end

directory "#{node["netdisco"]["home"]}/environments" do
	owner "netdisco"
	group "netdisco"
	mode "0755"
	action :create
end

template "#{node["netdisco"]["home"]}/environments/deployment.yml" do
	source "deployment.yml.erb"
	owner "netdisco"
	group "netdisco"
	mode "0600"
end

execute "fixup #{node["netdisco"]["home"]} owner" do
  command "chown -Rf netdisco:netdisco #{node["netdisco"]["home"]}"
  only_if { Etc.getpwuid(File.stat("#{node["netdisco"]["home"]}/perl5/bin/netdisco-daemon").uid).name != "netdisco" }
end







