<h2 id="bean-param">@BeanParam</h2>
<p>
  Annotate a bean parameter in a controller method with <code>@BeanParam</code> to map various request values into a class.
  The properties on the bean default to being <code>query parameters</code>.
</p>
<p>
  This is typically done when there are a set of query parameters/headers/etc that are
  common across a number of endpoints.
</p>
<pre content="java">
public class CommonParams {

  private Long firstRow;
  private Long maxRows;
  private String sortBy;
  private Set<String> filter;
  //you can use ignore to mark a field as not a request parameter
  @Ignore
  private String ignored;

  //getters/setters or a constructor
}
</pre>
<p>
  Annotate the bean with <code>@BeanParam</code>
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
ApiBuilder.get("/cats/search/{type}", ctx -> {
  ctx.status(200);
  String type = ctx.pathParam("type");
  CommonParams params = new CommonParams();
  params.setFirstRow(toLong(ctx.queryParam("firstRow")));
  params.setMaxRows(toLong(ctx.queryParam("maxRows")));
  params.setSortBy(ctx.queryParam("sortBy"));
  params.setfilter(list(Objects::toString, ctx.queryParams("filter")));

  ctx.json(controller.findCats(type, params));
});

</pre>
<h4>@Form</h4>
<p>
  <em>@BeanParam</em> and <em>@Form</em> are similar except with <em>@Form</em> beans the
  properties default to form parameters instead of query parameters.
</p>

<h4>JAX-RS @BeanParam</h4>
<p>
  Our <em>@BeanParam</em> is virtually the same as JAX-RS <em>@BeanParam</em> except the properties
  default to being query parameters, whereas with JAX-RS we need to annotate each of the properties.
  We can do this because we have <em>@Form</em> and "Form beans".
</p>

<h4>BeanParam beans with @Header, @Cookie properties</h4>
<p>
  The properties on a "bean" default to being query parameters. We put <em>@Header</em> or
  <em>@Cookie</em> on properties that are instead headers or cookies.
</p>
<pre content="java">
public class CommonParams {

  private Long firstRow;
  private Long maxRows;
  private String sortBy;
  private String filter

  @Header
  private String ifModifiedSince;

  @Cookie
  private String myState;

  //getters/setters or a constructor
}
</pre>
