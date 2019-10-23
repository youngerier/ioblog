---
title: spring-simplejdbccall
date: 2019-10-23 16:23:59
tags:
---

### 怎样理解 spring `simplejdbccall`  ? 


`https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/jdbc/core/simple/SimpleJdbcCall.html`

```
A SimpleJdbcCall is a `multi-threaded`, `reusable` object representing a call to a stored procedure or a stored function. It provides meta-data processing to simplify the code needed to access basic stored procedures/functions. All you need to provide is the name of the procedure/function and a Map containing the parameters when you execute the call. The names of the supplied parameters will be matched up with in and out parameters declared when the stored procedure was created.
```


回答

```
So, is it a Spring's bug ?

No, you're just using it incorrectly. The documentation for SimpleJdbcCall could perhaps be more explicit, but it does say:

A SimpleJdbcCall is a multi-threaded, reusable object representing a call to a stored procedure or a stored function.

In other words, each instance of SimpleJdbcCall is configured to invoke a specific stored procedure. Once configured, it shouldn't be changed.

If you need to invoke multiple stored procedures, you need to have multiple SimpleJdbcCall objects.
```

`https://stackoverflow.com/questions/6592814/simplejdbccall-can-not-call-more-than-one-procedure`