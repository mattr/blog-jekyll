---
layout: post
title: "Worst. Code. Ever."
---
**REPOSTED FROM THE [OLD SITE](http://intouchwiththeobvious.wordpress.com/2009/05/15/worst-code-ever/)**

Currently working on refactoring some legacy website code which existed before I began my current job. Ultimately, I'd like to get it over to Ruby on Rails, but in the mean time, Struts is okay (although this code epitomises everything that is wrong with Java web development).

In amongst the code I came across this gem, which I thought should be shared with the world at large.

{% highlight java linenos %}
/**
 * Get the channel for the internet POS.
 *
 * @return Channel for the user's POS if available or empty string otherwise.
 */
protected String getChannel() {
  String channel = null;
  try {
    // channel = ctx.getPOSContext().getUser().getChannel();
  } finally {
    if(channel==null) {
      channel = "";
    }
  }
  return channel;
}
{% endhighlight %}

Wow. Just... Wow.
