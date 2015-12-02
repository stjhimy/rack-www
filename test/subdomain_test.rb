require "helper"

class SubdomainTest < TestWWW
  def test_if_allow_custom_subdomain
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get 'http://example.com'
    assert_equal 'http://secure.example.com/', last_response.headers['Location']
  end

  def test_custom_subdomain_with_path
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  def test_custom_subdomain_with_path_and_www
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://www.example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  def test_custom_subdomain_with_query
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  def test_custom_subdomain_with_query_and_www
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://www.example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  def test_body_with_custom_subdomain_and_message
    self.app = Rack::WWW.new(default_app, :subdomain => "secure", :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  def test_body_with_custom_subdomain_without_message
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
    get "http://example.com/"
    assert_equal last_response.body, ""
  end
end
