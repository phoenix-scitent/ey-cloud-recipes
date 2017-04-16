#
# Cookbook Name:: nginx_common
# Recipe:: default
#

use_msec = node[:nginx_common][:proxy][:use_msec_time]

if use_msec.nil?
  raise "You must set default[:nginx_common][:proxy][:use_msec_time]"
end

template "/data/nginx/common/servers.conf" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  source "servers.conf.erb"
  variables({
    :client_max_body_size => node[:nginx_common][:servers][:client_max_body_size],
    :use_verb_whitelist => node[:nginx_common][:servers][:http_white_list][:enabled],
    :whitelisted_verbs => (node[:nginx_common][:servers][:http_white_list][:accepted_verbs] || []).join("|")

  })
end

file "/data/nginx/common/keep.servers.conf" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  source "servers.conf.erb"
  variables({
    :client_max_body_size => node[:nginx_common][:servers][:client_max_body_size],
    :use_verb_whitelist => node[:nginx_common][:servers][:http_white_list][:enabled],
    :whitelisted_verbs => (node[:nginx_common][:servers][:http_white_list][:accepted_verbs] || []).join("|")

  })
end

template "/data/nginx/common/proxy.conf" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  source "proxy.conf.erb"
  variables({
    :use_msec => use_msec,
    :proxy_max_temp_file_size => node[:nginx_common][:proxy][:max_temp_file_size] || "0",
    :proxy_connect_timeout => node[:nginx_common][:proxy][:connect_timeout],
    :proxy_send_timeout => node[:nginx_common][:proxy][:send_timeout],
    :proxy_read_timeout => node[:nginx_common][:proxy][:read_timeout]
  })
end

file "/data/nginx/common/keep.proxy.conf" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0644
  source "proxy.conf.erb"
  variables({
    :use_msec => use_msec,
    :proxy_max_temp_file_size => node[:nginx_common][:proxy][:max_temp_file_size] || "0",
    :proxy_connect_timeout => node[:nginx_common][:proxy][:connect_timeout],
    :proxy_send_timeout => node[:nginx_common][:proxy][:send_timeout],
    :proxy_read_timeout => node[:nginx_common][:proxy][:read_timeout]
  })
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :reload ]
end
