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
        url = URI(req.url).scheme + "://www." + host + URI(req.path).to_s
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
