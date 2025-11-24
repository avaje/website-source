<h2 id="filter">@Filter</h2><hr/>
<p>
  Annotate methods with <code>@Filter</code> for HTTP filter web routes. Filters allow you to intercept a request before it hits a handler endpoint.
</p>
<h4>Jex</h4>
<p>
  Jex filters must have a <code>FilterChain</code> parameter, and optionally can add <code>Context</code>.
</p>
<pre content="java">
  @Filter
  void filter(FilterChain chain, Context ctx) {
    System.out.println("before request");
    // proceed to the next filter in the chain, or the endpoint handler if  at the end of
    // the chain
    chain.proceed();
    // do something after the request executes
    System.out.println("after request");
  }
</pre>
<h4>Helidon</h4>
<p>
  Helidon filters must have a <code>FilterChain</code> parameter, and optionally can add <code>RoutingRequest</code> and <code>RoutingResponse</code>.
</p>
<pre content="java">
  @Filter
  void filter(FilterChain chain, RoutingRequest req, RoutingResponse res) {
    System.out.println("before request");
    // proceed to the next filter in the chain, or the endpoint handler if  at the end of
    // the chain
    chain.proceed();
    // do something after the request executes
    System.out.println("after request");
  }
</pre>

<h4>Javalin</h4>
<p>
  <code>@Filter</code> correspond to Javalin <code>before</code> handlers, and can have a <code>Context</code> parameter.
</p>
<pre content="java">
  @Filter
  void filter(Context ctx) {
    System.out.println("before request");
    //calling ctx.skipRemainingHandlers() allows you to avoid further processing
  }
</pre>

<h2 id="exceptions">@ExceptionHandler</h2><hr/>
 As the name implies, this annotation marks a handler method for handling exceptions that are thrown by other handlers.

 <p>Exception handler methods may have parameters of the following types:

 <ol>
   <li>An exception argument: declared as a general Exception or as a more specific exception.
       This also serves as a mapping hint if the annotation itself does not specify the exception
       types.
   <li>Request and/or response objects (e.g. Javalin's <code>Context</code> or Helidon's
       <code>ServerRequest</code>/<code>ServerResponse</code>)
 </ol>

 <p>Handler methods may be void or return an object for serialization. When returning an object, we can combine the <code>@ExceptionHandler</code> annotation with <code>@Produces</code> for a
 specific HTTP error status and media type.
</p>

<h4>Helidon</h4>
<pre content="java">
  @ExceptionHandler
  @Produces(statusCode = 501)
  Person exceptionCtx(Exception ex, ServerRequest req, ServerResponse res) {
    return new Person();
  }

  @ExceptionHandler(IllegalStateException.class)
  void exceptionVoid(ServerResponse res) {
   //error logic
  }
</pre>

<h4>Jex/Javalin</h4>
<pre content="java">
  @ExceptionHandler
  @Produces(statusCode = 501)
  Person exceptionCtx(Exception ex, Context ctx) {
    return new Person();
  }

  @ExceptionHandler(IllegalStateException.class)
  void exceptionVoid(Context ctx) {
   //error logic
  }
</pre>

<h2 id="javalin-filter">(Javalin-only) @Before/@After</h2><hr/>
<p>
  For Javalin applications, use <code>@Before/@After</code> to mark a handler as a Javalin before/after handler.
</p>

<pre content="java">
  @Before("/path")
  void before(Context ctx) {
   //... before logic
  }

  @After("/path")
  void after(Context ctx) {
   //... after logic
  }
</pre>
