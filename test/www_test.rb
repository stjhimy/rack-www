require "helper"

class WWW < TestWWW
  test "response has status 200[ok]" do
    get "http://www.example.com"
    assert_equal last_response.status, 200
  end

  test "response has status 301[redirects]" do
    get "http://example.com"
    assert_equal last_response.status, 301
  end

  test "redirects to right location" do
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test ":www => true" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  test ":www => true with path" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1"
    assert_equal "http://www.example.com/path/1", last_response.headers['Location']
  end

  test ":www => true with query string" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1?param=test"
    assert_equal "http://www.example.com/path/1?param=test", last_response.headers['Location']
  end

  test ":www => false" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/"
    assert_equal "http://example.com/", last_response.headers['Location']
  end

  test ":www => false with path" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1"
    assert_equal "http://example.com/path/1", last_response.headers['Location']
  end

  test ":www => false with query string" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1?param=test"
    assert_equal "http://example.com/path/1?param=test", last_response.headers['Location']
  end

  test ":www => false and non www url" do
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://example.com/"
    assert last_response.ok?
  end

  test "body with :message" do
    self.app = Rack::WWW.new(default_app, :www => true, :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  test "body without :message" do
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal last_response.body, ""
  end

  test "should respect server port" do
    get "http://example.com:8080/"
    assert_equal "http://www.example.com:8080/",
    last_response.headers['Location']
  end

  test "should not display port 80 which is the default anyway" do
    get "http://example.com:80/"
    assert_equal "http://www.example.com/",
    last_response.headers['Location']
  end

  test "predicate returning false" do
    self.app = Rack::WWW.new(default_app, :predicate => lambda { |env| false } )
    get "http://example.com/"
    assert_equal last_response.status, 200
  end

  test "predicate returning true" do
    self.app = Rack::WWW.new(default_app, :predicate => lambda { |env| true } )
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end
end
