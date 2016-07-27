
require 'sensu-plugin/check/cli'


class CheckPhpFpmPing < Sensu::Plugin::Check::CLI

  option :hostname,
         short:            '-h HOSTNAME',
         long:             '--host HOSTNAME',
         description:      'This sets the "Host: " parameter of the HTTP-Request, not the address. When not using sockets, this is required!',
         default:          ''

  option :port,
         short:            '-P PORT',
         long:             '--port PORT',
         description:      'The php-fpm port to check',
         default:          '80'

  option :address,
         short:            '-a ADDRESS',
         long:             '--address ADDRESS',
         description:      "The php-fpm address to check. examples: '127.0.0.1' or 'localhost'",
         default:          'localhost'

  option :http_arguments,
         short:            '-A ARGUMENTS',
         long:             '--http-arguments ARGUMENTS',
         description:      "optional query parameters to send (ie: 'pool=some_pool&stick_flag=13')",
         default:          nil

  option :ping_path,
         short:            '-p PATH',
         long:             '--ping-path PATH',
         description:      'The configured path for the ping test in your php-fpm.ini / pool*.ini',
         default:          '/ping'

  option :response,
         short:            '-r RESPONSE',
         long:             '--response RESPONSE',
         description:      'The expected response on the ping request',
         default:          'pong'

  option :socket,
         short:            '-s SOCKET',
         long:             '--soclet SOCKET',
         description:      'Request ping over socket. This renders :hostname, :port, :address and :http_arguments useless',
         default:          nil

  def run
  end
end

