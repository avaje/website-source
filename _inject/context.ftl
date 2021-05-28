<h2 id="application-scope">ApplicationScope</h2>
<p>
  <code>ApplicationScope</code> provides access to the beans in the application scope. ApplicationScope will
  initialise with a BeanScope that contains all the singleton scoped beans. All the PostConstruct methods will
  have been executed. A shutdown hook is registered and will invoke the PreDestroy methods on shutdown.
</p>
<h5>example</h5>
<pre content="java">
// Get a bean
CoffeeMaker coffeeMaker = ApplicationScope.get(CoffeeMaker.class);
coffeeMaker.brew();
</pre>

<pre content="java">
// Get all the beans that implement an interface
List<|WebRoutes> webRoutes = ApplicationScope.list(WebRoutes.class);

// register them with Javalin
Javalin app = Javalin.create();
app.routes(() -> webRoutes.forEach(WebRoutes::registerRoutes));
app.start(8080);
</pre>

<h4>ApplicationScope.scope()</h4>
<p>
  We use <em>ApplicationScope.scope()</em> to get the underlying <code>BeanScope</code>.
  We often prefer to use the BeanScope with code to start the application as this
  allows us to have tests that run the entire application with perhaps only a few
  dependencies mocked out (component testing).

  For example, run a component test that starts the application using all real
  components except for ones that make remote calls to another service  which are
  mocked/stubbed.
</p>

<h5>example</h5>
<pre content="java">
public class App {

  public static void main(String[] args) {
      // main just uses ApplicationScope.scope()
      new App().startServer(8080, ApplicationScope.scope())
  }

  /**
   * Tests can create a BeanScope with some mocks, stubs.
   */
  void startServer(int port, BeanScope scope) {

    List<|WebRoutes> webRoutes = scope.list(WebRoutes.class);

    Javalin app = Javalin.create();
    app.routes(() -> webRoutes.forEach(WebRoutes::registerRoutes));
    app.start(port);
  }
}

</pre>

<h3 id="bean-scope">BeanScope</h3>
<p>
  The methods on BeanScope that we use to obtain beans out of the scope are:
</p>

<h5>get(<em>type</em>)</h5>
<p>
  Return a single bean given the type.
</p>
<pre content="java">
 StoreManager storeManager = beanScope.get(StoreManager.class);
 StoreManager.processOrders();
</pre>

<h5>get(<em>type</em>, <em>qualifier</em>)</h5>
<p>
  Return a single bean given the type and qualifier name.
</p>
<pre content="java">
 Store blueStore = beanScope.get(Store.class, "blue");
 blueStore.checkOrders();
</pre>

<h5>list(<em>type</em>)</h5>
<p>
  Return the list of beans that implement the interface.
</p>
<pre content="java">

   // e.g. register all routes for a web framework

   List<|WebRoute> routes = beanScope.list(WebRoute.class);
</pre>

<h5>listByAnnotation(<em>annotation type</em>)</h5>
<p>
  Return the list of beans that have an annotation.
</p>
<pre content="java">
// e.g. register all controllers with web a framework
// .. where Controller is an annotation on the beans

List<|Object> controllers = beanScope.listByAnnotation(Controller.class);
</pre>
<p>
The classic use case for this is registering controllers or routes to
 web frameworks like Sparkjava, Javalin, Rapidoid, Helidon, Undertow etc.
</p>

<h5>listByPriority(<em>type</em>)</h5>
<p>
  Return the list of beans that implement the interface sorting by priority.
</p>
<pre content="java">

   // e.g. filters that should be applied in @Priority order

   List<|Filter> filters = beanScope.listByPriority(Filter.class);
</pre>

<h4 id="context-builder">BeanScope.newBuilder()</h4>
<p>
  We can programmatically create a BeanScope with the option on providing
  some instances to use as dependencies. Most often we will do this for
  component testing providing mocks, spies etc to be wired into the beans.
</p>
<pre content="java">
  // provide dependencies to be wired
  // ... can be real things or test doubles
  MyDependency dependency = ...

  try (BeanScope scope = BeanScope.newBuilder()
    .withBean(MyDependency.class, dependency)
    ...
    .build()) {

    CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
    coffeeMaker.makeIt();
  }
</pre>
<p>
  See <a href="#testing">Testing</a> for more on wiring with test doubles.
</p>

<h3 id="request-scope">RequestScope</h3>
<p>
  Note that if we are using <a href="/http">avaje-http</a> then we will not explicitly
  use RequestScope or <a href="#scope-request">@Request</a> - we would instead use
  <a href="/http/#controller">@Controller</a>.
</p>
<p>
  <code>RequestScope</code> is created from ApplicationScope or BeanScope.
  We provide some dependencies which can be wired into <a href="#scope-request">@Request</a>
  beans. We can obtain beans from the RequestScope to perform the required processing.
</p>
<pre content="java">
  try (RequestScope requestScope = ApplicationScope.newRequestScope()
    .withBean(HttpRequest.class, request)
    .withBean(HttpResponse.class, response)
    .build()) {

    requestScope.get(MyRequestProcessor.class).doStuff();
  }
</pre>
<p>
  An approximate alternative to using RequestScope is to put all the request scoped
  dependencies into a new type and pass that as a method argument to singleton scoped
  things to process.
</p>
<pre content="java">
  MyHttpRequest request = new MyHttpRequest(request, response);

  ApplicationScope.get(MySingletonProcessor.class).process(request);
</pre>
<p>
  When we want request scoped things to be dependencies that are "injected" by avaje-inject
  rather than passed around via a method argument then we use RequestScope.
</p>
