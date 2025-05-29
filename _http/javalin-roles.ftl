
<h2 id="javalin-roles">Javalin @Roles</h2><hr/>
<p>
  An application can define a <code>@Roles</code> annotation. If the annotation matches
  the name <code>"Roles"</code> then it is deemed to define application security roles and
  generates appropriate code in the web route.
</p>
<pre content="java">
@Roles({ADMIN})
@Get
List<|Cat> getAll() {
  ...
}

</pre>
<p>
  The generated code includes the Javalin roles check.
</p>

<pre content="java">
// Generated code ...

ApiBuilder.get("/hello", ctx -> {
  ctx.json(controller.getAll());
  ctx.status(200);
}, roles(ADMIN));    // roles check added here
</pre>
