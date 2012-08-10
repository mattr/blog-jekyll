---
layout: post
title: RoR kicks OpenXava in the Butt
---
**REPOSTED FROM THE [OLD SITE](http://intouchwiththeobvious.wordpress.com/2009/05/19/ror-kicks-openxava-in-the-butt/)**

In response to Javier Paniza's article [Java Kicks Ruby on Rails in the Butt](http://java.sys-con.com/node/965189) I thought I'd look at it using _actual_ RoR, rather than the mockery of it made in the article. Javier ignores all the best practices of Ruby and RoR in his code, but (I assume) follows the best practices with his framework of choice, OpenXava.

In the console:

{% highlight bash %}
$ rails cookbook
$ cd cookbook
$ script/generate scaffold category name:string
$ script/generate scaffold recipe category:references \
    title:string description:string instructions:text date:date
$ rake db:create
$ rake db:migrate
$ rm public/index.html
$ rm public/images/rails.png
{% endhighlight %}

Okay, so the last two aren't strictly necessary, but I like to keep my app tidy.

Now, add links to switch between categories and recipes:

{% highlight ruby %}
# app/views/categories/index.html.erb
<%= link_to 'Recipes', recipes_path %>
{% endhighlight %}

{% highlight ruby %}
# app/views/recipes/index.html.erb
<%= link_to 'Categories', categories_path %>
{% endhighlight %}

Recipes already belong to categories, but we need to map the relationship in the opposite direction.

{% highlight ruby %}
# app/models/categories.rb
has_many :recipes
{% endhighlight %}

Change the text field for the category to a selection of all available categories.

{% highlight ruby %}
# app/views/recipes/new.html.erb
<%= f.select :category, Category.all.map{ |c| [c.name, c.id] } %>
{% endhighlight %}

Refactor the code for the recipes by copying out the fields from the form (between `form_for` and the `create` button) and paste into `app/views/recipes/_form.html.erb`, replacing the code in the `new` and `edit` templates with

{% highlight ruby %}
<%= render :partial => 'form', :locals => {:f => f} %>
{% endhighlight %}

Repeat for the `new` and `edit` templates in `app/views/categories`.

Then set the default home page to the recipes page.

{% highlight ruby %}
# config/routes.rb
map.root :controller => 'recipes'
{% endhighlight %}

Start the app with `script/server` and you're done.

No doubt OpenXava is a powerful framework, and I think I'll take a look at it. If nothing else, thanks, Javier, for introducing me to a new framework. For starters, it looks a hell of a lot less painful than Struts. But using best practices (which Javier no doubt uses for his Java code), I can generate a fully working app (including code refactoring and other house-keeping) in a dozen lines, with models consisting of a single line of code each. Beat that, Java.
