# #
# # Cookbook Name:: packages
# # Recipe:: default
# #

# # node[:packages].each do |package|

# #   ey_cloud_report "package-install" do
# #     message "Installing #{package[:name]}-#{package[:version]}"
# #   end
  
# #   enable_package package[:name] do
# #     version package[:version]
# #   end
    
# #   package package[:name] do 
# #     version package[:version]
# #     action :install 
# #   end

# #   Chef::Log.info "Updating Java JDK"
# #     enable_package 'dev-java/icedtea-bin' do
# #       version '7.2.6.8'
# #       unmask true
# #     end

#   # Forcing 'install' because if lower version packages are installed
#   # then 'upgrade' installs the desired version every time it runs.
#   package 'dev-java/icedtea-bin' do
#     version '7.2.6.8'
#     action :install
#   end

#   execute "Set the default Java version to icedtea-bin-7" do
#     command "eselect java-vm set system icedtea-bin-7"
#     action
#   end

# end

