Gem::Specification.new do |s|
  s.name      = 'rack-www'
  s.version   = '1.1.0'
  s.date      = '2011-05-10'

  s.homepage    = "https://github.com/stjhimy/rack-www"
  s.summary     = "Force redirects to a single domain with or without www"
  s.description = <<-EOS
    Rack middleware to force redirects all traffic to a single domain with or without www.
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
