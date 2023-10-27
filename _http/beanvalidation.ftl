
<h2 id="bean-validation">Bean validation</h2>
<p>
  We can optionally add bean validation through the validator interface. We can validate a request body and Form Bean/BeanParam
</p>
<p>
  Example: <a target="_blank" href="https://github.com/dinject/examples/blob/master/javalin-maven-java-basic/src/main/java/org/example/myapp/web/HelloController.java#L30">HelloController</a>
</p>

<h3>Add @Valid</h3>
<p>
  Add a jakarta/javax/avaje <code>@Valid</code> annotation on controllers/methods and the types that we want bean validation to
  be included for. When we do this, controller methods that take a request payload
  will then have the request bean (populated by JSON payload or form/header/query parameters)
  validated before it is passed to the controller method.
</p>
<p>
  The avaje-http <code>@Valid</code> annotation can additionally be used to set the Validation Groups to use while validating.
</p>
<p>
  For the controller method below:
</p>
<pre content="java">
@Valid
class HelloForm {
  @NotBlank
  private String name;
  private String email;
  //getters/setters/constructors
}

@Valid
class HelloBean {
  @NotBlank
  private String name;

  @Email(groups=EmailCheck.class)
  private String email;
  //getters/setters/constructors
}

@Valid
class BodyClass {
  @NotBlank
  private String somefield;
  //getters/setters/constructors
}
</pre>
<pre content="java">
@Valid
@Controller("/baz")
class BazController  {

  @Form
  @Post("/form")
  void saveForm(HelloForm helloForm) {
    ...
  }

  @io.avaje.http.api.Valid(groups={Default.class,EmailCheck.class})
  @Post("/bean")
  void saveBean(@BeanParam HelloBean helloBean) {
    ...
  }

  @Post("/body")
  void saveBody(BodyClass body) {
    ...
  }
</pre>
<p>
  The generated code now includes validation of the beans before they are
  passed to the controller method. The generated code is:
</p>

<details>
    <summary>Helidon 4.x</summary>

<pre content="java">
  private String language(ServerRequest req) {
    return req.headers().first(HEADER_ACCEPT_LANGUAGE).orElse(null);
  }

  private void _saveForm(ServerRequest req, ServerResponse res) throws Exception {
    var formParams = req.content().as(Parameters.class);
    var helloForm =  new HelloForm(
        formParams.first("name").orElse(null),
        formParams.first("email").orElse(null)
      );

    validator.validate(helloForm, language(req));
    controller.saveForm(helloForm, res);
    ...
  }

  private void _saveBean(ServerRequest req, ServerResponse res) throws Exception {
    var helloBean =  new HelloBean(
        req.query().first("name").orElse(null),
        req.query().first("email").orElse(null)
      );

    validator.validate(helloBean, language(req), Default.class, EmailCheck.class);
    controller.saveBean(helloBean, res);
  }

  private void _saveBody(ServerRequest req, ServerResponse res) throws Exception {
    res.status(CREATED_201);
    var body = bodyClassJsonType.fromJson(req.content().inputStream());
    validator.validate(body, language(req));
    controller.saveBody(body, res);
  }
</pre>
</details>

<details>
  <summary>Javalin</summary>

<pre content="java">
ApiBuilder.post("/baz/form", ctx -> {
  ctx.status(201);
  HelloForm helloForm = new HelloForm(
    ctx.formParam("name"),
    ctx.formParam("email")
  );
  var validLanguage = ctx.header("Accept-Language");
  validator.validate(helloForm, validLanguage);
  controller.saveForm(helloForm);
});

ApiBuilder.post("/baz/bean", ctx -> {
  ctx.status(201);
  HelloBean helloBean = new HelloBean(
    ctx.queryParam("name"),
    ctx.queryParam("email")
  );
  var validLanguage = ctx.header("Accept-Language");
  validator.validate(helloBean, validLanguage, Default.class, EmailCheck.class);
  controller.saveBean(helloBean);
});

ApiBuilder.post("/baz/body", ctx -> {
  ctx.status(201);
  var body = ctx.bodyAsClass(BodyClass.class);
  validator.validate(body);       // validation added here !!
  controller.saveBody(helloBean);
});
</pre>

</details>
<br>
<h4>Custom Validation</h4>
<p>
  For custom validation, you can can implement the avaje validator interface yourself and add custom logic.
</p>
<pre content="java">
import io.avaje.http.api.Validator;

@Singleton
public class BeanValidator implements Validator {

  @Override
  public void validate(Object bean, String acceptLanguage, Class<?>... groups) {
  //do validation
  // if validation fails throw something
  }
}
</pre>

<h4>Using Avaje Validation</h4>
<p>
  Add a dependency on <a target="_blank" href="https://avaje.io/validator/"><em>avaje-validator</em></a>. This will transitively
  bring in a <em>Validator</em> instance which will be used to validate beans.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-validator</artifactId>
  <version>${validator.version}</version>
</dependency>
</pre>


<h4>Using Hibernate</h4>
<p>
  Add a dependency on <em>avaje-http-hibernate-validator</em>. This will provide a hibernate <em>Validator</em> instance which will be used to validate.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-http-hibernate-validator</artifactId>
  <!-- use 2.9 for javax validation -->
  <version>3.3</version>
</dependency>
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
  record ErrorResponse(String message, List<Violation> violations){};

  @Produces(statusCode = 400)
  @ExceptionHandler
  ErrorResponse validException(ValidationException ex) {

   return new ErrorResponse(ex.getMessage(), ex.getErrors());
  }
</pre>
