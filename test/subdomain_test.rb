require "helper"

class SubdomainTest < TestClass
  def setup
    self.app = Rack::WWW.new(default_app, :subdomain => "secure")
  end

  def test_if_allow_custom_subdomain
    get 'http://example.com'
    assert_equal 'http://secure.example.com/', last_response.headers['Location']
  end

  def test_custom_subdomain_with_path
    get "http://example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  def test_custom_subdomain_with_path_and_www
    get "http://www.example.com/path/1"
    assert_equal "http://secure.example.com/path/1", last_response.headers['Location']
  end

  def test_custom_subdomain_with_query
    get "http://example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  def test_custom_subdomain_with_query_and_www
    get "http://www.example.com/path/1?test=true"
    assert_equal "http://secure.example.com/path/1?test=true", last_response.headers['Location']
  end

  def test_body_with_custom_subdomain_and_message
    self.app = Rack::WWW.new(default_app, :subdomain => "secure", :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  def test_body_with_custom_subdomain_without_message
    get "http://example.com/"
    assert_equal last_response.body, ""
  end

  def test_ignore_www_when_ip_request
    get "http://111.111.111.111/"
    assert_equal last_response.status, 200
    assert_equal "", last_response.headers["Location"].to_s
  end
end
