
<h2 id="controllers">Controllers</h2>
<pre content="java">
@Controller
@Path("/contacts")
class ContactController {

  @Get("/{id}")
  Contact getById(long id) {
    ...
  }

  @Post
  void save(Contact contact) {
    ...
  }

  @Delete("/{id}")
  void deleteById(long id) {
    ...
  }
  ...
}
</pre>

<h3 id="controller">@Controller</h3>
<p>
  Create controllers with <code>@Path</code> and <code>@Controller</code>.
  <code>@Path("...")</code> provides the path segment that is prepended
  to any path segments defined by on methods using <code>@Get</code>,
  <code>@Post</code>, <code>@Put</code> etc.
</p>
<pre content="java">
@Controller
@Path("/customers")
class CustomerController {
  ...
}
</pre>

<p>
  Methods on the controller that are annotated with <code>@Get</code>,
  <code>@Post</code>, <code>@Put</code>, <code>@Delete</code> matching HTTP verbs.
</p>

<pre content="java">
@Controller
@Path("/contacts")
class ContactController {

  private final ContactService contactService;

  @Inject
  ContactController(ContactService contactService) {
    this.contactService = contactService;
  }

  @Get("/{id}")
  Contact getById(long id) {
    ...
  }

  @Get("/find/{type}")
  List<|Contact> findByType(String type, @QueryParam String lastName) {
    ...
  }

  @Post
  void save(Contact contact) {
    ...
  }

  ...
}
</pre>
<p>
  The controllers can have dependencies injected. The ContactController above will
  have the ContactService dependency injected by <a href="/inject">avaje-inject</a>.
</p>

<h3 id="controller-singleton">Controllers are singleton scoped by default</h3>
<p>
  By default controllers are singleton scoped. If the controllers have a dependency
  on Javalin context, Helidon ServerRequest or ServerResponse then they automatically
  become request scoped.
</p>

<h3 id="controller-request">Request scoped controllers</h3>
<p>
  If the controllers have a dependency on Javalin context, Helidon ServerRequest
  or ServerResponse then automatically they become request scoped. <em>avaje-inject</em>
  detects this and automatically makes the controller request scoped.
</p>

<h5>Example</h5>
<pre content="java">
// Automatically becomes request scoped
//  ... because Javalin Context is a dependency
@Controller
@Path("/contacts")
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
  In this next example ProductController automatically becomes request scoped
  because we have dependencies on the Helidon ServerRequest and ServerResponse.
  They are injected using field injection rather than constructor injection.
  When using field injection they can NOT be final and can NOT be private.
</p>
<pre content="java">
// Automatically becomes request scoped
//  ... because Helidon request and response are a dependency
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

