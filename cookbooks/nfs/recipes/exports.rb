#
# Cookbook Name:: nfs
# Recipe:: exports
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

if ['util'].include?(node[:dna][:instance_role]) && node[:dna][:name].match(/nfs_master/)

  execute "exportfs" do
    command "exportfs -ar"
    action :nothing
  end

  unless node["nfs"]["exports"].empty?
    template "/etc/exports" do
       source "exports.erb"
       mode 0644
       #notifies :run, "execute[exportfs]"
       notifies :run, resources(:execute => "exportfs")
       variables({
         :exports => node["nfs"]["exports"],
         :hostname => node['dna']['name']
       })
    end
  end
end

