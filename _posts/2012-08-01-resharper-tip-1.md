---
layout: post
title: "ReSharper Tip #1"
---

In .NET, the default naming convention for event delegates is `Object_Action`; however, ReSharper will always give you a warning about inconsistent naming for these methods. The fix is as follows:

1. Navigate to: `ReSharper > Options > Code Editing > C# > C# Naming Style`
2. Click `Advanced settings...`
3. Add a new entry.
4. Select `Delegate` from `Affected entitites`.
5. Select all access rights.
6. Change the `Event subscriptions on fields` to `$object$_$event$` and `Event subscriptions on this` to `$event_$Handler`.

Works for me.
