require 'rack/www'
require 'minitest/autorun'
require 'rack/test'

class TestClass < MiniTest::Test
  include Rack::Test::Methods

  def default_app
    lambda do |_env|
      headers = { 'Content-Type' => 'text/html' }
      [200, headers, ['default body']]
    end
  end

  def app
    @app ||= Rack::Lint.new(Rack::WWW.new(default_app))
  end

  attr_writer :app
end
