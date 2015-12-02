require "helper"

class PredicateTest < TestClass
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
