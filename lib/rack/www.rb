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
      [status, headers, body]
    end
  end
end
