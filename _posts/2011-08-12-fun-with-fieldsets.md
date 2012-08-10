---
layout: post
title: Fun with Fieldsets
---

I came across a (frustrating) thing today while fixing up some forms on the company's web site. Say we have the code:

{% highlight css %}
  body {
    font: 13px/1.5em Verdana, Georgia, sans-serif;
  }
  fieldset {
    position: relative;
  }
  legend {
    position: absolute;
      top: -26px; left: 0;
  }
{% endhighlight %}

It will work fine in *every* browser except...

... Firefox. Yep. Not IE. Firefox.

It turns out, after a little investigation, that Firefox positions the `legend` element differently from other browsers. So the way to fix this is to add a reset for fieldsets and legends:

{% highlight css %}
  fieldset, legend {
    display: block;
    margin: 0;
    padding: 0;
  }
{% endhighlight %}

This fixes the layout to be consistent across browsers. Unfortunately it also flushes against the left-hand side, all the text. If we add padding to the fieldset, however, we discover how Firefox's quirk works: it applies the padding to the `legend` element, where other browsers do not.

So to style the form elements inside the fieldset, padding **must** be applied to children of the `fieldset` element instead. For example (assuming each of your form fields is wrapped in a `p` tag):

{% highlight css %}
  fieldset > p {
    margin-left: 10px;
  }
{% endhighlight %}

This will work for all browsers, whereas `fieldset { padding: 10px; }` will fail browser consistency in Firefox.

I actually think the Firefox devs are in the right here, though: the `legend` tag is a child of the `fieldset` tag, so any formatting should be applied to it. At least there's a simple work-around.