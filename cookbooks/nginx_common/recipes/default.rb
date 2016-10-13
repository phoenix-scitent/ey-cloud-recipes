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
  source "# This file is managed by the nginx_common cookbook.
# Direct changes will be overwitten on the next chef run

# Max size for file uploads
client_max_body_size <%= @client_max_body_size %>;

#error_page 403 406 /system/noaccess/ahahah.html;
location /addyn {
  return 406;
}

<%- if @use_verb_whitelist %>
# Allow only whitelisted HTTP verbs
if ($request_method !~ ^(<%= @whitelisted_verbs %>)$ ) {
  return 403;
}
<%- end %>

# HTTP Error handling.
#
# 404 - Resource Not found.
error_page 404 /404.html;

# 500 - Internal Error
# 502 - Bad Gateway
# 504 - Gateway Timeout
error_page 500 502 504 /500.html;

# 503 - Service Unavailable
error_page 503 @503;
recursive_error_pages on;
location @503 {

  error_page 405 =503 /system/maintenance.html;

  # Serve static assets if found.
  if (-f $request_filename) {
    break;
  }

  rewrite ^(.*)$ /system/maintenance.html break;
}
"
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
  source "# This file is managed by the nginx_common cookbook.
# Direct changes will be overwitten on the next chef run

# Max size for file uploads
client_max_body_size <%= @client_max_body_size %>;

#error_page 403 406 /system/noaccess/ahahah.html;
location /addyn {
  return 406;
}

<%- if @use_verb_whitelist %>
# Allow only whitelisted HTTP verbs
if ($request_method !~ ^(<%= @whitelisted_verbs %>)$ ) {
  return 403;
}
<%- end %>

# HTTP Error handling.
#
# 404 - Resource Not found.
error_page 404 /404.html;

# 500 - Internal Error
# 502 - Bad Gateway
# 504 - Gateway Timeout
error_page 500 502 504 /500.html;

# 503 - Service Unavailable
error_page 503 @503;
recursive_error_pages on;
location @503 {

  error_page 405 =503 /system/maintenance.html;

  # Serve static assets if found.
  if (-f $request_filename) {
    break;
  }

  rewrite ^(.*)$ /system/maintenance.html break;
}
"
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
  source "index index.html index.htm;

# needed to forward user's IP address to rails
proxy_set_header  X-Real-IP         $remote_addr;
proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
proxy_set_header  Host              $http_host;
<% if @use_msec %>
proxy_set_header  X-Queue-Start     't=${msec}000';
<% else %>
proxy_set_header  X-Queue-Start     't=$start_time';
<% end %>

proxy_redirect off;
proxy_max_temp_file_size <%= @proxy_max_temp_file_size %>;

<% if @proxy_connect_timeout %>
  # Set the proxy connection timeout
  proxy_connect_timeout <%= @proxy_connect_timeout %>;
<% end %>

<% if @proxy_send_timeout %>
  # Set the proxy send timeout
  proxy_send_timeout <%= @proxy_send_timeout %>;
<% end %>

<% if @proxy_read_timeout %>
  # Set the proxy read timeout
  proxy_read_timeout <%= @proxy_read_timeout %>;
<% end %>"
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
  source "index index.html index.htm;

# needed to forward user's IP address to rails
proxy_set_header  X-Real-IP         $remote_addr;
proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
proxy_set_header  Host              $http_host;
<% if @use_msec %>
proxy_set_header  X-Queue-Start     't=${msec}000';
<% else %>
proxy_set_header  X-Queue-Start     't=$start_time';
<% end %>

proxy_redirect off;
proxy_max_temp_file_size <%= @proxy_max_temp_file_size %>;

<% if @proxy_connect_timeout %>
  # Set the proxy connection timeout
  proxy_connect_timeout <%= @proxy_connect_timeout %>;
<% end %>

<% if @proxy_send_timeout %>
  # Set the proxy send timeout
  proxy_send_timeout <%= @proxy_send_timeout %>;
<% end %>

<% if @proxy_read_timeout %>
  # Set the proxy read timeout
  proxy_read_timeout <%= @proxy_read_timeout %>;
<% end %>"
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
