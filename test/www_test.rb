require "helper"

class WWW < TestWWW
  test "response has status 200[ok]" do
    get "http://www.example.com"
    assert_equal last_response.status, 200
  end

  test "response has status 301[redirects] when not www" do
    get "http://example.com"
    assert_equal last_response.status, 301
  end

  test "Redirects to right location" do
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test "Redirects to a www url when param :www => true" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test "Redirects to a www url and keep the right path when param :www => true" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1"
    assert_equal "http://www.example.com/path/1", last_response.headers['Location']
  end

  test "Redirects to a www url and keep the right query string when param :www => true" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1?param=test"
    assert_equal "http://www.example.com/path/1?param=test", last_response.headers['Location']
  end

  test "Redirects to a non www url when param :www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/"
    assert_equal "http://example.com/", last_response.headers['Location']
  end

  test "Redirects to a non  www url and keep the right path when param :www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1"
    assert_equal "http://example.com/path/1", last_response.headers['Location']
  end

  test "Redirects to a non  www url and keep the right query string when param :www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1?param=test"
    assert_equal "http://example.com/path/1?param=test", last_response.headers['Location']
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

  test "Keeps the body empty when there's not a :message param" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal last_response.body, ""
  end
end
