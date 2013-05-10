#
# Cookbook Name:: nfs
# Recipe:: server 
#
# Copyright 2011, Eric G. Wolfe
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

# Install package, dependent on platform
node['nfs']['packages'].each do |nfspkg|
  package nfspkg
end

# Start NFS client components
service "portmap" do
  service_name node['nfs']['service']['portmap']
  action [ :start, :enable ]
end

#service "nfslock" do
  #service_name node['nfs']['service']['lock']
  #action [ :start, :enable ]
#end

# Configure NFS client components
node['nfs']['config']['client_templates'].each do |client_template|
  template client_template do
    source "#{client_template.split("/").last}.erb"
    mode 0644
    notifies :restart, resources(:service => [ 'portmap' ] )
    variables({
      :statd => node["nfs"]["port"]["statd"],
      :statd_out => node["nfs"]["port"]["statd_out"],
      :mountd_port => node["nfs"]["port"]["mountd"],
      :lockd_port => node["nfs"]["port"]["lockd"],
      :hostname => node['name']
    })
  end
end

nfs_master_hostname = nil
if node[:utility_instances]
  nfs_master = node[:utility_instances].find {|u| u[:name] == 'nfs_master' }
  if nfs_master && nfs_master[:hostname]
    nfs_master_hostname = nfs_master[:hostname]
  end
end

if ["app_master","app","util","solo"].include?(node['instance_role'])
  unless node.name == nfs_master_hostname

   directory "/shared" do
     owner node[:owner_name]
     group node[:owner_name]
     mode 0755
     recursive true
   end

    execute "echo '#{nfs_master_hostname}:/data /shared nfs defaults 0 0' >> /etc/fstab" do
      not_if "grep nfs /etc/fstab"
    end

    ruby_block "wait-for-nfs_master" do
      block do
        until File.exists?("/shared/#{node["application"]}") do
          Chef::Log.info("NFS master not ready yet")
          sleep 5
          system("mount /shared")
          system("rm -rf /data/#{node["application"]}/shared/system && ln -sf /shared/#{node["application"]}/shared/system /data/#{node["application"]}/shared/system")
        end 
      end 
    end
  end
end
