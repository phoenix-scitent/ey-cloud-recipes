clone_scripts( 
  'source_environment_name' => "aha",                               # The source environment name
  'clone_environment_name' => "aha_external_staging_autoclone",     # The cloned environment name
  'database' => {  
    :backup_bucket => "scitent-clone-81491414",                     # A random bucket name to store the latest db dump for the clone
    :backup_hour => "9",                                            # The hour at which the latest db dump should be uploaded to S3 (UTC)
    :restore_hour => "12",                                           # The hour at which the latest db dump should be downloaded from S3 and imported (UTC)
  },
  'deploy' => {
    :hour => "11",                                                   # The hour at which the automated deploy should happen (UTC)
    :branch => "master-data-test"                                   # The branch to deploy for the automated deploy 
  },
  'rsync' => {
    :hour => "10",                                                   # The hour at which to begin the rsync (UTC)
    :source_hostname => "ec2-54-204-1-204.compute-1.amazonaws.com", # The hostname of the app_master in the source env
  }  
)

case attribute['engineyard']['environment']['db_stack_name']
when /mysql/
  clone_scripts[:database][:db_type] = "mysql"
  clone_scripts[:database][:backup_ext] = "gz"
when /postgres/
  clone_scripts[:database][:db_type] = "postgres"
  clone_scripts[:database][:backup_ext] = "gpz"
end
