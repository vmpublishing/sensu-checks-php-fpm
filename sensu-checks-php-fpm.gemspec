# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


if RUBY_VERSION < '2.0.0'
  require 'sensu-checks-php-fpm'
else
  require_relative 'lib/sensu-checks-php-fpm'
end


Gem::Specification.new do |spec|
  spec.name          = "sensu-checks-php-fpm"
  spec.version       = SensuChecksPhpFpm::Version::VER_STRING
  spec.authors       = ["vmpublishing development"]
  spec.email         = ["dev@vmpublishing.com"]

  spec.summary       = 'sensu gem to check php-fpm directly, without nginx or apache, using socket [or possibly ip]'
  spec.description   = 'sensu gem to check php-fpm directly, without nginx or apache, using socket [or possibly ip]'
  spec.homepage      = "https://github.com/vmpublishing/sensu-checks-php-fpm"
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  spec.executables   = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'sensu-plugin', '~> 1.2'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end

