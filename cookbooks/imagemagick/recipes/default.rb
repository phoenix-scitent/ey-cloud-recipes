#
# Cookbook Name:: imagemagick
# Recipe:: default
#

execute "uninstall imagemagick package" do
  command %Q{
    emerge --unmerge imagemagick
  }
end

# this is the most recent stable version tested that works
# 6.7.9-0 did not work
version = '6.7.5-10' 
url = "http://www.imagemagick.org/download/legacy/"
checksum_value = "e1a37ad8931ed41727fbd01c5a044823b2234be158f55a71e7b55fbf755cea91"

remote_file "#{Chef::Config[:file_cache_path]}/ImageMagick-#{version}.tar.gz" do
  source "#{url}ImageMagick-#{version}.tar.gz"
  checksum "#{checksum_value}"
  not_if "/usr/local/bin/convert -version | grep #{version}"
end

bash "compile-imagemagick" do
   cwd Chef::Config[:file_cache_path]
   code <<-EOH
    tar zxvf ImageMagick-#{version}.tar.gz
    cd ImageMagick-#{version}
    ./configure
    make
    make install
    ldconfig /usr/local/lib
    ln -fs /usr/local/include/ImageMagick/wand /usr/local/include/wand
    ln -fs /usr/local/include/ImageMagick/magick /usr/local/include/magick
  EOH
  not_if "/usr/local/bin/convert -version | grep #{version}"
end
