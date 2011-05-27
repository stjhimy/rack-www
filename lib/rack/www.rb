require 'rack'
require 'rack/request'

module Rack
  class WWW
    def initialize(app, options = {})
      @options = {:redirect => true, :subdomain => "www", :ssl => false}.merge(options)
      @app = app
      @redirect = @options[:redirect]
      @message = @options[:message]
      @subdomain = @options[:subdomain]
      @ssl = @options[:ssl]
      #@host = @options[:ssl]
    end

    def call(env)
      if (already_subdomain?(env) && @redirect) || (!already_subdomain?(env) && !@redirect)
        @app.call(env)
      else
        url = prepare_url(env)
        headers = {"Content-Type" => "text/html", "location" => url}
        [301, headers, @message || ""]
      end
    end

    private
    def already_subdomain?(env)
      env["HTTP_HOST"].downcase =~ /^(#{@subdomain}.)/ 
    end

    def prepare_url(env)
      #scheme = env["rack.url_scheme"]
      scheme = @ssl ? "https" : "http"

      host = env["SERVER_NAME"].gsub(/^(#{@subdomain}.)/, "")
      puts "#{env["SERVER_NAME"]} \n"
      puts "#{host} \n"

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
      scheme + host + path + query_string
    end

  end
end
