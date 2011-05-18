require "rubygems"
require "rack/www"
require 'test/unit'
require 'active_support'
require 'rack/test'

class TestWWW < ActiveSupport::TestCase
  include Rack::Test::Methods

  def default_app
    lambda { |env|
      headers = {'Content-Type' => "text/html"}
      headers['Set-Cookie'] = "id=1; path=/\ntoken=abc; path=/; secure; HttpOnly"
      [200, headers, ["default body"]]
    }
  end

  def app
    @app ||= Rack::WWW.new(default_app)
  end
  attr_writer :app

  test "response has status 200[ok] in the default request" do
    get "http://www.example.com"
    assert_equal last_response.status, 200
  end

  test "response has status 301[redirects] when not a www url" do
    get "http://example.com"
    assert_equal last_response.status, 301
  end

  test "Redirects to right location when it's not www url" do
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test "Redirects to a www url when param :www => true" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test "Redirects to a non www url when param :www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/"
    assert_equal "http://example.com/", last_response.headers['Location']
  end

  test "Keeps the same url when non www url and param :www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://example.com/"
    assert last_response.ok?
  end

  test "Changes the body content when param :message" do
    self.app = Rack::WWW.new(default_app, :www => true, :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  test "Keeps the body empty when not param :message" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal last_response.body, ""
  end
end
