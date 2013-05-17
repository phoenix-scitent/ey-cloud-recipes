#############################################
# Sample recipe for emerging packages
# 
# Search the Engine Yard portage tree to find
# out package versions to install
#
# EXAMPLE:
#
# Ensure local package index is synced with tree
# $ eix-sync
#
# Search for libxml2
# $ eix libxml2
#############################################

# Unmask version 2.7.6 of libxml2
# enable_package "dev-libs/libxml2" do
#   version "2.7.6"
# end

# Install the newly unmasked version
# package "dev-libs/libxml2" do
#   version "2.7.6"
#   action :install
# end

# Imagemagick and dependencies via engineyard prebuilt binary
enable_package "media-libs/lcms" do
  version "2.3"
end

enable_package "media-gfx/imagemagick" do
  version "6.7.8.8-r1"
end

package "media-gfx/imagemagick" do
  version "6.7.8.8-r1"
  action :install
end

