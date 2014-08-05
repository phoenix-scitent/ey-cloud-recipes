clone_scripts(
  'source_environment_name' => "aha_prod",                               # The source environment name
  'clone_environment_name' => "aha_external_staging_autoclone",     # The cloned environment name
  'database' => {
    :backup_bucket => "scitent-clone-81491414",                     # A random bucket name to store the latest db dump for the clone
    :backup_hour => "5",                                            # The hour at which the latest db dump should be uploaded to S3 (UTC)
    :restore_hour => "8",                                           # The hour at which the latest db dump should be downloaded from S3 and imported (UTC)
    :day => "0"                                                     # The day at which the full script occurs, "0" is Sunday (0-6) 
  },
  'deploy' => {
    :hour => "7",                                                   # The hour at which the automated deploy should happen (UTC)
    :branch => "master-data-test"                                   # The branch to deploy for the automated deploy
  },
  'rsync' => {
    :hour => "6",                                                   # The hour at which to begin the rsync (UTC)
    :source_hostname => "ec2-23-23-234-69.compute-1.amazonaws.com", # The hostname of the app_master in the source env
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
