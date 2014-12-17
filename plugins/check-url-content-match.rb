#!/usr/bin/env ruby
#
# Check Deployed Version
# ===
#
# We use this check @ Gogobot to check whether we have a server lagging with an older
# version of the site deployed to it
#
# We check a local URL and then check the load balancer with a host in order to verify this.
#

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'net/http'
require 'net/https'

class CheckHTTP < Sensu::Plugin::Check::CLI

  option :base_url,
    :short => '-b BASE_URL',
    :long => '--base-url BASE_URL',
    :description => 'Specify a base url please',
    :default => 'www.gogobot.com'

  option :load_balancer,
    :short => '-h LOAD_BALANCER',
    :long => '--hostname LOAD_BALANCER',
    :description => 'The load balancer to check the real site against'

  option :use_https,
    :short => '-s USE_HTTPS',
    :long => '--use-https USE_HTTPS',
    :description => 'Should this user HTTPS?',
    :default => '0'

  option :path,
    :short => '-p PATH',
    :long => '--path PATH',
    :description => 'Internal Path'

  def run
    local_response  = get(config[:base_url])
    origin_response = get(config[:load_balancer], true)

    if local_response == origin_response
      ok('Versions Match')
    else
      critical('Versions DO NOT match')
    end
  end

  def get(url, use_header = false)
    schema = config[:use_https].to_i == 1 ? 'https' : 'http'
    uri = URI("#{schema}://#{url}/#{config[:path]}")
    headers = {}
    headers['HOST'] = config[:base_url] if use_header
    http = Net::HTTP.new(uri.host, uri.port)
    path = uri.path
    http.get(path, headers).body
  end
end
