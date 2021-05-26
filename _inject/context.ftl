<h2 id="application-scope">ApplicationScope</h2>
<p>
  <code>ApplicationScope</code> provides access to the beans in the application scope.
</p>
<h5>example</h5>
<pre content="java">
// Get a bean from the context
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
</p>
<h5>example</h5>
<pre content="java">
// Get the underlying context
BeanScope scope = ApplicationScope.scope();

// Get a bean from the context
CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
coffeeMaker.brew();
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
  Return a single bean given the type and name.
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
 web frameworks like Sparkjava, Javlin, Rapidoid etc.
</p>

<h5>listByPriority(<em>type</em>)</h5>
<p>
  Return the list of beans that implement the interface sorting by priority.
</p>
<pre content="java">

   // e.g. filters that should be applied in @Priority order

   List<|Filter> filters = beanScope.listByPriority(Filter.class);
</pre>

<h3 id="context-builder">BeanScope.newBuilder()</h3>
<p>
  For testing purposes we sometimes want to wire the beans but provide
  test doubles, mocks, spies for some of the dependencies. We do this
  using BeanScope builder.
</p>

<h4 id="withMock">withMock()</h4>
<p>
  We can use <code>withMock()</code> to have <a href="https://site.mockito.org/">Mockito mocks</a>
  injected in place of the normal behaviour.
</p>
<pre content="java">
@Test
public void myComponentTest() {

  try (BeanScope scope = BeanScope.newBuilder()
    .withMock(Pump.class)
    .withMock(Heater.class)
    .withMock(Grinder.class, grinder -> {
      // setup the mock
      when(grinder.grindBeans()).thenReturn("stub response");
    })
    .build()) {

    // Act
    CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
    coffeeMaker.makeIt();

    Grinder grinder = scope.get(Grinder.class);
    verify(grinder).grindBeans();
}
</pre>


<h4 id="withSpy">withSpy()</h4>
<p>
  We can use <code>withSpy()</code> to get the beans to be enhanced with <a href="https://www.baeldung.com/mockito-spy">Mockito Spy</a>.
</p>
<p>
  We typically want to do this when we want the bean to have most or all of it's behaviour and
  only stub out some of it's behaviour and track it's interactions.
</p>
<pre content="java">
@Test
public void myComponentTest() {

  try (BeanScope scope = BeanScope.newBuilder()
    .withSpy(Pump.class, pump -> {
      // setup the spy, only stub out pumpWater()
      doNothing().when(pump).pumpWater();
    })
    .build()) {

    // or setup here ...
    Pump pump = scope.get(Pump.class);
    doNothing().when(pump).pumpSteam();

    // act
    CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
    coffeeMaker.makeIt();

    verify(pump).pumpWater();
    verify(pump).pumpSteam();
  }

}
</pre>

