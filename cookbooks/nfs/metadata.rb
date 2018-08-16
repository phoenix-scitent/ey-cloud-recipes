name 'nfs'

%w{ ubuntu debian redhat centos scientific amazon }.each do |os|
  supports os
end
