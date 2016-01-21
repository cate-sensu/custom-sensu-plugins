#!/usr/bin/env ruby

# Check Nginx Waiting connections
#
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'net/http'
require 'net/https'

class CheckNginxHealth < Sensu::Plugin::Check::CLI

  option :nginx_url,
    :short => '-b nginx_url',
    :long => '--nginx-url nginx_url',
    :description => 'Specify an nginx health_check url please',
    :default => 'http://127.0.0.1/nginx_status'

  option :warn,
         short: '-w warn',
         proc: proc(&:to_i),
         description: 'request queue warn threshold'

  option :critical,
         short: '-c critical',
         proc: proc(&:to_i),
         description: 'request queue critical threshold'

  def run
    uri      = URI.parse(config[:nginx_url])
    http     = Net::HTTP.new(uri.host, uri.port)
    request  = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    line = response.body.split(/\r?\n/).last

    if line.match(/^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/)
      queue = line.match(/^Reading:\s+(\d+).*Writing:\s+(\d+).*Waiting:\s+(\d+)/).to_a
      waiting = queue[3].to_i

      puts "Waiting: #{waiting}"

      if waiting >= config[:critical]
        return critical("Nginx is very busy. Make sure load is not too much (add servers if needed)")
      end
      if waiting >= config[:warn]
        return warn("Nginx is slightly busy right now")
      end

      return ok
    else
      return critical "nginx_status response unexpected"
    end
  end
end
