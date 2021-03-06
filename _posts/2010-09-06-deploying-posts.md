---
title: Deploying posts
layout: post
---
I'm using a slightly different setup to deploy these pages. Since I cannot ssh to my server directly from work, I have a simple cron job which periodically pulls the site from my github repository (to which I _do_ have access) and runs jekyll to update it. It means that posts won't appear immediately (it updates every quarter hour), but I figure this is good enough for the site at the moment.

I used [whenever](http://github.com/javan/whenever) to set up the schedule, which is as simple as including the file `config/schedule.rb` in the local copy of the repository. (It is possible to specify a different file; however, this is the default for whenever.)

{% highlight ruby linenos %}
# config/schedule.rb

every 15.minutes do
  command "cd /path/to/local/repo && git pull && jekyll"
end
{% endhighlight %}

Then just set up the cron job by calling

{% highlight bash %}
$ whenever -w
{% endhighlight %}

Simple, if slightly kludgy.
