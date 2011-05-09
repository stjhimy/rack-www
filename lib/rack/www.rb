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
      status, headers, body = @app.call(env)
      req  = Request.new(env)
      host = URI(req.host).to_s
      if (already_www?(host) && @www == true) || (!already_www?(host) && @www == false)
        [status, headers, @message || body]
      else
        url = prepare_url(req)
        headers = headers.merge('Location' => url)
        [301, headers, @message || body]
      end
    end

    private
    def already_www?(host)
      host.downcase =~ /^(www.)/ 
    end

    def prepare_url(req)
      scheme = URI(req.url).scheme 
      host = URI(req.host).to_s.gsub(/^(www.)/, "")
      path = URI(req.path).to_s
      if @www == true
        host = "://www." + host
      else
        host = "://" + host
      end
      scheme + host + path
    end
  end
end
