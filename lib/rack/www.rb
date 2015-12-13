require 'rack'
require 'rack/request'
require 'ipaddr'

module Rack
  # Rack::WWW
  class WWW
    def initialize(app, options = {})
      @options = { subdomain: 'www' }.merge(options)
      @app = app

      @redirect = !@options[:www].nil? ? @options[:www] : true
      @message = @options[:message]
      @subdomain = @options[:subdomain]
      @predicate = @options[:predicate]
    end

    def call(env)
      if redirect?(env)
        redirect(env)
      else
        @app.call(env)
      end
    end

    private

    def redirect(env)
      url = prepare_url(env)
      headers = { 'Content-Type' => 'text/html', 'location' => url }

      if @message.respond_to?(:each)
        message = @message
      else
        message = [@message || '']
      end
      [301, headers, message]
    end

    def redirect?(env)
      predicate?(env) && change_subdomain?(env) && !ip_request?(env)
    end

    def predicate?(env)
      if @predicate
        @predicate.call env
      else
        true
      end
    end

    def change_subdomain?(env)
      @redirect && !already_subdomain?(env) ||
        !@redirect && already_subdomain?(env)
    end

    def ip_request?(env)
      IPAddr.new(env['SERVER_NAME'].to_s
        .gsub(/^(#{@subdomain}\.)/, '')
        .gsub(/^(www\.)/, ''))
    rescue IPAddr::InvalidAddressError
      false
    end

    def already_subdomain?(env)
      env['HTTP_HOST'].to_s.downcase =~ /^(#{@subdomain}\.)/
    end

    def prepare_url(env)
      scheme = env['rack.url_scheme']
      host, port, path, query_string = extract_host(env)

      if @redirect == true
        host = "://#{@subdomain}." + host
      else
        host = '://' + host
      end

      "#{scheme}#{host}#{port}#{path}#{query_string}"
    end

    def extract_host(env)
      [env['SERVER_NAME'].to_s.gsub(/^(#{@subdomain}\.|www\.)/, ''),
       env['SERVER_PORT'] == '80' ? '' : ":#{env['SERVER_PORT']}",
       env['PATH_INFO'],
       env['QUERY_STRING'].empty? ? '' : '?' + env['QUERY_STRING'].to_s]
    end
  end
end
