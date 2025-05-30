<h2 id="produces">@Produces</h2><hr/>
<p>
  Use <code>@Produces</code> to modify the response content type, default status code and generated OpenAPI definition.
  When not specified, it defaults to <code>application/json</code>.
  If not specified, the default status codes for the different http verbs are as follows:<br>
  <code>GET(200)</code> <br>
  <code>POST(201)</code> <br>
  <code>PUT(200, void methods 204)</code> <br>
  <code>PATCH(200, void methods 204)</code> <br>
  <code>DELETE(200, void methods 204)</code>

</p>
<pre content="java">
@Path("/")
@Controller
class RootController {

  private Service service;

  //send plain text
  @Get
  @Produces(MediaType.TEXT_PLAIN)
  String hello() {
    return "Hello world";
  }

  // default json
  @Get("obj")
  Example helloObj() {
    return new Example();
  }

  // we can also send our data as a byte array
  @Get("png")
  @Produces(MediaType.IMAGE_PNG)
  byte[] helloByte() {
    return service.getPNG();
  }

  // use Javalin Context for our response
  // in this case Produces is only needed for the OpenAPI generation
  @Get("ctx")
  @Produces(MediaType.IMAGE_PNG)
  void helloCTX(Context ctx) {
    service.writeResponseDirectly(ctx.outputStream());
  }

}
</pre>

<h2 id="header">@Header</h2><hr/>
<p>
  Use <code>@Header</code> for a header parameter.
  It the header parameter name is not explicitly specified then
  it is the <em>init caps snake case</em> of the parameter name.
</p>

<p>
  <code>userAgent</code> -> <code>User-Agent</code>
</p>
<p>
  <code>lastModified</code> -> <code>Last-Modified</code>
</p>

<pre content="java">
@Post
Bar postIt(Foo payload, @Header("User-Agent") String userAgent) { // explicit
  ...
}

@Post
Bar postIt(Foo payload, @Header String userAgent) { // User-Agent
  ...
}

@Get
Bazz find(@Header String lastModified) { // Last-Modified
  ...
}

</pre>

<h2 id="cookie">@Cookie</h2><hr/>
<p>
  Use <code>@Cookie</code> for a Cookie parameter.
</p>
<pre content="java">
@Post("bar/{name}")
Bar bar(String name, @Cookie("my-cookie") String myCookie) {
  ...
}

@Post("foo/{name}")
Foo foo(String name, @Cookie String myCookie) {
  ...
}
</pre>
<p>
  The generated Helidon code for the method above is:
</p>
<pre content="java">
private void _foo(ServerRequest req, ServerResponse res) {
  String name = req.path().param("name");
  String myCookie = req.headers().cookies().first("myCookie").orElse(null);
  res.send(controller.fooMe(name, myCookie));
}
</pre>

<h2 id="default">@Default</h3>
<p>
  Use <code>@Default</code> to specify a default value for a Query Parameter/Header/Cookie/Form Parameter.
</p>

<pre content="java">

@Get("/catty")
List<|Cat> findCats(@Header @Default("age") String orderBy, @Default({"1", "2"}) List<Integer> numbersOfLimbs) {
  ...
}
</pre>
