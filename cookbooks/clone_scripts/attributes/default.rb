clone_scripts(
  'source_environment_name' => "aha_prod",                           # The source environment name
  'clone_environment_name' => "aha_clone",                           # The cloned environment name
  'weekday_to_run' => "0",                                           # The day of week at which the full script occurs, "0" is Sunday (0-6)
  'database' => {
    :backup_bucket => "scitent-clone-51041190d661",                  # A random bucket name to store the latest db dump for the clone
    :backup_hour => "19",                                             # The hour at which the latest db dump should be uploaded to S3 (UTC)
    :restore_hour => "20"                                             # The hour at which the latest db dump should be downloaded from S3 and imported (UTC)
  },
  'deploy' => {
    :hour => "20",                                                    # The hour at which the automated deploy should happen (UTC)
    :branch => "master-data-test"                                    # The branch to deploy for the automated deploy
  },
  'rsync' => {
    :hour => "19",                                                    # The hour at which to begin the rsync (UTC)
    :source_hostname => "ec2-54-243-138-55.compute-1.amazonaws.com", # The hostname of the app_master in the source env
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
