#
# Cookbook Name:: clone_scripts
# Recipe:: default
#

execute "install-fog-to system" do
  command "gem install nokogiri -v 1.5.11 && gem install  fog -v 1.19.0"
  not_if "gem list fog"
end

include_recipe "clone_scripts::database"
include_recipe "clone_scripts::deploy"
include_recipe "clone_scripts::rsync"
