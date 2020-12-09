
<h2 id="bean-validation">Bean validation</h2>
<p>
  We can optionally add bean validation.
</p>
<p>
  Example: <a href="https://github.com/dinject/examples/blob/master/javalin-maven-java-basic/src/main/java/org/example/myapp/web/HelloController.java#L30">HelloController</a>
</p>

<h3>Add dependency</h3>
<p>
  Add a dependency on <em>avaje-http-hibernate-validator</em>. This will transitively
  bring in a dependency on <em>hibernate-validator</em>.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-http-hibernate-validator</artifactId>
  <version>2.0</version>
</dependency>
</pre>

<h3>Add @Valid</h3>
<p>
  Add <code>@Valid</code> annotation on controllers that we want bean validation to
  be included for. When we do this controller methods that take a request payload
  will then have the request bean (populated by JSON payload or form parameters)
  validated before it is passed to the controller method.
</p>
<p>
  For the controller method below:
</p>
<pre content="java">
@Valid
@Controller
@Path("/baz")
class BazController  {

  @Form
  @Post
  void saveForm(HelloForm helloForm) {
    ...
  }
</pre>
<p>
  The generated code now includes a validation of the helloForm before it is
  passed to the controller method. The generated code is:
</p>
<pre content="java">
ApiBuilder.post("/baz", ctx -> {
  ctx.status(201);
  HelloForm helloForm =  new HelloForm(
    ctx.formParam("name"),
    ctx.formParam("email")
  );
  helloForm.url = ctx.formParam("url");
  helloForm.startDate = toLocalDate(ctx.formParam("startDate"));

  validator.validate(helloForm);       // validation added here !!
  controller.saveForm(helloForm);
});
</pre>

<h3>ValidationException handler</h3>
<p>
  Add an exception handler for <code>ValidationException</code> like the one below.
  With bean validation we collect all the validation errors and these are included
  in the exception as a map keyed by the property path.
</p>
<p>
  <em>exception.getErrors()</em> in the handler below is returning a <code>Map&lt;String, Object&gt;</code>
</p>

<pre content="java">
app.exception(ValidationException.class, (exception, ctx) -> {

  Map<|String,Object> map = new LinkedHashMap<>();
  map.put("message", exception.getMessage());
  map.put("errors", exception.getErrors());
  ctx.json(map);
  ctx.status(exception.getStatus());
});
</pre>
