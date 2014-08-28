#
# Cookbook Name:: clone_scripts
# Recipe:: deploy
#

if ['app_master', 'solo'].include?(node[:instance_role])
  node['applications'].each do |app_name,data|
    if node['environment']['name'] == node['clone_scripts']['clone_environment_name']  
      bash 'install engineyard gem' do
        code "gem install engineyard --no-ri --no-rdoc"
      end

      cron "deploy-#{app_name}" do
        action  :delete
      end

      #cron "deploy-#{app_name}" do
      #  action  :create
      #  minute  "0"
      #  hour    node['clone_scripts']['deploy']['hour']
      #  day     "*"
      #  month   "*"
      #  weekday node['clone_scripts']['deploy']['weekday']
      #  command "cd /data/#{app_name}/shared/cached-copy && ey init && ey deploy -e #{node['clone_scripts']['clone_environment_name']} -r #{node['clone_scripts']['deploy']['branch']} >> /home/#{node['owner_name']}/clone_deploy.log"
      #  user    node['owner_name']
      #end

      remote_file "/home/#{node['owner_name']}/.ssh/id_rsa.pub" do
        source "id_rsa.pub"
        owner node['owner_name']
        group node['owner_name']
        mode 0644
        backup false
        action :create
      end

      remote_file "/home/#{node['owner_name']}/.ssh/id_rsa" do
        source "id_rsa"
        owner node['owner_name']
        group node['owner_name']
        mode 0600
        backup false
        action :create
      end            
      
    end
  end
end
