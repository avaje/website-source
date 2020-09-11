<h2 id="header">@Header</h2>
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

<h2 id="cookie">@Cookie</h2>
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

