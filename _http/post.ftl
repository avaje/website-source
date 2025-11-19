<h2 id="post">Request Body</h2><hr/>
<p>
  Avaje auto detects that a parameter is a request body if the type is a <code>POJO</code>/<code>byte[]</code>/<code>InputStream</code> and not marked with a <code>@BeanParam</code> annotation. To mark a string parameter as a body, use the <code>@BodyString</code> annotation.
</p>
<pre content="java">
@Post
void save(Customer customer) {
  ...
}
</pre>

<#if includeJavalinCode?has_content>
<h4>Generated for Javalin</h4>
<p>
  The code generated code for Javalin for save() above is:
</p>
<pre content="java">
ApiBuilder.post("/customers", ctx -> {
  ctx.status(201);
  Customer customer = ctx.bodyStreamAsClass(Customer.class);
  controller.save(customer);
});

</pre>
</#if>

<h2 id="form">@Form</h2><hr/>
<p>
  If a method has both <code>@Post</code> and <code>@Form</code> then the
  method parameters default to be form parameters.
</p>
<p>
  In the following example name, email and url all default to be form parameters.
</p>
<pre content="java">
  @Form @Post("register")
  void register(String name, String email, String url) {
    ...
  }
</pre>

<h2 id="form-param">@FormParam</h2><hr/>
<p>
  For the example above we could alternatively use explicit <code>@FormParam</code>
  on each of the form parameters rather than <code>@Form</code>. We then get:
</p>
<pre content="java">
@Post("register")
void register(@FormParam String name, @FormParam String email, @FormParam String url) {
  ...
}
</pre>
<p>
  The expectation is that we most often would use <code>@Form</code> because it reduces
  "annotation noise" and that we will very rarely use <code>@FormParam</code>. Potentially
  we only use @FormParam if the parameter name includes hyphen or similar characters that
  are not valid Java/Kotlin identifiers.
</p>

<#if includeJavalinCode?has_content>
<h4>Generated for Javalin</h4>
<p>
  The generated Javalin code for both cases above is the same:
</p>
<pre content="java">
ApiBuilder.post("/customers/register", ctx -> {
  ctx.status(201);
  String name = ctx.formParam("name");
  String email = ctx.formParam("email");
  String url = ctx.formParam("url");
  controller.register(name, email, url);
});

</pre>
</#if>

<h3>@Default</h3>
<p>
  Use <code>@Default</code> to specify a default value for form parameters.
</p>
<pre content="java">
  @Form @Post("register")
  void register(String name, String email, @Default("http://localhost") String url) {
    ...
  }
</pre>

<h2 id="form-beans">@Form "Form Beans"</h2><hr/>
<p>
  When posting a form with a lot of parameters, try defining a bean with
  properties for each of the form parameters rather than a controller method with lots of arguments.
</p>
<p>
  "Form beans" can have a constructor with arguments. They do not require a no-arg constructor.
</p>
<p>
  Using a form bean can make the code more readable and gives the option to
  use validation annotations on the "form bean" properties.
</p>
<pre content="java">
public class MyForm {

  @Size(min=2, max=100)
  private String name;
  private String email;
  //getters/setters/constructors
}
</pre>
<pre content="java">
@Form
@Post("register")
void register(MyForm myForm) {
  ...
}

</pre>
<#if includeJavalinCode?has_content>
<p>
  The generated Javalin code for the above is.
</p>
<pre content="java">
ApiBuilder.post("/contacts/register", ctx -> {
  ctx.status(201);
  MyForm myForm = new MyForm(ctx.formParam("name"), ctx.formParam("name"), ctx.formParam("email"));
  controller.register(myForm);
});
</pre>
</#if>
<p>
  "Form beans" are nice with forms with lots of properties because they de-clutter our code
  and the generated code takes care of putting the values into our bean properties so that
  we don't have to write that code.
</p>
<p>
  This use of <em>@Form</em> is very similar to JAX-RS <em>@BeanParam</em> except that the
  bean properties default be being form parameters. With JAX-RS we would put a <code>@FormParam</code>
  on every property that is a form parameter which becomes a lot of annotation noise on a large form.
</p>

<h3 id="kotlin-data">Kotlin data class</h3>
<p>
  Kotlin data classes are a natural fit for form beans.
</p>
<pre content="kotlin">
data class SaveForm(var id: Long, var name: String, var someDate: LocalDate?)


@Form @Post
fun saveIt(form: SaveForm) {

  ...
}

</pre>
<p>
  The generated code for the above controller method is:
</p>
<pre content="java">
ApiBuilder.post("/", ctx -> {
  ctx.status(201);
  SaveForm form =  new SaveForm(
    asLong(checkNull(ctx.formParam("id"), "id")),     // non-nullable type
    checkNull(ctx.formParam("name"), "name"),         // non-nullable type
    toLocalDate(ctx.formParam("someDate"))
  );

  controller.saveIt(form);
});
</pre>

<p>
  If the form bean has Kotlin non-nullable types (id and name above) then the
  generated code includes a null check when populating the bean (the <em>checkNull()</em> method).
</p>
<p>
  If there is not a value for a non-nullable Kotlin property then a validation
  error will be thrown at that point (this validation exception is thrown relatively
  early compared to using bean validation on Java form beans).
</p>



<h3>Form beans with @QueryParam, @Header, @Cookie properties</h3>
<p>
  The properties on a "form bean" default to being form parameters. We put <em>@QueryParam</em>,
  <em>@Header</em> or <em>@Cookie</em> on properties that are instead query params, headers or cookies.
</p>
<pre content="java">
public class MyForm {

  @Size(min=2, max=100)
  public String name;
  public String email;
  public String url;

  @QueryParam
  public Boolean overrideFlag;

  @Header
  public String ifModifiedSince;

  @Cookie
  public String myState;
}

</pre>
<p>
  The generated code populates <em></em> from query params, headers and cookies. The generated code is:
</p>
<pre content="java">
ApiBuilder.post("/contacts/register", ctx -> {
  ctx.status(201);
  MyForm myForm =  new MyForm();
  myForm.name = ctx.formParam("name");
  myForm.email = ctx.formParam("email");
  myForm.url = ctx.formParam("url");
  myForm.overrideFlag = toBoolean(ctx.queryParam("overrideFlag"));     // queryParam !!
  myForm.ifModifiedSince = ctx.header("If-Modified-Since");            // header !!
  myForm.myState = ctx.cookie("myState");                              // cookie !!

  controller.register(myForm);
});
</pre>
