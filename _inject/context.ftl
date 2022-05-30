

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

<h4 id="context-builder">BeanScope.builder()</h4>
<p>
  We can programmatically create a BeanScope with the option on providing
  some instances to use as dependencies. Most often we will do this for
  component testing providing mocks, spies etc to be wired into the beans.
</p>
<pre content="java">
  // provide dependencies to be wired
  // ... can be real things or test doubles
  MyDependency dependency = ...

  try (BeanScope scope = BeanScope.builder()
    .bean(MyDependency.class, dependency)
    ...
    .build()) {

    CoffeeMaker coffeeMaker = scope.get(CoffeeMaker.class);
    coffeeMaker.makeIt();
  }
</pre>
<p>
  See <a href="#testing">Testing</a> for more on wiring with test doubles.
</p>

