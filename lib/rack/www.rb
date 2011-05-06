require 'rack'
require 'rack/request'

module Rack
  class WWW
    def initialize(app, options = {})
      @app = app
      @options = options
    end

    def call(env)
      status, headers, body = @app.call(env)
      req  = Request.new(env)
      host = URI(req.host).to_s
      if already_www?(host)
        [status, headers, body]
      else
        [301, headers, body]
      end
    end

    private
    def already_www?(host)
      if host.downcase =~ /^(www.)/ 
        true
      else
        false
      end
    end
  end
end
