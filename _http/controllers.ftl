
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
  become <a href="#request-scoped">request scoped</a>.
</p>

