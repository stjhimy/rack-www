require 'helper'

class PredicateTest < TestClass
  def test_predicate_false
    self.app = Rack::WWW.new(default_app, predicate: ->(_env) { false })
    example
    assert_equal last_response.status, 200
  end

  def test_predicate_true
    self.app = Rack::WWW.new(default_app, predicate: ->(_env) { true })
    example
    assert_equal 'http://www.example.com/', last_response.headers['Location']
  end

  def test_ignore_www_when_ip_request
    get 'http://111.111.111.111/'
    assert_equal last_response.status, 200
    assert_equal '', last_response.headers['Location'].to_s
  end

  private

  def example
    get 'http://example.com/'
  end
end
