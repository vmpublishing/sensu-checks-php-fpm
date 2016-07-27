#!/usr/bin/env ruby

require 'sensu-plugin/check/cli'
require 'net/http'


class CheckPhpFpmPing < Sensu::Plugin::Check::CLI

  option :hostname,
         short:            '-h HOSTNAME',
         long:             '--host HOSTNAME',
         description:      'This sets the "Host: " parameter of the HTTP-Request, not the address (ie. www.example.com). When not using sockets, this is required!',
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

  option :query_string,
         short:            '-q ARGUMENTS',
         long:             '--query-string ARGUMENTS',
         description:      "optional query string to send (ie: 'pool=some_pool&stick_flag=13')",
         default:          ''

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

  option :request_timeout,
         short:            '-t TIMEOUT',
         long:             '--request-timeout TIMEOUT',
         description:      'Set the connect timeout to X',
         default:          '60'

  def run

    if config[:socket] # do something completely different on this flag
      response = `SCRIPT_NAME=#{config[:ping_path]} SCRIPT_FILENAME=#{config[:ping_path]} QUERY_STRING=#{config[:query_string]} REQUEST_METHOD=GET cgi-fcgi -bind -connect #{config[:socket]}`
      response_body = response.split("\r\n\r\n")[1]
      if config[:response] == response_body
        ok "PHP-FPM said '#{response_body}'"
      else
        critical "PHP-FPM said '#{response.body}' instead of '#{config[:response]}'"
      end
    else # ok, do the http stuff
      uri = URI("http://#{config[:hostname]}#{config[:ping_path]}?#{config[:query_string]}") # actually hostname does not matter at this point, as it is overwritten

      response = Net::HTTP.start(config[:address], config[:port], read_timeout: config[:request_timeout].to_i) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Host'] = config[:hostname] # it matters here

        http.request(request)
      end

      if '200' == response.code
        if config[:response] == response.body
          ok "PHP-FPM said '#{response.body}'"
        else
          critical "PHP-FPM said '#{response.body}' instead of '#{config[:response]}'"
        end
      else
        critical "Expected 200, #{response.code} found"
      end # response.code

    end # http section

  rescue Net::ReadTimeout: e
    critical "PHP-FPM request timeout: '#{e.message}'"
  end # def run

end # class

