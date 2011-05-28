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
end
