#
# Cookbook Name:: wkhtmltopdf
# Recipe:: default
#

package "x11-libs/libXext" do
  action :install
end
package "app-admin/eselect-fontconfig" do
  action :install
end
package "x11-libs/libXrender" do
  action :install
end
execute "wkhtmltopdf" do
  command %Q{
    wget http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.10.0_rc2-static-amd64.tar.bz2
    tar xvjf wkhtmltopdf-0.10.0_rc2-static-amd64.tar.bz2
    sudo mv wkhtmltopdf-amd64 /usr/local/bin/wkhtmltopdf
    sudo chmod +x /usr/local/bin/wkhtmltopdf
    rm wkhtmltopdf-0.10.0_rc2-static-amd64.tar.bz2
  }
  not_if { FileTest.exists?("/usr/local/bin/wkhtmltopdf") }
end
