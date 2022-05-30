<h2 id="default-scope">Default scope</h2>
<p>
  All beans are instantiated within a <i>scope</i>. Beans annotated with <code>@Singleton</code>
  are in the "default scope".
</p>
<pre content="java">

public class App {
  public static void main(String[] args) {

    // create all the beans in the "default scope"
    BeanScope scope = BeanScope.newBuilder().build();

    SomeObject obj = scope.get(SomeObject.class);
  }
}
</pre>
<p>
  When avaje-inject builds the "default scope" it will service load all the default scope modules
  in the classpath (i.e. wire all the "default scope" modules in the classpath together into the BeanScope).
</p>

<h2 id="scope-test-scope">Test scope</h2>
<p>
  Test scope is a special scope used for testing. It effectively provides <em>default dependencies to
  use for all tests</em>.
</p>
<p>
  Refer to <a href="#test-scope">Testing - Test Scope</a> for more details.
</p>


<h2 id="request-scope">Request scope - @Controller</h2>
<p>
  When using <a href="/http">avaje-http</a> we annotate controllers with <code>@Controller</code>.
  <em>avaje-inject</em> will detect when controllers have a request scope dependency and automatically
  make them request scoped.
</p>
<p>
  For the following example, the ContactController has a dependency on Javalin Context. This means this
  controller must use request scope.
</p>
<pre content="java">
// Automatically becomes request scoped
//  ... because Javalin Context is a dependency
//  ... controller instantiated per request

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

<h2 id="custom-scope">@Scope - custom scopes</h2>
<p>
  We can define our own custom scopes. To do this we create an annotation that is meta-annotated with <code>@Scope</code>.
  We use this custom scope annotation rather than <code>@Singleton</code>.
</p>
<p>
  Custom scopes can depend on each other and also externally defined objects, thus allowing a hierarchy of scopes to be modelled.
</p>
<p>
  Each scope results in the generation of a module class that can be added to a <code>BeanScope</code> using the <code>withModules</code> method.
  The constructor of the module class takes the externally defined dependencies if defined. This makes it easy to partially adopt Avaje Inject
  where we want some objects can be built manually by your own code and then provided to the DI scope.
</p>
<p>
  For simple cases we don't need to use custom scopes. We can just annotate classes with <code>@Singleton</code> and
  use the default scope.
</p>

<h3>Example: Custom scope</h3>

<h5>Step 1: Define the custom scope annotation</h5>
<pre content="java">
@Scope
public @interface MyCustomScope {
}
</pre>

<h5>Step 2: Use the custom scope annotation (rather than @Singleton)</h5>
<pre content="java">
@MyCustomScope
public class SomeObject {

}
</pre>

<h5>Step 3: Build BeanScope with the custom scope</h5>
<pre content="java">
public class App {
  public static void main(String[] args) {

    BeanScope scope = BeanScope.newBuilder()
      .withModules(new MyCustomScopeModule())
      .build();

    SomeObject obj = scope.get(SomeObject.class);
  }
}
</pre>

<h3>Custom scope dependencies</h3>
<p>
  Custom scopes can have dependencies on other scopes or externally supplied beans.
  We specify these dependencies using <code>@InjectModule(requires = ...)</code>.
</p>
<p>
  Note that custom scope beans are allowed to depend on any bean in the "default scope" implicitly. We do not
  need to specify a dependency for custom scoped beans to use default scoped beans.
</p>
<p>
  In the following example <code>MyCustomScope</code> has a dependency on <code>NonDIConstructedObject</code>.
</p>
<pre content="java">
@Scope
@InjectModule(requires = {NonDIConstructedObject.class})
public @interface MyCustomScope {
}

@MyCustomScope
public class SomeObject {
  public SomeObject(NonDIConstructedObject obj) { ... }
}

public class App {
  public static void main(String[] args) {

    BeanScope scope = BeanScope.newBuilder()
      // custom module with an external dependency
      .withModules(new MyCustomScopeModule(new NonDIConstructedObject()))
      .build();

    SomeObject obj = scope.get(SomeObject.class);
  }
}
</pre>

<p>
  To make one scope depend on another, just put the depended-on scope's annotation into the <code>@InjectModule(requires = { .. })</code>
  list, then call the <code>withParent</code> method of the <code>BeanScope</code> to chain them together.
</p>

<h3>Custom scope parent child hierarchy</h3>
<p>
  When using custom scopes we can create a hierarchy of scopes. When we create the BeanScope
  we can use <code>withParent()</code> to specify a parent scope.
</p>

<pre content="java">

// create a parent scope
try (final BeanScope parentScope = BeanScope.newBuilder().build()) {

  // we can use this scope
  final var coffeeMaker = parentScope.get(CoffeeMaker.class);

  // external dependency for a custom scope
  LocalExt ext = new LocalExt();

  // create a child scope
  try (BeanScope childScope = BeanScope.newBuilder()
    .withParent(parentScope) // specify the parent
    .withModules(new MyCustomModule(ext)) // the custom scope(s)
    .build()) {

    // use the child scope
    ...

  }
}
</pre>
