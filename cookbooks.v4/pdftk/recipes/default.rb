#
# Cookbook Name:: pdftk
# Recipe:: default
#
execute "pdftk" do
  command %Q{
    emerge -v sys-devel/gcc pdftk
  }
end
