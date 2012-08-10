---
layout: post
title: Shorthand Syntax for OmniAuth in Rails
---

Another note to self: the [documentation](https://github.com/intridea/omniauth/wiki/OpenID-and-Google-Apps) for Google Apps/OpenID authentication using OmniAuth uses the Sinatra syntax of

{% highlight ruby %}
  use OmniAuth::Strategies::GoogleApps, nil, :name => 'admin', :domain => 'mydomain.com'
{% endhighlight %}

Most of the examples for Rails use the `OmniAuth::Builder` syntax, e.g.

{% highlight ruby linenos %}
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_apps, nil, :name => 'admin', :domain => 'mydomain.com'
end
{% endhighlight %}

To use the Sinatra-style syntax, replace `use` with `Rails.application.config.middleware.use`, i.e.

{% highlight ruby %}
Rails.application.config.middleware.use OmniAuth::Strategies::GoogleApps, ...
{% endhighlight %}

Shorter if you're only supporting a single provider.