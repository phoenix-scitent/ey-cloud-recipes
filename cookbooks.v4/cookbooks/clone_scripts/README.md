Clone Scripts
=============

Description
-----------

This cookbooks provides scripts to automate a cloned environment.  The following scripts are run:

1) On live environment, upload the latest backup to a specified S3 bucket.
2) On cloned environment, download and import the latest backup from a specified S3 bucket.
3) On cloned environment, run an automated deploy daily.
4) On cloned environment, run an rsync of the shared/system directory from the live environment

Configurations
--------------

Before configuring the cookbook, the key in clone_scripts/files/default/id_rsa.pub needs to be added to both environments via the dashboard.  Next, include the cookbook in the main recipe and configure the following attributes:

```
clone_scripts( 
  'source_environment_name' => "",  # The source environment name
  'clone_environment_name' => "",   # The cloned environment name
  'database' => {  
    :backup_bucket => "",           # A random bucket name to store the latest db dump for the clone
    :backup_hour => "",             # The hour at which the latest db dump should be uploaded to S3
    :restore_hour => "",            # The hour at which the latest db dump should be downloaded from S3 and imported
  },
  'deploy' => {
    :hour => "",                    # The hour at which the automated deploy should happen
    :branch => ""                   # The branch to deploy for the automated deploy 
  },
  'rsync' => {
    :hour => "",                    # The hour at which to begin the rsync
    :source_hostname => "",         # The hostname of the app_master in the source env
  }  
)
```

Once the attributes have been configured and the cookbook included, you can upload and apply the cookbooks.  Once the Chef run is finished, you will need to SSH in to the app_master of the cloned environment and run 'ey login' as the deploy user.  This only needs to be done the *very first* time an environment is booted.  After 'ey login' is run, you have a fully automated cloned environment.

Logs
----

The following logs are written out to in order to verify that each step of the automated clone process finishes:

/home/deploy/clone_database_restore.log
/home/deploy/clone_deploy.log
/home/deploy/clone_rsync.log"