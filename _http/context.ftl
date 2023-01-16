<h2 id="context">Context</h2>

<h3 id="javalin-context">Javalin Context</h3>
<p>
  The Javalin <code>Context</code> can be passed as a method argument or injected
  as a dependency of the controller.
</p>

<h4>Context as method argument</h4>
<pre content="java">
@Get
Response save(HelloDto dto, Context context) {
  // use Javalin context as desired
  ctx.status(202);
  ...
  return new Response();
}

@Post
void save(HelloDto dto, Context context) {
  // use Javalin context as desired
  ...
}
</pre>


<h3 id="helidon-request">Helidon request/response</h3>
<p>
  Helidon has <code>ServerRequest</code> and <code>ServerResponse</code> and these can
  be passed as a method argument of injected as a dependency of the controller.
</p>
<h4>ServerRequest/ServerResponse as method argument</h4>
<pre content="java">
@Get
Response save(HelloDto dto, ServerRequest request, ServerResponse response) {
  // use Helidon server request or response as desired
  ...
  return new Response();
}
@Post
void save(HelloDto dto, ServerRequest request, ServerResponse response) {
  // use Helidon server request or response as desired
  ...
}
</pre>


<h3>Controllers are singleton scoped by default</h3>
<p>
  By default controllers are singleton scoped. When we pass context objects like
  <em>Javalin Context</em> or <em>Helidon ServerRequest</em> as method arguments
  then the controllers remain singleton scoped.
</p>

<h3 id="request-scoped">Request scoped controllers</h3>
<p>
  We can define the Javalin context, Helidon ServerRequest
  or ServerResponse as a dependency to be injected using constructor injection
  or field injection (rather than passed as a method argument).
</p>
<p>
  <a href="/inject">avaje-inject</a> knows that these types need to be injected
  per request and automatically makes the controller request scoped.
</p>
<p>
  Request scoped means that a new instance of the controller will be instantiated
  for each request.
</p>

<h5>Example</h5>
<p>
  The following ContactController has the Javalin Context as a constructor injected
  dependency. The controller is request scoped and instantiated per request.
</p>
<pre content="java">
// Automatically becomes request scoped
//  ... because Javalin Context is a dependency
//  ... controller instantiated per request

@Controller("/contacts")
class ContactController {

  private final ContactService contactService;

  private final Context context; // Javalin Context

  // Inject Javalin context via constructor
  @Inject
  ContactController(Context context, ContactService contactService) {
    this.context = context;
    this.contactService = contactService;
  }

  @Get("/{id}")
  Contact getById(long id) {
    // use the javalin context ...
    var fooCookie = context.cookieStore("foo");
    ...
  }
}
</pre>
<h5>Example</h5>
<p>
  In this example ProductController has the Helidon ServerRequest and ServerResponse
  injected using field injection rather than constructor injection.
  Note that when using field injection they can <em>not</em> be final and can <em>not</em> be private.
</p>
<pre content="java">
// Automatically becomes request scoped
//  ... because Helidon request and response are a dependency
//  ... controller instantiated per request

@Controller
@Path("/products")
class ProductController {

  private final MyService myService;

  @Inject
  ServerRequest request; // Helidon request field injected

  @Inject
  ServerRequest response; // Helidon response field injected

  @Inject
  ProductController(MyService myService) {
    this.myService = myService;
  }

  @Get("/{id}")
  Contact getById(long id) {
    // use the helidon request ...
    var fooCookie = request.headers().cookies().first("foo");
    ...
  }
}
</pre>
