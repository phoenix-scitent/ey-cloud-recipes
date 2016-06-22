#
# Cookbook Name: nginx_common
# Attributes: default
#

default[:nginx_common] = {
  :proxy => {
    # You MUST set :use_msec_time. If your nginx is version 1.2.7 or
    # greater, this should be true. Otherwise, it should be false.
    :use_msec_time => true,

    # Should we set a max size for temp files? If so, how many bytes?
    :max_temp_file_size => 500000000,

    # Should we set a connect timeout? If so, how many seconds?
    :connect_timeout => 300,

    # Should we set a read timeout? If so, hoa many seconds?
    :read_timeout => 300,

    # Should we set a send timeout? If so, how many seconds?
    :send_timeout => 300,
  },

  :servers => {
    # What should we use for client max body size? This affects the maximum
    # upload file size. Default: 100M

    :client_max_body_size => '400M',

    :http_white_list => {
      # Should we reject all HTTP verbs that are not whitelisted?

      :enabled => true,

      # What verbs should we accept when whitelisting?
      :accepted_verbs => [
        'ACL',
        'BASELINE-CONTROL',
        'CHECKIN',
        'CHECKOUT',
        'CONNECT',
        'COPY',
        'DELETE',
        'GET',
        'HEAD',
        'LABEL',
        'LOCK',
        'MERGE',
        'MKACTIVITY',
        'MKCOL',
        'MKWORKSPACE',
        'MOVE',
        'OPTIONS',
        'ORDERPATCH',
        'PATCH',
        'POST',
        'PROPFIND',
        'PROPPATCH',
        'PUT',
        'REPORT',
        'SEARCH',
        'TRACE',
        'UNCHECKOUT',
        'UNLOCK',
        'UPDATE',
        'VERSION-CONTROL'
      ],
    }
  }
}
