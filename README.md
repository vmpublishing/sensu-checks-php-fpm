# Sensu::Checks::Php::Fpm

Check your php-fpm setup over sockets or on their direct ip/port combination.
So you avoid checking nginx, apache, XYZ along with the check.

## Installation

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

## Usage

TODO: Write usage instructions here

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sensu-checks-php-fpm.

