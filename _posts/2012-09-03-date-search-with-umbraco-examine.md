---
title: "Date Search with Umbraco Examine"
layout: post
---
Recently, I started using Examine as the search provider, in place of the good-ol' XSLT search package. But no matter what I did, I couldn't get it to return valid results when searching through dates.

Background
----------

* Using [uComponents](ucomponents.codeplex.com) with [Umbraco 4.8](umbraco.codeplex.com).
* Two sets of dates: start date and end date, each of which is a "Datepicker with time" editory type; and a set of dates using the multi-datepicker editor type.

Problem #1 - date format in XML
-------------------------------

Umbraco stores its dates in the format `yyyy-MM-ddTHH:mm:ss`. uComponents stores the multi-date editor values as `yyyy-MM-dd HH:mm`. Not much difference, but enough.

Problem #2 - date format in Examine
-----------------------------------

According to the documentation, Umbraco stores the dates in the format `yyyyMMddHHmmssfff` in the Examine index. Using [Luke](code.google.com/luke), however, showed the formats from the XML file being preserved.

Additionally, the dates from the multi-datepicker are stored as a comma-separated list, which means that the tokens are all incorrect. For example, if we have the list of dates

{% highlight xml %}
  2012-07-23 09:00,2012-08-25 23:00,2013-01-01 01:00
{% endhighlight %}

the tokens generated by Lucene.NET (using a standard analyzer), are:

* `2012-07-23`
* `09:00,2012-08-25`
* `23:00,2013-01-01`
* `01:00`

Clearly not right.

Damn.

Solution - delegates to the rescue
----------------------------------

As it happens, there is a delegate on each of the models and fields stored in the Lucene index.