---
layout: post
title: 'Fudging "find" with serialized attributes'
---
Recently came across the need to do a find on a serialized attribute, but couldn't find a way to make ARel play nicely with it. For example given the structure, 

{% highlight ruby %}
# my_model.rb
class MyModel < ActiveRecord::Base
  serialize :reference_ids, Array
end

# reference.rb
class Reference < ActiveRecord::Base; end
{% endhighlight %}

using ARel directly, such as `MyModel.where(:reference_ids => [some_id])`, won't work.

Simple: write a custom `find_by` method... right?

So, the first thought is to fetch the records and detect the reference id in the array. (Note: the `reference_id` is unique across _all_ records, so it should only ever return one result.)

{% highlight ruby %}
# my_model.rb
def self.find_by_reference_id(id)
  all.detect { |a| a.reference_ids.include?(id) }
end
{% endhighlight %}

Bad, bad, bad.

As part of the development, I loaded a CSV file which relied on this method to detect the existing entries. Looking at up to 10 seconds _per find_ (once you get into meaningful record sets).

So, rewriting to use ARel with a serialized attribute ...

To do this, you need to know how the db stores the data in YAML format. It's not the best solution; but it works. I'm still searching for better.

{% highlight ruby %}
# my_model.rb
def self.find_by_reference_id(id)
  where("reference_id LIKE '%- \"?\"%'", id).first
end
{% endhighlight %}

It's not particularly elegant, and it is potentially dependent on the database choice; however, it cut down the find to ~ 30--70ms. (Most instances can probably leave off the escaped double-quotes; I have the unique problem that the integer sequence used to generate the reference id is cast to a string. Not my code.)