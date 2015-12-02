require "rack/www"
require 'minitest/autorun'
require 'rack/test'

class TestWWW < MiniTest::Test
  include Rack::Test::Methods

  def default_app
    lambda { |env|
      headers = {'Content-Type' => "text/html"}
      headers['Set-Cookie'] = "id=1; path=/\ntoken=abc; path=/; secure; HttpOnly"
      [200, headers, ["default body"]]
    }
  end

  def app
    @app ||= Rack::Lint.new(Rack::WWW.new(default_app))
  end

  attr_writer :app
end
