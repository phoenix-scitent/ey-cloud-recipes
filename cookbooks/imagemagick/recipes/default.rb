#
# Cookbook Name:: imagemagick
# Recipe:: default
#

ey_cloud_report "imagemagick" do 
  message "Everything is commented out." 
end 

# execute "uninstall imagemagick package" do
#   command %Q{
#     emerge --unmerge imagemagick
#   }
# end

# version = '6.7.8-6'
# 
# bash "compile-imagemagick" do
#   cwd Chef::Config[:file_cache_path]
#   code <<-EOH
#     tar zxvf ImageMagick-#{version}.tar.gz
#     cd ImageMagick-#{version}
#     ./configure
#     make
#     make install
#     ldconfig /usr/local/lib
#     ln -s /usr/local/include/ImageMagick/wand /usr/local/include/wand
#     ln -s /usr/local/include/ImageMagick/magick /usr/local/include/magick
#   EOH
#   action :nothing
# end
# 
# remote_file "#{Chef::Config[:file_cache_path]}/ImageMagick-#{version}.tar.gz" do
#   source "http://www.imagemagick.org/download/ImageMagick-#{version}.tar.gz"
#   checksum "e1a37ad8931ed41727fbd01c5a044823b2234be158f55a71e7b55fbf755cea91"
#   notifies :run, resources(:bash => 'compile-imagemagick'), :immediately
# end
