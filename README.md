[![Build Status](https://travis-ci.org/stjhimy/rack-www.svg?branch=master)](https://travis-ci.org/stjhimy/rack-www)

## rack-www

Rack middleware to force subdomain redirects, e.g: www or www2

### Installation

```ruby
  #default installation
  gem install rack-www

  #when using bundler
  gem 'rack-www'
```

### Usage

Default usage (by default will redirect all requests to www subdomain):

```ruby
  #redirects all traffic to www subdomain
  config.middleware.use Rack::WWW
```

Customizing the :www option to true or false:

```ruby
  #redirects all traffic to www
  config.middleware.use Rack::WWW, www: true


  #redirects all traffic to the same domain without www
  config.middleware.use Rack::WWW, www: false
```

Redirecting to a given subdomain:

```ruby
  #redirects all traffic to the 'secure' subdomain
  config.middleware.use Rack::WWW, :subdomain => "secure"
```

If you like it's also possible to show a message while redirecting the user:

```ruby
  config.middleware.use Rack::WWW, :www => false, :message => "You are being redirected..."
```

You can optionally specify predicate to determine if redirect should take place:

```ruby
  config.middleware.use Rack::WWW, :predicate => lambda { |env|
    !Rack::Request.new(env).params.has_key? "noredirect"
  }
```

It ignores any redirects when using IP addresses.

### Options

- :www => default is true, redirects all traffic to www;
- :subdomain => redirects to any given subdomain;
- :message => display a message while redirecting;


### License

MIT License. Copyright Jhimy Fernandes Villar http://stjhimy.com
