---
layout: post
title: Building a Rack-based CMS (Part 1)
published: false
---
## Getting Started

This tutorial assumes a basic familiarity with [Ruby](http://ruby-lang.org), and
particularly with [Rack][]-based applications, such as
[Rails](http://rubyonrails.org) and [Sinatra](http://sinatrarb.com), but we'll
cover how the whole process goes, since there's quite a few things we want to
cover in the tutorial series:

* using [Bundler][] for gem creation and deployment;
* using [Rack][] for application creation and running;
* using [Liquid][] for templates;
* using [Markdown][] for content;
* using [Nokogiri][] for HTML/XML parsing; and
* using an API from [third party service](http://opencalais.org) for automatic
  tag generation.

For the first part of the tutorial, you'll need the following gems installed:

* [Bundler][] (to create the gem)
* [Rack][] (to run the application)

## Rack background

[Rack][] provides a simple application server. It runs using a rackup file
(default is `config.ru`) which is just a special type of [Ruby][] script (kind
of like a Rakefile). To be a valid [Rack][] application, the file must contain a
class which responds to a method called `call` which takes a single parameter
(usually called `env` for the environment). This method must return an array
with the following structure:

    [HTTP_STATUS_CODE, {'Hash' => 'HTMLHeaderOptions'}, ['Content']]

Note: `'Content'` doesn't have to be in an array, but best practices suggests it
should.

For example, to return a simple "Hello, world!" page, you would return the
following:

    [200, {'Content-Type' => 'text/plain'}, ['Hello, world!']]

That is, a `200` (Success) HTTP status code, a header stating that the content
type is plain text and the text string of the content (in an array). To run the
application you call `run` with an instance of the application. That's the basic
premise of **every** [Rack][] application. Simple but extremely powerful.

The full code for this hello world app is:

{% highlight ruby linenos %}
# config.ru
require 'rubygems'
require 'rack'
class HelloWorld
  def call(env)
    [200, {'Content-Type' => 'text/plain'}, ['Hello, world!']]
  end
end
run HelloWorld.new
{% endhighlight %}

Note: Since we're not providing any parameters or loading anything, we don't
need to include an explicit `initialize` method for the class; it is
automatically passed through to the parent class (i.e. `Object`).

## The app

### 1. Create a new gem

    $ bundle gem <gemname>

This will create a new gem of `<gemname>`. In the tutorial, we'll be using
`otto`, since Prince Otto was another character from RL Stevenson, and, well,
[Jekyll](http://github.com/mojombo/jekyll) is awesome.

### 2. Create a rackup file

Since we don't want to worry about gem structure in the early stages, we will
first build the gem in the `config.ru` file. I just put this in a '`tmp`'
directory in the gem and add it to the `.gitignore` file (assuming you're using
git).

    $ mkdir tmp
    $ cd tmp
    $ touch config.ru

We'll need to include the rack gem (and rubygems in most cases) in order to run the rackup file.

{% highlight ruby linenos %}
# config.ru
require 'rubygems'
require 'rack'
{% endhighlight %}

### 3. Creating a rack application

All rack applications require at least one method: `call(env)`. Since we also want to pass parameters to the application, we'll need an `initialize` method.

{% highlight ruby linenos %}
# config.ru
module Otto
  class Site
    def initialize(opts = {})
    end

    def call(env)
      # Dummy output so we can run the application
      [200, {'Content-Type' => 'text/plain'}, 'Hello, world!']
    end
  end
end
{% endhighlight %}

At the moment, the initialize function does nothing; likewise, the call function just returns the text string `Hello, world!`; at the end of the rackup file, we can launch the application thus:

{% highlight ruby %}
# config.ru
run Otto::Site.new
{% endhighlight %}

Running `rackup` from the command line should then let us browse to `localhost:9292` and see the "`Hello, world!`" string.

### 4. Passing configuration options to the application

Since we want to pull content from a remote repository, we'll need to provide a URL for the application to access. Since we don't want it to be possible to run the application without providing a URL, we'll check for this parameter and raise an exception if it doesn't exist or is an invalid protocol (at the moment, we're only providing support for http and https).

{% highlight ruby linenos %}
# config.ru
module Otto
  # Dummy class for our exception
  class InvalidURLException < StandardError; end

  class Site
    attr_accessor :base # The base URL from which the content is accessible.
    def initialize(opts = {})
      raise InvalidURLException, "You must provide a valid URL for the content" \
        if !opts[:url] || opts[:url] !~ /^https?\:/
      @base = opts[:url]
    rescue InvalidURLException => e
      p e.message
      p e.stacktrace
      # And since we don't want the application to continue in this case...
      raise SystemExit
    end
    ...
  end
end
{% endhighlight %}

Note that our exception class inherits from `StandardError` rather than `Exception`; this is because `StandardError` provides the base class for application-level errors and exceptions, while the parent `Exception` class also deals with system environment errors (which we don't want to worry about). Raising the `SystemExit` exception at the end of the rescue method means that the execution of the script will halt (since we don't want to keep loading stuff after this exception occurs).

### 5. Displaying some slightly more dynamic content

We'll wrap the `env` parameter in a `Rack::Request` object since it provides us with some nicer accessor methods. To do this, we need to load `rack/request`. If you don't want to use this, you can also access via `env['ENVIRONMENT_VARIABLE']`, e.g. `env['PATH_INFO']`.

{% highlight ruby linenos %}
# config.ru
require 'rack'
require 'rack/request'

module Otto
  ...
  class Site
    ...
    def call(env)
      request = Rack::Request.new(env)
      path_info = request.path_info
      content = ["URL Base:  #{base}", "Path Info: #{path_info}"]
      [200, {'Content-Type' => 'text/plain'}, content.join("\n")]
    end
  end
end

run Otto::Site.new :url => "https://www.dropbox.com/path/to/app"
{% endhighlight %}

We're not really doing much here, just passing through the url parameter from the initialization and the path info for the request. Still, if you visit `localhost:9292` you should get:

    URL Base:  https://www.dropbox.com/path/to/app
    Path Info: /

Likewise if you visit `localhost:9292/about` you should get:

    URL Base:  https://www.dropbox.com/path/to/app
    Path Info: /about

So there's some basics for [Rack][]. Next up, loading the remote content...

[Bundler]: http://localhost
[Rack]: http://rack.rubyforge.org
[Liquid]: http://localhost
[Markdown]: http://localhost
[Maruku]: http://localhost
[Nokogiri]: http://localhost
[Ruby]: http://ruby-lang.org