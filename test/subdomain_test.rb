require "helper"

class SubdomainTest < TestWWW
  test 'allow custom subdomain' do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get 'http://example.com'
    assert_equal 'http://secure.example.com/', last_response.headers['Location']
  end

  test "custom subdomain with path" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  test "custom subdomain with path and www" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://www.example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  test "custom subdomain with query string" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  test "custom subdomain with query string and www" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://www.example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  test "body with custom subdomain and :message" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure", :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  test "body with custom subdomain without :message" do
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
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
end
