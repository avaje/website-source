
<h2 id="controllers">Controllers</h2><hr/>
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
  Create controllers <code>@Controller</code>.
  You can provide a path segment that is prepended
  to any path segments defined by on methods using <code>@Get</code>,
  <code>@Post</code>, <code>@Put</code> etc. There are three ways to prepend a path.
</p>

<h4>1. Directly put the path in the controller annotation.</h4>
<pre content="java">
@Controller("/customers")
class CustomerController {
  ...
}
</pre>
<h4>2. Use <code>@Path</code> and <code>@Controller</code></h4>
<pre content="java">
@Controller
@Path("/customers")
class CustomerController {
  ...
}
</pre>

<h4>3. Use <code>@Path</code> on an Interface and <code>@Controller</code> on an implementing class</h4>
<pre content="java">
@Path("/customers")
interface CustomerController {
  ...
}
</pre>
<pre content="java">
@Controller
class CustomerControllerImpl implements CustomerController {
  ...
}
</pre>

<p>
 Web Methods on a controller are annotated with HTTP annotations like <code>@Get</code>,
  <code>@Post</code>, <code>@Put</code>, <code>@Delete</code>.
</p>

<pre content="java">
@Controller("/contacts")
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
  The controllers can have dependencies injected. The ContactController above can easily
  have the ContactService dependency injected by <a href="/inject">avaje-inject</a>.
</p>

<h3 id="controller-singleton">Controllers are singleton scoped by default</h3>
<p>
  By default controllers are singleton scoped. If the controllers have a dependency
  on Javalin context, Helidon ServerRequest or ServerResponse then they automatically
  become <a href="#request-scoped">request scoped</a>.
</p>

