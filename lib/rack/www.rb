require 'rack'
require 'rack/request'

module Rack
  class WWW
    def initialize(app, options = {})
      @options = {:www => true}.merge(options)
      @app = app
      @www = @options[:www]
      @message = @options[:message]
    end

    def call(env)
      if (already_www?(env) && @www) || (!already_www?(env) && !@www)
        @app.call(env)
      else
        url = prepare_url(env)
        headers = {"Content-Type" => "text/html", "location" => url}
        [301, headers, @message || ""]
      end
    end

    private
    def already_www?(env)
      env["HTTP_HOST"].downcase =~ /^(www.)/ 
    end

    def prepare_url(env)
      scheme = env["rack.url_scheme"]
      host = env["SERVER_NAME"].gsub(/^(www.)/, "")
      path = env["PATH_INFO"]

      query_string = ""
      if !env["QUERY_STRING"].empty?
        query_string = "?" + env["QUERY_STRING"]
      end

      if @www == true
        host = "://www." + host
      else
        host = "://" + host
      end
      scheme + host + path + query_string
    end
  end
end
