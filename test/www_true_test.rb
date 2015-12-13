require 'helper'

class TrueWWW < TestClass
  def setup
    self.app = Rack::WWW.new(default_app, www: true)
  end

  def test_response_200
    get 'http://www.example.com'
    assert_equal last_response.status, 200
  end

  def test_response_301
    get 'http://example.com'
    assert_equal last_response.status, 301
  end

  def test_redirects
    get 'http://example.com/'
    assert_equal 'http://www.example.com/', last_response.headers['Location']
  end

  def test_www_true
    get 'http://example.com/'
    assert_equal 'http://www.example.com/', last_response.headers['Location']
  end

  def test_www_true_with_path
    get 'http://example.com/path/1'
    assert_equal 'http://www.example.com/path/1',
                 last_response.headers['Location']
  end

  def test_www_true_with_query
    get 'http://example.com/path/1?param=test'
    assert_equal 'http://www.example.com/path/1?param=test',
                 last_response.headers['Location']
  end

  def test_body_with_message
    self.app = Rack::WWW.new(default_app,
                             www: true,
                             message: 'redirecting now!')
    get 'http://example.com/'
    assert_equal last_response.body, 'redirecting now!'
  end

  def test_body_without_message
    get 'http://example.com/'
    assert_equal last_response.body, ''
  end

  def test_server_port
    get 'http://example.com:8080/'
    assert_equal 'http://www.example.com:8080/',
                 last_response.headers['Location']
  end

  def test_server_port_80
    get 'http://example.com:80/'
    assert_equal 'http://www.example.com/',
                 last_response.headers['Location']
  end

  def test_ignore_www_when_ip_request
    get 'http://111.111.111.111/'
    assert_equal last_response.status, 200
    assert_equal '', last_response.headers['Location'].to_s
  end
end
