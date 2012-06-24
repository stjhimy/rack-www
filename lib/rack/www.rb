require 'rack'
require 'rack/request'

module Rack
  class WWW
    def initialize(app, options = {})
      @options = {:subdomain => "www" }.merge(options)
      @app = app

      @redirect = true
      @redirect = @options[:www] if @options[:www] != nil
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
      headers = {"Content-Type" => "text/html", "location" => url}

      if @message.respond_to?(:each)
        message = @message
      else
        message = [@message || '']
      end
      [301, headers, message]
    end

    def redirect?(env)
      predicate?(env) && change_subdomain?(env)
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

    def already_subdomain?(env)
      env["HTTP_HOST"].downcase =~ /^(#{@subdomain}.)/
    end

    def prepare_url(env)
      scheme = env["rack.url_scheme"]

      host = env["SERVER_NAME"].gsub(/^(#{@subdomain}.)/, "")
      host = host.gsub(/^(www.)/, "")

      if env['SERVER_PORT'] == '80'
        port = ''
      else
        port = ":#{env['SERVER_PORT']}"
      end

      path = env["PATH_INFO"]

      query_string = ""
      if !env["QUERY_STRING"].empty?
        query_string = "?" + env["QUERY_STRING"]
      end

      if @redirect == true
        host = "://#{@subdomain}." + host
      else
        host = "://" + host
      end
      "#{scheme}#{host}#{port}#{path}#{query_string}"
    end
  end
end
