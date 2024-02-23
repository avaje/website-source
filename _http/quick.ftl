
<h2 id="quick-start">Quick Start</h2>
<p>
  1. Add <em>avaje-http-api</em> dependency.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-http-api</artifactId>
  <version>${avaje-http.version}</version>
</dependency>
</pre>

<p>
2. Add the generator module for your desired microframework as a annotation processor.
</p>
<pre content="xml">
  <!-- Annotation processors -->
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-http-{helidon/javalin}-generator</artifactId>
    <version>${avaje-http.version}</version>
    <scope>provided</scope>
    <optional>true</optional>
  </dependency>
</pre>

<#--  <h4>2a. JDK 23+ </h4>
<p>In JDK 23+, annotation processors are disabled by default, so we need to add a flag to re-enable.</p>
<pre content="xml">
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <compilerArgument>-proc:full</compilerArgument>
  </configuration>
</plugin>
</pre>  -->

<p>3. Define a Controller (These APT processors work with both Java and Kotlin.)</p>

<pre content="java">
package org.example.hello;

import io.avaje.http.api.Controller;
import io.avaje.http.api.Get;
import io.avaje.http.api.Path;
import java.util.List;

@Path("/widgets")
@Controller
public class WidgetController {
  private final HelloComponent hello;
  public WidgetController(HelloComponent hello) {
    this.hello = hello;
  }

  @Get("/{id}")
  Widget getById(int id) {
    return new Widget(id, "you got it"+ hello.hello());
  }

  @Get()
  List<Widget> getAll() {
    return List.of(new Widget(1, "Rob"), new Widget(2, "Fi"));
  }

  record Widget(int id, String name){};
}
</pre>

<h2 id="jpms">Java Module Setup</h2>
<p>
  In the <code>module-info.java</code> we need to define the avaje modules:
</p>
<h5>Example module-info</h5>
<pre content="java">
module org.example {

  requires io.avaje.http.api;
  // if using javalin specific actions like @Before/@After
  //requires static io.avaje.http.api.javalin;

}
</pre>

<h2 id="generated">Generated Adapter</h2>
<p>Given the above controller and the corresponding framework generator, the below class will be generated</p>

<details>
    <summary>Helidon 4.x</summary>

<pre content="java">
@Generated("avaje-helidon-generator")
@Singleton
public class WidgetController$Route implements HttpFeature {

  private final WidgetController controller;

  public WidgetController$Route(WidgetController controller) {
    this.controller = controller;
  }

  @Override
  public void setup(HttpRouting.Builder routing) {
    routing.get("/widgets/{id}", this::_getById);
    routing.get("/widgets", this::_getAll);
  }

  private void _getById(ServerRequest req, ServerResponse res) throws Exception {
    res.status(OK_200);
    var pathParams = req.path().pathParameters();
    var id = asInt(pathParams.first("id").get());
    var result = controller.getById(id);
    res.send(result);
  }

  private void _getAll(ServerRequest req, ServerResponse res) throws Exception {
    res.status(OK_200);
    var result = controller.getAll();
    res.send(result);
  }
}
</pre>
</details>

<details>
  <summary>Javalin</summary>

<pre content="java">
@Generated("avaje-javalin-generator")
@Singleton
public class WidgetController$Route implements Plugin {

  private final WidgetController controller;

  public WidgetController$Route(WidgetController controller) {
    this.controller = controller;
  }

  @Override
  public void apply(Javalin app) {

    app.get("/widgets/{id}", ctx -> {
      ctx.status(200);
      var id = asInt(ctx.pathParam("id"));
      var result = controller.getById(id);
      ctx.json(result);
    });

    app.get("/widgets", ctx -> {
      ctx.status(200);
      var result = controller.getAll();
      ctx.json(result);
    });
  }
}
</pre>
</details>

<details>
    <summary>Helidon 4.x (Avaje-Jsonb on classpath)</summary>

