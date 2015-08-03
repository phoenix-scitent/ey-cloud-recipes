# Nginx Common Cookbook for Engine Yard Cloud #

This cookbook allows you to manage custom configurations within the nginx "common" directory on EngineYard Classic Cloud.

It is directly applicable to "solo" and "app" instances, and it coveres the following nginx files:

* common/servers.conf
* common/proxy.conf

It does the following for each of those files:

1. Apply customizations
2. Create a "keep" file so the main chef will not change the file

## common/servers.conf ##

The `common/servers.conf` file is configured via a handful of attributes. Specifically, one can easily configure the global `client_max_body_size`, and one can configure a list of HTTP verbs that are allowed for use on the server (non-whitelisted verbs being rejected via status 403).

### Client Max Body Size ###

One can use the cookbook's `client_max_body_size` attribute to raise or lower the maximum size of a request that a client can make. Most typically, this is used to increase the maximum size of a file that a user can upload. If this value is not configured, it defaults to "100M"

```
# attributes/default.rb

default[:nginx_common] = {
  :servers => {
    :client_max_body_size => '100M'
  }
}
```

### HTTP Verb Whitelisting ###

In an effort to increase application security (or, at the least, reduce the app attack surface size a bit), one can use a verb whitelist to refuse requests for verbs that are not allowed. This functionality must be enabled via `default[:common_server][:http_white_list][:enabled]`, and the whitelist itself (`default[:common_server][:http_white_list][:accepted_verbs]`) is an array of HTTP verbs.

By default, the whitelist is **not** enabled.

```
# attributes/default.rb

default[:nginx_common] = {
  :servers => {
    :http_white_list => {
      # Enable the whitelist
      :enabled => true,

      # Accept an incredibly small subset of verbs
      :accepted_verbs => [
        'GET',
        'POST',
        'PUT'
      ]
    }
  }
}
```

## common/proxy.conf ##

The common/proxy.conf file is configured via a handful of attributes. Specifically, one can easily configure the global `proxy_max_temp_file_size`, `proxy_connect_timeout`, `proxy_read_timeout`, `proxy_send_timeout`, and time formatting for the X-Queue-Start header

### X-Queue-Start time format ###

As of version 1.2.7, nginx supports millisecond time resolution, so the X-Queue-Start header should be expressed in terms of milliseconds. Unfortunately, this cookbook cannot detect the version of nginx that is installed, so this must be set manually. **It has no default, instead raising an error if the feature is not explicitly enabled/disabled.**

```
# attributes/default.rb

# use_msec_time is true to enable, false to disable

default[:nginx_common] = {
  :proxy => {
    :use_msec_time => true
  }
}
```

### Proxy Max Temp File Size ###

Set the global `proxy_max_temp_file_size`, which defaults to 0 if not specified.

```
# attributes/default.rb

default[:nginx_common] = {
  :proxy => {
    :max_temp_file_size => 0
  }
}
```

### Proxy Connection Timeout ###

Set the global `proxy_connect_timeout`. If not configured, the default nginx setting will be used.

```
# attributes/default.rb

default[:nginx_common] = {
  :proxy => {
    :connect_timeout => 300
  }
}
```


### Proxy Read Timeout ###

Set the global `proxy_read_timeout`. If not configured, the default nginx setting will be used.

```
# attributes/default.rb

default[:nginx_common] = {
  :proxy => {
    :read_timeout => 300
  }
}
```

### Proxy Send Timeout ###

Set the global `proxy_send_timeout`. If not configured, the default nginx setting will be used.

```
# attributes/default.rb

default[:nginx_common] = {
  :proxy => {
    :send_timeout => 300
  }
}
```

## Full Example ##

Tying it all together, here's an example that uses all of the `nginx_common` customizations:

```
# attributes/default.rb

default[:nginx_common] = {
  :proxy => {
    :use_msec_time => true,
    :max_temp_file_size => 0,
    :connect_timeout => 300,
    :send_timeout => 300,
    :read_timeout => 300
  },

  :servers =>
    :client_max_body_size => '500M',

    :http_white_list => {
      :enabled => true,

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
      ]
    }
  }
}
```


