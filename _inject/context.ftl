<h2 id="context">Context</h2>

<h3 id="system-context">SystemContext</h3>
<p>
  <code>SystemContext</code> provides application scope to an underlying
  <em>BeanContext</em> and convenience methods to access the beans from that
  underlying BeanContext.
</p>
<h5>example</h5>
<pre content="java">
// Get a bean from the context
CoffeeMaker coffeeMaker = SystemContext.getBean(CoffeeMaker.class);
coffeeMaker.brew();
</pre>

<pre content="java">
// Get all the beans that implement an interface
List<|WebRoutes> webRoutes = SystemContext.getBeans(WebRoutes.class);

// register them with Javalin
Javalin app = Javalin.create();
app.routes(() -> webRoutes.forEach(WebRoutes::registerRoutes));
app.start(8080);
</pre>

<h4>SystemContext.context()</h4>
<p>
  We use <em>SystemContext.context()</em> to get the underlying <code>BeanContext</code>.
</p>
<h5>example</h5>
<pre content="java">
// Get the underlying context
BeanContext context = SystemContext.context();

// Get a bean from the context
CoffeeMaker coffeeMaker = context.getBean(CoffeeMaker.class);
coffeeMaker.brew();
</pre>

<h3 id="bean-context">BeanContext</h3>
<p>
  The methods on BeanContext that we use to obtain beans out of the context are:
</p>

<h5>getBean(<em>type</em>)</h5>
<p>
  Return a single bean given the type.
</p>
<pre content="java">
 StoreManager storeManager = beanContext.getBean(StoreManager.class);
 StoreManager.processOrders();
</pre>

<h5>getBean(<em>type</em>, <em>qualifier</em>)</h5>
<p>
  Return a single bean given the type and name.
</p>
<pre content="java">
 Store blueStore = beanContext.getBean(Store.class, "blue");
 blueStore.checkOrders();
</pre>

<h5>getBeans(<em>type</em>)</h5>
<p>
  Return the list of beans that implement the interface.
</p>
<pre content="java">

   // e.g. register all routes for a web framework

   List<|WebRoute> routes = beanContext.getBeans(WebRoute.class);
</pre>

<h5>getBeansWithAnnotation(<em>annotation type</em>)</h5>
<p>
  Return the list of beans that have an annotation.
</p>
<pre content="java">
// e.g. register all controllers with web a framework
// .. where Controller is an annotation on the beans

List<|Object> controllers = beanContext.getBeansWithAnnotation(Controller.class);
</pre>
<p>
The classic use case for this is registering controllers or routes to
 web frameworks like Sparkjava, Javlin, Rapidoid etc.
</p>

<h5>getBeansByPriority(<em>type</em>)</h5>
<p>
  Return the list of beans that implement the interface sorting by priority.
</p>
<pre content="java">

   // e.g. filters that should be applied in @Priority order

   List<|Filter> filters = beanContext.getBeans(Filter.class);
</pre>

<h3 id="context-builder">BeanContextBuilder</h3>
<p>
  For testing purposes we sometimes want to wire the beans but provide
  test doubles, mocks, spies for some of the dependencies. We do this
  using BeanContextBuilder.
</p>

<h4 id="withMock">BeanContextBuilder.withMock()</h4>
<p>
  We can use <code>withMock()</code> to have <a href="https://site.mockito.org/">Mockito mocks</a>
  injected in place of the normal behaviour.
</p>
<pre content="java">
@Test
public void myComponentTest() {

  try (BeanContext context = new BeanContextBuilder()
    .withMock(Pump.class)
    .withMock(Heater.class)
    .withMock(Grinder.class, grinder -> {
      // setup the mock
      when(grinder.grindBeans()).thenReturn("stub response");
    })
    .build()) {

    // Act
    CoffeeMaker coffeeMaker = context.getBean(CoffeeMaker.class);
    coffeeMaker.makeIt();

    Grinder grinder = context.getBean(Grinder.class);
    verify(grinder).grindBeans();
}
</pre>


<h4 id="withSpy">BeanContextBuilder.withSpy()</h4>
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

  try (BeanContext context = new BeanContextBuilder()
    .withSpy(Pump.class, pump -> {
      // setup the spy, only stub out pumpWater()
      doNothing().when(pump).pumpWater();
    })
    .build()) {

    // or setup here ...
    Pump pump = context.getBean(Pump.class);
    doNothing().when(pump).pumpSteam();

    // act
    CoffeeMaker coffeeMaker = context.getBean(CoffeeMaker.class);
    coffeeMaker.makeIt();

    verify(pump).pumpWater();
    verify(pump).pumpSteam();
  }

}
</pre>

<h4 id="withBeans">BeanContextBuilder.withBeans()</h4>
<p>
  We can use <code>withBeans()</code> to supply our own test doubles.
</p>
<pre content="java">
@Test
public void myComponentTest() {

  // create our test doubles to use
  Pump pump = mock(Pump.class);
  Grinder grinder = mock(Grinder.class);

  try (BeanContext context = new BeanContextBuilder()
    .withBeans(pump, grinder)
    .build()) {

    // act
    CoffeeMaker coffeeMaker = context.getBean(CoffeeMaker.class);
    coffeeMaker.makeIt();

    // assert
    assertThat(...)
  }

}
</pre>
