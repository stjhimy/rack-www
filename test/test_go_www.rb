require "rubygems"
require "rack/www"
require 'test/unit'
require 'rack/test'

class TestWWW < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
   new_app = lambda { |env|
      headers = {'Content-Type' => "text/html"}
      headers['Set-Cookie'] = "id=1; path=/\ntoken=abc; path=/; secure; HttpOnly"
      [200, headers, ["Only WWW!"]]
    }
    @app ||= Rack::WWW.new(new_app)
  end
  attr_writer :app

  def test_response_is_ok
    get "http://www.example.com"
    assert last_response.ok?
  end
end
