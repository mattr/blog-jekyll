---
layout: post
title: this vs $(this)
---
For my own reference more than anything:

`this` is a standard javascript DOM object.

`$(this)` casts it to a jQuery object.

`this` can use standard javascript methods and attributes, e.g. `this.href`.

`$(this)` will allow you to use jQuery methods on the object.