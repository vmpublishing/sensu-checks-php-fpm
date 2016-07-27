# sensu-checks-php-fpm

Check your php-fpm setup over sockets or on their direct ip/port combination.
So you avoid checking nginx, apache, XYZ along with the check.

## DEPENDENCIES

Testing the sockets directly depends on `libfcgi0ldbl`


## INSTALLATION

This gem will give an actual installation explanation, as the default sensu plugins miss it and the sensu documentation lacks any detailed explanation.

If this gem is listed in rubygems.org, you can just go ahead and do
```
sensu-install -p sensu-check-php-fpm
```

If this gem is not listed there, you can still install it; the hard way.
```
git clone git@github.com:vmpublishing/sensu-checks-php-fpm [SOME_PATH]
cd [SOME_PATH]
/opt/sensu/embedded/bin/gem build *.gemspec
/opt/sensu/embedded/bin/gem install *.gem
```

Alter `/opt/sensu/embedded/bin/gem` to the path to the gem-file sensu uses on your machine.


## USAGE

### Parameters (ping check)

| name | default value | required | description |
|------|---------------|----------|-------------|
| hostname | '' | yes, unless socket is set | This sets the "Host: " HTTP-Header for the request |
 

### sample check file over sockets
```
{
  "checks": {
    "check_php_fpm_ping": {
      "command":      "check-php-fpm-ping.rb -s /var/run/php-fpm.sock -p /ping",
      "standalone":   true,
      "subscribers":  ["all"],
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```

### sample check file over http
```
{
  "checks": {
    "check_php_fpm_ping": {
      "command":      "check-php-fpm-ping.rb -a 127.0.0.1 -P 5678 -h www.example.com -p /ping -t 60",
      "standalone":   true,
      "subscribers":  ["all"],
      "interval":     10,
      "timeout":      120,
      "ttl":          180
    }
  }
}
```

TODO: Write usage instructions here


## CONTRIBUTING

Bug reports and pull requests are welcome on GitHub at https://github.com/vmpublishing/sensu-checks-php-fpm.

