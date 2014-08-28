#
# Cookbook Name:: clone_scripts
# Recipe:: rsync
#

if ['app_master', 'solo'].include?(node[:instance_role])
  node['applications'].each do |app_name,data|
    if node['environment']['name'] == node['clone_scripts']['clone_environment_name']

      cron "rsync-#{app_name}" do
        action  :delete
      end

      cron "rsync-#{app_name}" do
        action  :create
        minute  "0"
        hour    node['clone_scripts']['rsync']['hour']
        day     "*"
        month   "*"
        weekday node['clone_scripts']['rsync']['weekday']
        command "rsync -av -e 'ssh -oStrictHostKeyChecking=no' #{node['owner_name']}@#{node['clone_scripts']['rsync']['source_hostname']}:/data/#{app_name}/shared/system/ /data/#{app_name}/shared/system/ >> /home/#{node['owner_name']}/clone_rsync.log"
        user    node['owner_name']
      end      
      
    end
  end
end
