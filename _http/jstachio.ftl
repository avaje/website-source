
<h2 id="jstachio"><a href="https://jstach.io/jstachio/">JStachio</a> Integration</h2><hr/>
<p>
  JStachio is a type-safe mustache templating engine. The various generators will automatically read jstachio annotations on return types, and generate code to automatically call the engine.
</p>
<p>
  Example: <a target="_blank" href="https://github.com/dinject/examples/blob/master/javalin-maven-java-basic/src/main/java/org/example/myapp/web/HelloController.java#L30">HelloController</a>
</p>

<h4>1. Add Dependency</h4>
<a href="https://mvnrepository.com/artifact/io.jstach/jstachio"><img
        src="https://img.shields.io/maven-central/v/io.jstach/jstachio.svg?label=jstachio.version"></a>
<pre content="xml">
<dependency>
    <groupId>io.jstach</groupId>
    <artifactId>jstachio</artifactId>
    <version>${jstachio.version}</version>
</dependency>
<!-- jstachio annotation processor -->
<dependency>
    <groupId>io.jstach</groupId>
    <artifactId>jstachio-apt</artifactId>
    <version>${jstachio.version}</version>
    <scope>provided</scope>
</dependency>
</pre>

<h4>2. Create Models and Templates</h4>
<p>
  Create a model and annotate with <code>@JStache</code>.
</p>
<pre content="java">
  @JStache(path="index.mustache")
  public record IndexPage(String message){}
</pre>
<p>
  Create a template in <em>src/main/resources/index.mustache</em>.
</p>
<pre content="java">
  <p>Hello {{message}}!</p>
</pre>

<h4>3. Add model to your Controller</h4>
<pre content="java">
  @Controller("/jstache")
  public class JstacheController {

    @Get("/hello")
    public IndexPage hello() {
      return new IndexPage("Hello World!");
    }
  }
</pre>
<p>
  The generated code will include jstachio templating for the returned models. The generated code is:
</p>

<details>
    <summary>Helidon 4.x</summary>

<pre content="java">
  private void _hello(ServerRequest req, ServerResponse res) throws Exception {
    res.status(OK_200);
    var result = controller.hello();
    if (result == null) {
      res.status(NO_CONTENT_204).send();
    } else {
      var content = JStachio.render(result);
      res.headers().contentType(HTML_UTF8);
      res.send(content);
    }
  }
</pre>
</details>

<details>
  <summary>Jex</summary>

<pre content="java">
    private void _hello(Context ctx) throws Exception {
      ctx.status(200);
      var result = controller.hello();
      if (result != null) {
        var content = JStachio.render(result);
        ctx.html(content);
      }
    }
</pre>
</details>

<details>
  <summary>Javalin</summary>

<pre content="java">
ApiBuilder.get("/jstache/hello", ctx -> {
  ctx.status(200);
  var result = controller.hello();
  if (result != null) {
    var content = JStachio.render(result);
    ctx.html(content);
  }
});
</pre>

</details>
<br>
