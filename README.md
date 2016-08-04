# sensu-checks-php-fpm

Check your php-fpm setup over sockets or on their direct ip/port combination.
So you avoid checking nginx, apache, XYZ along with the check.

## DEPENDENCIES

Testing the sockets directly depends on `libfcgi0ldbl`


## INSTALLATION

This gem will give an actual installation explanation, as the default sensu plugins miss it and the sensu documentation lacks any detailed explanation.

If this gem is listed in rubygems.org, you can just go ahead and do
~~sensu-install -p sensu-check-php-fpm~~


Updated:
As Sensu expects the naming to be "sensu-plugins-FOO", you need to do it another way:
```
/opt/sensu/embedded/bin/gem install --no-ri --no-rdoc sensu-checks-php-fpm
```

If this does not work for you, you can still install it; the hard way.
```
git clone git@github.com:vmpublishing/sensu-checks-php-fpm [SOME_PATH]
cd [SOME_PATH]
/opt/sensu/embedded/bin/gem build *.gemspec
/opt/sensu/embedded/bin/gem install *.gem
```

Alter `/opt/sensu/embedded/bin/gem` to the path to the gem-file sensu uses on your machine.


## USAGE

### ping check

#### Parameters

| name | parameter_name | default value | required | description |
|------|----------------|---------------|----------|-------------|
| hostname | -h, --host |  | yes, unless socket is set | This sets the "Host: " HTTP header for the request |
| port | -P, --port | 80 | no | The port of php-fpm to connect to |
| address | -a, --address | localhost | no | The address of php-fpm to connect to. Hostname or IP |
| query_string | -q, --query-string | no | Optional query string to send along with the path (ie. 'pool=some_pool&sticky_flag=foo' ) |
| ping_path | -p, --ping-path | /ping | no | The configured path, where the ping resides. Check your pool config. |
| response | -r, --response | pong | no | The configured response to the ping request |
| request_timeout | -t, --request-timeout | 60 | no | HTTP request timeout. When the sensu timeout is greater than this and this timeout is reached, it will produce a critical error |
| socket | -s, --socket | nil | no | Check ping over the socket, instead over http. This renders 'hostname', 'port', 'address' and 'request_timeout' useless |

#### sample json config file for sockets
```
{
  "checks": {
    "check_php_fpm_ping": {
      "command":      "check-php-fpm-ping.rb -s /var/run/php-fpm.sock -p /ping",
      "standalone":   true,
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```

#### sample json config file for http
```
{
  "checks": {
    "check_php_fpm_ping": {
      "command":      "check-php-fpm-ping.rb -a 127.0.0.1 -P 5678 -h www.example.com -p /ping -t 60",
      "standalone":   true,
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```

### metrics

#### Parameters

| name | parameter_name | default value | required | description |
|------|----------------|---------------|----------|-------------|
| hostname | -h, --host |  | yes, unless socket is set | This sets the "Host: " HTTP header for the request |
| port | -P, --port | 80 | no | The port of php-fpm to connect to |
| address | -a, --address | localhost | no | The address of php-fpm to connect to. Hostname or IP |
| query_string | -q, --query-string | no | Optional query string to send along with the path (ie. 'pool=some_pool&sticky_flag=foo') |
| status_path | -p, --ping-path | /status | no | The configured path, where the status resides. Check your pool config. |
| request_timeout | -t, --request-timeout | 60 | no | HTTP request timeout. When the sensu timeout is greater than this and this timeout is reached, it will produce a critical error |
| socket | -s, --socket | nil | no | Check ping over the socket, instead over http. This renders 'hostname', 'port', 'address' and 'request_timeout' useless |
| scheme | -C, --scheme | [hostname].php-fpm | no | Metric naming scheme, text to prepend to metric and scheme_append |
| scheme_append | -S, --scheme_append | nil | no | Set a string that will be placed right after the host identification and the script identification but before the measurements (ie. hostname.php-fpm.scheme_append.slow_requests) |

#### sample json config file for sockets
```
{
  "metrics": {
    "metric_php_fpm_status": {
      "type":         "metric",
      "command":      "metric-php-fpm-status.rb -s /var/run/php-fpm.sock -p /status",
      "standalone":   true,
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```

#### sample json config file for http
```
{
  "metrics": {
    "metric_php_fpm_status": {
      "type":         "metric",
      "command":      "metric-php-fpm-status.rb -a 127.0.0.1 -P 5678 -h www.example.com -p /ping -t 60",
      "standalone":   true,
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```


## CONTRIBUTING

Bug reports and pull requests are welcome on GitHub at https://github.com/vmpublishing/sensu-checks-php-fpm.

