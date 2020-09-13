<h2 id="path">@Path</h2>
<p>
  <code>@Path</code> is put on the controller class. The path is prepended to the paths
  specified by <code>@Get</code>, <code>@Post</code> etc.
</p>
<p>
  <code>@Path("/")</code> is used for the root context path.
</p>

<h5>Example</h5>
<p>
  The URI's for the RootController below would be:
</p>
<pre content="text">
  GET /
  GET /foo
</pre>
<pre content="java">
@Controller
@Path("/")
class RootController {

  @Produces(MediaType.TEXT_PLAIN)
  @Get
  String hello() {
    return "Hello world";
  }

  @Produces(MediaType.TEXT_PLAIN)
  @Get("foo")
  String helloFoo() {
    return "Hello Foo";
  }

}
</pre>

<p>
  The URI's for the CustomerController below are:
</p>
<pre content="text">
  GET /customer
  GET /customer/active
  GET /customer/active/{customerType}
</pre>
<pre content="java">
@Controller
@Path("/customer")
class CustomerController {

  @Get
  List<|Customer> findAll() {
    ...
  }

  @Get("/active")
  List<|Customer> findActive() {
    ...
  }

  @Get("/active/{customerType}")
  List<|Customer> findByType(String customerType) {
    ...
  }
}
</pre>


<h2 id="path-parameters">Path parameters</h2>
<p>
  Path parameters start with <code>{</code> and end with <code>}</code>.
</p>
<p>
  For example <code>{id}</code>, <code>{name}</code>, <code>{startDate}</code>.
</p>
<p>
  The path parameter names need to be matched by method parameter names on
  the controller. For example:
</p>
<pre content="java">
@Get("/{id}/{startDate}/{type}")
List<|Bazz> findBazz(long id, LocalDate startDate, String type) {

  // id, startDate, type all match method parameter names
  ...
}
</pre>
<p>
  This means that unlike JAX-RS we do not need a <code>@PathParam</code> annotation
  and this makes our code less verbose and nicer to read.
</p>

<p>
  Note that the JAX-RS equivalent to the above is below. The method declaration starts
  to get long and harder to read quite quickly.
</p>
<pre content="java">

// JAX-RS "annotation noise" with @PathParam

@GET
@Path("/{id}/{startDate}/{sort}")
List<|Bazz> findBazz(@PathParam("id") long id, @PathParam("startDate") LocalDate startDate, @PathParam("sort") String sort) {

  // we start getting "annotation noise" ...
  // making the code hard to read

}
</pre>


<h2 id="matrix-parameters">Matrix parameters</h2>
<p>
  Matrix parameters are optional sub-parameters that relate to a specific segment of the path.
  They are effectively an alternative to using query parameters where we have optional parameters
  that relate to a specific path segment.
</p>
<pre content="java">
// 'type' path segment has matrix parameters 'category' and 'vendor'

@Get("/products/{type;category;vendor}/available")
List<|Product> products(String type, String category, String vendor) {
  ...
}
</pre>
<pre content="text">
// example URI's

GET /products/chair/available
GET /products/chair;category=kitchen/available
GET /products/chair;category=kitchen;vendor=jfk/available
</pre>

<pre content="java">
// 'type' has matrix parameters 'category' and 'vendor'
// 'range' has matrix parameter 'style'

@Get("/products/{type;category;vendor}/{range;style}")
List<|Product> products(String type, String category, String vendor, String range, String style) {
  ...
}
</pre>
<pre content="text">
// example URI's

GET /products/chair/commercial
GET /products/chair;category=kitchen/domestic
GET /products/chair;category=kitchen/commercial;style=contemporary
GET /products/chair/commercial;style=classical
</pre>

<h4>JAX-RS @MatrixParam</h4>
<p>
  Our matrix parameters are equivalent to JAX-RS except that they relate by convention to
  method parameters of the same name and we do not need explicit <code>@MatrixParam</code>.
</p>
<p>
  The JAX-RS equivalent to the above is below. The method declaration starts
  to get long and harder to read quite quickly.
