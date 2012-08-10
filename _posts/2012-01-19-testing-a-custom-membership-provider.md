---
layout: post
title: Testing a Custom Membership Provider in .NET 4.0
---

OK, so this may be obvious to the seasoned .NET developers out there, but I, for one, had a hell of a time trying to find/figure out how to get the test suite to recognise the membership provider for testing purposes.

I'm sure there's plenty of refactoring/best-practices that I could (and should) include, but here's what I had to do to get it to work.

## Assumptions

1. You have a solution with two projects: MyCustomMembershipProvider and MyCustomMembershipProvider.Tests of types ASP.NET Empty Web Application and Test Application respectively.
2. You use the recommended structure for your `Web.config` file for your MembershipProvider configuration. This means that your `Web.config` file looks something like this:

{% highlight xml linenos %}
<!-- web.config -->
<configuration>
  <connectionStrings>
    <add  name="MyConnectionString"
          connectionString="Server=xxx.xxx.xx.xx" +
                           "Database=mydatabase;" + 
                           "Integrated Security=No;" +
                           "UID=username;" +
                           "PWD=password;" +
                           "Connect Timeout=30" 
          providerName="System.Data.SqlClient" />
  </connectionStrings>

  <system.web>
    <compilation debug="true" targetFramework="4.0" />

    <membership>
      <providers>
        <clear />
        <add  name="MyCustomMembershipProvider"
              type="MyCustomNameSpace.MyCustomProvider,MyCustomAssembly.MyCustomProvider"
              connectionStringName="MyConnectionString"
              enablePasswordRetrieval="true"
              enablePasswordReset="false"
              requiresQuestionAndAnswer="false"
              requiresUniqueEmail="false"
              maxInvalidPasswordAttempts="5"
              minRequiredPasswordLength="6"
              minRequiredNonAlphanumericCharacters="0"
              passwordAttemptWindow="10"
              applicationName="MyCustomMembership" />
      </providers>
    </membership>
  </system.web>
</configuration>
{% endhighlight %}

## Configuring the Test suite

Basically, what you need to do is copy the `Web.config` from your provider to an `App.config` file for your test suite. (Because it's not a web application, it uses `App.config` as its default instead of `Web.config`. Nowhere on the intertubes (except one post at StackOverflow) seemed to note that **not everyone might know this!**)

To load the provider, you can then just provide a utility method, e.g.

{% highlight csharp linenos %}
public MyCustomMembershipProvider GetProvider()
{
    return (MyCustomMembershipProvider)Membership.Providers["MyCustomMembershipProvider"];
}
{% endhighlight %}

and then just load it in your test methods via
{% highlight csharp %}
var provider = GetProvider();
{% endhighlight %}

I'm fairly certain there's a way to load that before running the test suite so that you're not calling it in *every* method; however, it baffles me how Microsoft can have such a good IDE with such crappy documentation.