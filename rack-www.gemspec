Gem::Specification.new do |s|
  s.name      = 'rack-www'
  s.version   = '1.0.0'
  s.date      = '2011-05-06'

  s.homepage    = "https://github.com/stjhimy/rack-www"
  s.summary     = "Force redirects to www."
  s.description = <<-EOS
    Rack middleware to force redirects to www.
  EOS

  s.files = [
    'lib/rack-www.rb',
    'lib/rack/www.rb',
    'LICENSE',
    'README.rdoc'
  ]
  s.require_path = 'lib'

  s.add_dependency 'rack'

  s.authors           = ["Jhimy Fernandes Villar"]
  s.email             = "stjhimy@gmail.com"
end