</p>
<pre content="java">

// JAX-RS "annotation noise" with @MatrixParam and @PathParam

@GET
@Path("/products/{type;category;vendor}/{range;style}")
List<|Product> products(@PathParam("type") String type, @MatrixParam("category") String category, @MatrixParam("vendor") String vendor, @PathParam("type") String range, @MatrixParam("style") String style) {

  // we start getting "annotation noise" ...
  // making the code hard to read
  ...
}
</pre>


<h2 id="query-parameters">@QueryParam</h2>
<p>
  We explicitly specify query parameters using <code>@QueryParam</code>.
</p>
<pre content="java">
// Explicit query parameter order-by

@Get("/{bornAfter}")
List<|Cat> findCats(LocalDate bornAfter, @QueryParam("order-by") String orderBy) {
  ...
}
</pre>

<h3>Implied query parameters</h3>
<p>
  Query parameters can be <em>implied</em> by not being a path parameter.
  That is, if a method parameter does not match a path parameter then it is
  implied to be a query parameter.
</p>
<p>
  The following 3 declarations are exactly the same with all 3 having
  a query parameters for <code>orderBy</code>
</p>

<pre content="java">

@Get("/{bornAfter}")
List<|Cat> findCats(LocalDate bornAfter, @QueryParam("orderBy") String orderBy) {
  ...
}

@Get("/{bornAfter}")
List<|Cat> findCats(LocalDate bornAfter, @QueryParam String orderBy) {
  ...
}

@Get("/{bornAfter}")
List<|Cat> findCats(LocalDate bornAfter, String orderBy) {  // orderBy implied as query parameter
  ...
}
</pre>

<p>
  Note that we must explicitly use <code>@QueryParam</code> when the query parameter
  is not a valid java identifier. For example, if the query parameter includes a hyphen
  then we must use <code>@QueryParam</code> explicitly.
</p>

<h4>Example</h4>
<p>
  We must use an explicit <code>@QueryParam</code> when the parameter name includes a
  hyphen like <code>order-by</code>.
</p>
<pre content="java">

// order-by is not a valid java identifier
// ... so we must use explicit @QueryParam here

@Get
List<|Cat> findCats(@QueryParam("order-by") String orderBy) {
  ...
}
</pre>



<h3>Query parameter types</h3>
<p>
  Query parameters can be one of the following types:
  <em>String, Integer, Long, Short, Float, Double, Boolean, BigDecimal, UUID, LocalDate, LocalTime or LocalDateTime</em>
</p>
<p>
  Query parameters are considered optional / nullable.
</p>

<h3>@Default</h3>
<em>
  We can use <code>@Default</code> to specify a default value for a query parameter.
</em>
<pre content="java">
// orderBy defaults to "age"

@Get("{bornAfter}")
List<|Cat> findCats(LocalDate bornAfter, @Default("age") String orderBy) {
  ...
}
</pre>



<h2 id="bean-param">@BeanParam</h2>
<p>
  When we have a lot of query parameters or if we have query parameters
  that are common to many endpoints then we look to use <code>@BeanParam</code>.
</p>
<p>
  We can create a bean and all the properties on the bean default to being
  query parameters and annotate this with <code>@BeanParam</code>.
</p>

<pre content="java">
public class CommonParams {

  public Long firstRow;
  public Long maxRows;
  public String sortBy;
  public String filter;
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
  params.filter = ctx.queryParam("filter");

  ctx.json(controller.findCats(type, params));
});

</pre>

<h4>JAX-RS @BeanParam</h4>
<p>
  Our <em>@BeanParam</em> is virtually the same as JAX-RS <em>@BeanParam</em> except the properties
  default to being query parameters where as with JAX-RS we need to annotate each of the properties.
  We can do this because we also have <a href="#form">@Form</a> and "Form beans".
</p>


<h4>BeanParam with @Header @Cookie properties</h4>
<p>
  The properties on a "bean" default to being query parameters. We put <a href="#header">@Header</a>
  or <a href="#cookie">@Cookie</a> on properties that are instead headers or cookies.
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
