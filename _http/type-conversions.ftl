<h2 id="type-conversions">Type conversions</h2>
<p>
  There are built in type conversions for the following types:
</p>
<ul>
  <li>int, long, boolean, Integer, Long, Boolean</li>
  <li>BigDecimal, UUID, LocalDate, LocalTime, LocalDateTime</li>
  <li>Enum Types via <em>valueOf</em> (will use toUpperCase on the query parameter)</li>
</ul>
<p>
 For multivalue parameters like query parameters or headers, we can use <code>List&ltT&gt</code> or <code>Set&ltT&gt</code> where <code>T</code> is any of the previously mentioned types.
</p>
<p>
  In the following example there is a type conversion for <em>startDate</em> and <em>active</em>.
</p>

<pre content="java">
@Get("/{id}/{name}")
Hello hello(int id,
       String name,
       LocalDate startDate,
       Boolean active,
       List<Long> longs
) {
  ...
}
</pre>
<p>
  For example, the Javalin generated code below includes the type conversion
  with <code>toLocalDate()</code> and <code>toBoolean()</code>.
</p>
<pre content="java">
ApiBuilder.get("/hello/:id/:name", ctx -> {
  ctx.status(200);
  int id = asInt(ctx.pathParam("id"));
  String name = ctx.pathParam("name");
  LocalDate startDate = toLocalDate(ctx.queryParam("startDate"));
  Boolean active = toBoolean(ctx.queryParam("active"));
  List<Long> longs = list(PathTypeConversion::toLong, ctx.queryParams("longs"));
  ctx.json(controller.hello(id, name, startDate, active));
});
</pre>

<h3>Exception handlers</h3>
<p>
  If a parameter fails type conversion then <code>InvalidPathArgumentException</code> is thrown.
  This exception is typically mapped to a <code>404</code> response in the exception handler.
</p>
<p>
  Note that <code>path</code> conversions imply the value can NOT be null. All other parameter
  types are considered optional/nullable.
</p>
<p>
  <code>InvalidTypeArgumentException</code> is throw for non-path parameter conversions that
  fail such as conversions in form beans, query parameters, headers and cookies.
</p>
<p>
  We should register exception handlers for these 2 exceptions like the handlers below:
</p>

<pre content="java">
  app.exception(InvalidPathArgumentException.class, (exception, ctx) -> {

    Map<|String, String> map = new LinkedHashMap<>();
    map.put("path", ctx.path());
    map.put("message", "invalid path argument");
    ctx.json(map);
    ctx.status(404);
  });

  app.exception(InvalidTypeArgumentException.class, (exception, ctx) -> {

    Map<|String, String> map = new LinkedHashMap<>();
    map.put("path", ctx.path());
    map.put("message", "invalid type argument");
    ctx.json(map);
    ctx.status(400);
  });
</pre>
