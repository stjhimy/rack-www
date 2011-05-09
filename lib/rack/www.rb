require 'rack'
require 'rack/request'

module Rack
  class WWW
    def initialize(app, options = {})
      @default_options = {:www => true}
      @app = app
      @www = @default_options.merge(options)[:www]
    end

    def call(env)
      status, headers, body = @app.call(env)
      req  = Request.new(env)
      host = URI(req.host).to_s
      if (already_www?(host) && @www == true) || (!already_www?(host) && @www == false)
        [status, headers, body]
      elsif !already_www?(host) && @www == true
        url = URI(req.url).scheme + "://www." + host + URI(req.path).to_s
        headers = headers.merge('Location' => url)
        [301, headers, body]
      else
        url = URI(req.url).scheme + "://" + host.gsub("www.", "") + URI(req.path).to_s
        headers = headers.merge('Location' => url)
        [301, headers, body]
      end
    end

    private
    def already_www?(host)
      host.downcase =~ /^(www.)/ 
    end
  end
end
