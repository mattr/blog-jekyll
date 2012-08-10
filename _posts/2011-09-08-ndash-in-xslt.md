---
title: Fixing ndash in Umbraco XSLT
layout: post
---

*Edit:* Apparently the `&amp;` character is one of the five pre-defined escape characters in XML, so you should be able to do this without having to define `<!ENTITY amp "&#38">`.

There's a weird bug in Microsoft's XSLT parser: defining `<!ENTITY ndash "&#150;">` (or `"&#x0096;"`) **should** allow you to use the `&ndash;` in your XSLT file. What happens (at least in Umbraco) is that you end up with the non-printable character '0096' (hexadecimal of 150) in that annoying little box. But there's a fix.

Instead, define the ampersand character:

{% highlight xml %}
<!ENTITY amp "&#38">
{% endhighlight %}

Then to include `&ndash;` you can use

{% highlight xml %}
<xsl:text disable-output-escaping="yes">&amp;ndash;</xsl:text>
{% endhighlight %}


which will correctly render `&ndash;` in your HTML. If you're using this a lot, you can always declare a variable with the `<xsl:text />` field as the value.

Note that this is not limited to the '&ndash;' character; you could extrapolate for any special characters in HTML which does not render correctly.