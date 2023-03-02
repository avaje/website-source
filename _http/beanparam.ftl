<h2 id="bean-param">@BeanParam</h2>
<p>
  We can create a bean and annotate with <code>@BeanParam</code>.
  The properties on the bean default to being <code>query parameters</code>.
</p>
<p>
  We typically do this when we have a set of query parameters that are
  common / shared across a number of endpoints.
</p>
<pre content="java">
public class CommonParams {

  public Long firstRow;
  public Long maxRows;
  public String sortBy;
  public Set<String> filter;
}
</pre>
<p>
  We annotate the bean with <code>@BeanParam</code>
</p>
<pre content="java">
@Get("search/{type}")
List<|Cat> findCats(String type, @BeanParam CommonParams params) {

  ...
}
</pre>
<p>
  The generated Javalin code for the above is:
</p>
<pre content="java">
ApiBuilder.get("/cats/search/:type", ctx -> {
  ctx.status(200);
  String type = ctx.pathParam("type");
  CommonParams params =  new CommonParams();
  params.firstRow = toLong(ctx.queryParam("firstRow"));
  params.maxRows = toLong(ctx.queryParam("maxRows"));
  params.sortBy = ctx.queryParam("sortBy");
  params.filter = list(Objects::toString, ctx.queryParams("filter"));

  ctx.json(controller.findCats(type, params));
});

</pre>
<h4>@Form</h4>
<p>
  <em>@BeanParam</em> and <em>@Form</em> are very similar except with <em>@Form</em> beans the
  properties default to form parameters and with <em>@BeanParam</em> they default to query
  parameters.
</p>

<h4>JAX-RS @BeanParam</h4>
<p>
  Our <em>@BeanParam</em> is virtually the same as JAX-RS <em>@BeanParam</em> except the properties
  default to being query parameters where as with JAX-RS we need to annotate each of the properties.
  We can do this because we have <em>@Form</em> and "Form beans".
</p>



<h4>BeanParam beans with @Header, @Cookie properties</h4>
<p>
  The properties on a "bean" default to being query parameters. We put <em>@Header</em> or
  <em>@Cookie</em> on properties that are instead headers or cookies.
</p>
<pre content="java">
public class CommonParams {

  public Long firstRow;
  public Long maxRows;
  public String sortBy;
  public String filter

  @Header
  public String ifModifiedSince;

  @Cookie
  public String myState;
}

</pre>
