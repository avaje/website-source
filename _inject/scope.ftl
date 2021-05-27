<h2 id="scope">Scope</h2>

<h3 id="scope-singleton">@Singleton</h3>
<p>
  Beans annotated with <code>@Singleton</code> will have a single instance created
  in the BeanScope. For an application we typically only have one BeanScope (ApplicationScope)
  and so we only create one instance.
</p>
<p>
  Singleton's can only depend on other singleton beans. If we add a dependency to a <code>@Request</code>
  bean then we will get a compiler error telling us we can't do that.
</p>
<pre content="java">
@Singleton
public class ProductService  {
  ...
}
</pre>

<h3 id="scope-request">@Request</h3>
<p>
  Beans annotated with <code>@Request</code> have request scope. This means that:
</p>
<ul>
  <li>They can only be accessed via RequestScope</li>
  <li>They can depend on things supplied to the RequestScope</li>
  <li>They can depend on other @Request beans</li>
  <li>They can depend on @Singleton beans</li>
</ul>

<pre content="java">
@Request
public class ProductController {

  /**
   * Can depend on:
   * - Things provided to the request scope
   * - @Request scope beans
   * - @Singleton beans
   */
  public ProductController(HttpRequest request, HttpResponse response, ProductService productService) {
    ...
  }

}
</pre>

<p>
  We can only use request scoped beans via <em>RequestScope</em>. One instance is created once per
  <code>RequestScope</code> on demand - an instance is only created if it is used for that request.
</p>

<pre content="java">
    try (RequestScope requestScope = ApplicationScope.newRequestScope()
      .withBean(HttpRequest.class, request)
      .withBean(HttpResponse.class, response)
      .build()) {

      ProductController productController = requestScope.get(ProductController.class);
      productController.doStuff();
    }
</pre>

<h3 id="controller">@Controller (avaje-http)</h3>
<p>
  If we are using <a href="/http">avaje-http</a> then we use
  <a href="/http/#controller">@Controller</a> rather than <code>@Singleton</code>
  or <code>@Request</code>. When we do this avaje  inject will detect if the controller
  needs to be request scoped (by looking at it's dependencies at compile time) and
  automatically handle that.
</p>
<p>
  In general we would only expect to use <code>@Request</code> and <code>RequestScope</code>
  when we are not using <em>avaje-http</em>.
</p>
