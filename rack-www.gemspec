Gem::Specification.new do |s|
  s.name      = 'rack-www'
  s.version   = '1.5.0'
  s.date      = '2012-06-25'

  s.homepage    = "https://github.com/stjhimy/rack-www"
  s.summary     = "Force redirects to a any given subdomain, e.g: www."
  s.description = <<-EOS
    Rack middleware to force subdomain redirects, e.g: www.
  EOS

  s.files = [
    'lib/rack-www.rb',
    'lib/rack/www.rb',
    'LICENSE',
    'CHANGELOG.rdoc',
    'README.rdoc'
  ]
  s.require_path = 'lib'

  s.add_dependency 'rack'

  s.authors           = ["Jhimy Fernandes Villar"]
  s.email             = "stjhimy@gmail.com"
end
