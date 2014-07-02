#
# Cookbook Name:: clone_scripts
# Recipe:: default
#

include_recipe "clone_scripts::database"
include_recipe "clone_scripts::deploy"
include_recipe "clone_scripts::rsync"