<pre content="java">
@Generated("avaje-helidon-generator")
@Singleton
public class WidgetController$Route implements HttpFeature {

  private final WidgetController controller;
  private final JsonType<WidgetController.Widget> widgetController$WidgetJsonType;
  private final JsonType<List<WidgetController.Widget>> listWidgetController$WidgetJsonType;

  public WidgetController$Route(WidgetController controller, Jsonb jsonb) {
    this.controller = controller;
    this.widgetController$WidgetJsonType = jsonb.type(WidgetController.Widget.class);
    this.listWidgetController$WidgetJsonType = jsonb.type(WidgetController.Widget.class).list();
  }

  @Override
  public void setup(HttpRouting.Builder routing) {
    routing.get("/widgets/{id}", this::_getById);
    routing.get("/widgets", this::_getAll);
  }

  private void _getById(ServerRequest req, ServerResponse res) throws Exception {
    res.status(OK_200);
    var pathParams = req.path().pathParameters();
    var id = asInt(pathParams.first("id").get());
    var result = controller.getById(id);
    res.headers().contentType(MediaTypes.APPLICATION_JSON);
    //jsonb has a special accommodation for helidon to improve performance
    widgetController$WidgetJsonType.toJson(result, JsonOutput.of(res));
  }

  private void _getAll(ServerRequest req, ServerResponse res) throws Exception {
    res.status(OK_200);
    var result = controller.getAll();
    res.headers().contentType(MediaTypes.APPLICATION_JSON);
    listWidgetController$WidgetJsonType.toJson(result, JsonOutput.of(res));
  }
}
</pre>
</details>

<details>
  <summary>Javalin (Avaje-Jsonb on classpath)</summary>

<pre content="java">
@Generated("avaje-javalin-generator")
@Singleton
public class WidgetController$Route implements Plugin {

  private final WidgetController controller;
  private final JsonType<List<Widget>> listWidgetJsonType;
  private final JsonType<Widget> widgetJsonType;

  public WidgetController$Route(WidgetController controller, Jsonb jsonB) {
    this.controller = controller;
    this.listWidgetJsonType = jsonB.type(Widget.class).list();
    this.widgetJsonType = jsonB.type(Widget.class);
  }

  @Override
  public void apply(Javalin app) {

    app.get("/widgets/{id}", ctx -> {
      ctx.status(200);
      var id = asInt(ctx.pathParam("id"));
      var result = controller.getById(id);
      widgetJsonType.toJson(result, ctx.contentType("application/json").outputStream());
    });

    app.get("/widgets", ctx -> {
      ctx.status(200);
      var result = controller.getAll();
      listWidgetJsonType.toJson(result, ctx.contentType("application/json").outputStream());
    });
  }
}
</pre>
</details>

<h2 id=usage>Usage</h2>
<p>
  The natural way to use the generated adapters is to
  get a DI library to find and wire them.
</p>
<p>
  Note that there isn't a requirement to use Avaje for dependency injection.
  Any DI library that can find and wire the generated <em>@Singleton</em> beans can
  be used.
</p>

<h4>Usage with Javalin</h4>

<p>The annotation processor will generate controller classes implementing the javalin <code>Plugin</code> interface, which means we can register them using:
</p>
<pre content="java">
 List<Plugin> routes = ...; //retrieve using a DI framework

 Javalin.create(cfg -> routes.forEach(cfg.plugins::register)).start();
</pre>

<h4>Usage with Helidon SE (4.x)</h2>
<p>
The annotation processor will generate controller classes implementing the Helidon <code>HttpFeature</code> interface, which we can register with the Helidon <code>HttpRouting</code>.
</p>

<pre content="java">
List<HttpFeature> routes = ... //retrieve using a DI framework
final var builder = HttpRouting.builder();

routes.forEach(builder::addFeature);

WebServer.builder()
         .addRouting(builder)
         .build()
         .start();
</pre>
