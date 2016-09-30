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
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1.tar.bz2
    tar xvjf wkhtmltox-0.12.2.1.tar.bz2
    sudo mv wkhtmltox-0.12.2.1 /usr/local/bin/wkhtmltopdf
    sudo chmod +x /usr/local/bin/wkhtmltopdf
    rm wkhtmltox-0.12.2.1.tar.bz2
  }
  not_if { FileTest.exists?("/usr/local/bin/wkhtmltopdf") }
end
