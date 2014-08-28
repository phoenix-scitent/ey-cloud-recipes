#
# Cookbook Name:: clone_scripts
# Recipe:: database
#

if ['db_slave'].include?(node[:instance_role])

  execute "install-fog-to system" do
    command "gem install nokogiri -v 1.5.11 && gem install  fog -v 1.19.0"
    not_if "gem list | grep fog"
  end

  node['applications'].each do |app_name,data|
    if node['environment']['name'] == node['clone_scripts']['source_environment_name']
      # This script will download the latest eybackup then uses s3_backup.rb to upload it to the
      # S3 region and bucket specified in the attribute
      template "/home/#{node['owner_name']}/database_backup.sh"do
        source "database_backup.sh.erb"
        owner node['owner_name']
        group node['owner_name']
        mode 0755
        variables({
          :app_name => app_name,
          :user => node['owner_name'],
          :db_type => node['clone_scripts']['database']['db_type'],
          :backup_ext => node['clone_scripts']['database']['backup_ext']
        })
      end

      # This script is called by database_backup.sh.  It will upload the eybackup to S3.
      template "/home/#{node['owner_name']}/s3_backup.rb"do
        source 's3.rb.erb'
        owner node['owner_name']
        group node['owner_name']
        mode 0755
        variables({
          :app_name => app_name,
          :aws_access_key_id => node['aws_secret_id'],
          :aws_secret_access_key => node['aws_secret_key'],
          :backup_bucket => node['clone_scripts']['database']['backup_bucket'],
          :backup_ext => node['clone_scripts']['database']['backup_ext'],
          :upload => true
        })
      end
      cron "dump-and-upload-database-for-#{app_name}" do
        action  :delete
      end
      cron "dump-and-upload-database-for-#{app_name}" do
        action  :create
        minute  "0"
        hour    node['clone_scripts']['database']['backup_hour']
        day     "*"
        month   "*"
        weekday node['clone_scripts']['weekday_to_run']
        command "/home/#{node['owner_name']}/database_backup.sh"
        user    "root"
      end
    end

    # Scripts to be rendered on D/R environment only.  database_restore.sh calls s3_restore.rb,
    # it will download the latest eybackup and then import it.
    if node['environment']['name'] == node['clone_scripts']['clone_environment_name']
      template "/home/#{node['owner_name']}/database_restore.sh"do
        source "database_restore.sh.erb"
        owner node['owner_name']
        group node['owner_name']
        mode 0755
        variables({
          :app_name => app_name,
          :user => node['owner_name'],
          :db_type => node['clone_scripts']['database']['db_type'],
          :backup_ext => node['clone_scripts']['database']['backup_ext']
        })
      end

      template "/home/#{node['owner_name']}/s3_restore.rb"do
        source 's3.rb.erb'
        owner node['owner_name']
        group node['owner_name']
        mode 0755
        variables({
          :app_name => app_name,
          :aws_access_key_id => node['aws_secret_id'],
          :aws_secret_access_key => node['aws_secret_key'],
          :backup_bucket => node['clone_scripts']['database']['backup_bucket'],
          :backup_ext => node['clone_scripts']['database']['backup_ext'],
          :upload => false
        })
      end
      cron "download-and-import-database-for-#{app_name}" do
        action  :delete
      end
      cron "download-and-import-database-for-#{app_name}" do
        action  :create
        minute  "0"
        hour    node['clone_scripts']['database']['restore_hour']
        day     "*"
        month   "*"
        weekday node['clone_scripts']['weekday_to_run']
        command "/home/#{node['owner_name']}/database_restore.sh"
        user    "root"
      end
    end
  end

  # Create the directory used to store the backups
  directory "/mnt/tmp/" do
    action :create
  end

end
