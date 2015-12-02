require "helper"

class WWW < TestWWW
  def test_response_200
    get "http://www.example.com"
    assert_equal last_response.status, 200
  end

  def test_response_301
    get "http://example.com"
    assert_equal last_response.status, 301
  end

  def test_redirects
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  def test_www_true
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end

  def test_www_true_with_path
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1"
    assert_equal "http://www.example.com/path/1", last_response.headers['Location']
  end

  def test_www_true_with_query
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/path/1?param=test"
    assert_equal "http://www.example.com/path/1?param=test", last_response.headers['Location']
  end

  def test_www_false
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/"
    assert_equal "http://example.com/", last_response.headers['Location']
  end

  def test_www_false_with_path
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1"
    assert_equal "http://example.com/path/1", last_response.headers['Location']
  end

  def test_www_false_with_query
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://www.example.com/path/1?param=test"
    assert_equal "http://example.com/path/1?param=test", last_response.headers['Location']
  end

  def test_www_false_non_www
    self.app = Rack::WWW.new(default_app, :www => false)
    get "http://example.com/"
    assert last_response.ok?
  end

  def test_body_with_message
    self.app = Rack::WWW.new(default_app, :www => true, :message => "redirecting now!")
    get "http://example.com/"
    assert_equal last_response.body, "redirecting now!"
  end

  def test_body_without_message
    self.app = Rack::WWW.new(default_app, :www => true)
    get "http://example.com/"
    assert_equal last_response.body, ""
  end

  def test_server_port
    get "http://example.com:8080/"
    assert_equal "http://www.example.com:8080/",
    last_response.headers['Location']
  end

  def test_server_port_80
    get "http://example.com:80/"
    assert_equal "http://www.example.com/",
    last_response.headers['Location']
  end

  def test_predicate_false
    self.app = Rack::WWW.new(default_app, :predicate => lambda { |env| false } )
    get "http://example.com/"
    assert_equal last_response.status, 200
  end

  def test_predicate_true
    self.app = Rack::WWW.new(default_app, :predicate => lambda { |env| true } )
    get "http://example.com/"
    assert_equal "http://www.example.com/", last_response.headers['Location']
  end
end
