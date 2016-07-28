#!/usr/bin/env ruby

require 'sensu-plugin/metric/cli'
require 'net/http'


class MetricPhpFpmStatus < Sensu::Plugin::Metric::CLI::Graphite

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

  option :status_path,
         short:            '-p PATH',
         long:             '--ping-path PATH',
         description:      'The configured path for the ping test in your php-fpm.ini / pool*.ini',
         default:          '/status'

  option :socket,
         short:            '-s SOCKET',
         long:             '--soclet SOCKET',
         description:      'Request ping over socket. This renders :hostname, :port, :address and :request_timeout useless',
         default:          nil

  option :request_timeout,
         short:            '-t TIMEOUT',
         long:             '--request-timeout TIMEOUT',
         description:      'Set the connect timeout to X',
         default:          '60'

  option :scheme,
         short:            '-C SCHEME',
         long:             '--scheme SCHEME',
         description:      'Metric naming scheme, text to prepend to metric and scheme_append',
         default:          "#{Socket.gethostname}.php-fpm"

  option :scheme_append,
         short:            '-S APPEND_STRING',
         long:             '--scheme-append APPEND_STRING',
         description:      'Set a string that will be placed right after the host identification and the script identitfication but before the measurements',
         default:          nil


  def run

    body = if config[:socket] # do something completely different on this flag

      response = `SCRIPT_NAME=#{config[:ping_path]} SCRIPT_FILENAME=#{config[:ping_path]} QUERY_STRING=#{config[:query_string]} REQUEST_METHOD=GET cgi-fcgi -bind -connect #{config[:socket]}`
      response.split("\r\n\r\n")[1]

    else # ok, do the http stuff

      uri = URI("http://#{config[:hostname]}#{config[:status_path]}?#{config[:query_string]}") # actually hostname does not matter at this point, as it is overwritten

      response = Net::HTTP.start(config[:address], config[:port], read_timeout: config[:request_timeout].to_i) do |http|
        request = Net::HTTP::Get.new(uri)
        request['Host'] = config[:hostname] # it matters here

        http.request(request)
      end
      response.body

    end # end http section

    accepted_fields = %w(
      start_since
      accepted_conn
      listen_queue
      max_listen_queue
      listen_queue_len
      idle_processes
      active_processes
      total_processes
      max_active_processes
      max_children_reached
      slow_requests
    )
    body.gsub("\r", '').split("\n").each do |status_line|
      field_name, field_value = status_line.split(':').map(&:strip).map{|value| value.gsub(' ', '_')}
      next unless accepted_fields.include?(field_name)

      if config[:scheme_append]
        output "#{config[:scheme]}.#{config[:scheme_append]}.#{field_name}", field_value
      else
        output "#{config[:scheme]}.#{field_name}", field_value
      end
    end

    ok
  rescue Net::ReadTimeout => e # it's the job of the check to determine errors, so do nothing
  end # def run

end # class

