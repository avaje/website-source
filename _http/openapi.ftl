
<h2 id="openapi">OpenAPI</h2>
<p>
  An OpenAPI description of the API is always generated.
</p>
<p>
  The annotation processor that generates the web route adapters
  also generates a OpenAPI (swagger) definition of all the endpoints
  that the controllers define.
</p>
<p>
  Example <a target="_blank" href="https://github.com/avaje/avaje-http/blob/b4a3ccfdea89821456044bc142353f7aa88b69e1/tests/test-javalin-jsonb/src/main/java/org/example/myapp/web/test/OpenAPIController.java">Javalin OpenAPI Controller</a>.
  <br>
  Generated <a target="_blank" href="https://github.com/avaje/avaje-http/blob/b4a3ccfdea89821456044bc142353f7aa88b69e1/tests/test-javalin-jsonb/src/test/java/io/avaje/http/generator/expectedOpenApi.json">OpenAPI Definition</a>.
</p>

<h3 id=doc>Javadoc</h3>
<p>
  The annotation processor reads the javadoc (and Kotlin documentation) of the controller methods to generate the openAPI definition.
  The javadoc summary, description, @param and @return
  documentation are used to create the OpenAPI Operation definitions.
  <br>
  The processor reads all the request and response types as OpenAPI component schema. The various annotations like <code>@Header</code>,<code>@Param</code>, and <code>@Produces</code> also modify the generated OpenAPI docs.
</p>

<pre content="java">
  /**
   * Example of Open API Get (up to the first period is the operation summary).
   *
   * basic Post (This Javadoc description is added to the operation description)
   *
   * @param b the body (the param docs are used for query/header/body description)
   * @return funny phrase (this part of the javadoc is added to the response desc)
   */
  @Post("/post")
  ResponseModel endpoint(RequestModel model) {
  ...
  }
</pre>

<p>In Addition, the generator can read the request/response class javadoc to generate openAPI component description.</p>
<pre content="java">
  class ResponseModel {
    /** field one */
    String field1;
    /** field two */
    String field1;
 }
</pre>

<h4>@Consumes</h3>
<p>
  Adding the <code>@Consumes</code> annotation to a controller method let's you control what media type should be generated for the request body in the openAPI definition. This is useful when you are dealing with non-standard request content types.
</p>

<h4>@Deprecated</h3>
<p>
  Adding Javas's <code>@Deprecated</code> annotation to a controller method marks it as deprecated in the openAPI definition.
</p>

<h3 id=response>@OpenApiResponse</h3>

<p>
  This annotation lets you specify alternate endpoint response status codes/descriptions/types. This is useful for defining error scenarios, and when using the underlying Javalin/Helidon contructs in void methods.
</p>

<pre content="java">
 @Post("/post")
 @OpenAPIResponse(responseCode = 200, description = "overrides @return javadoc description")
 @OpenAPIResponse(responseCode = 201) // Will use @return javadoc description
 @OpenAPIResponse(
      responseCode = 404,
      description = "User not found (Will not have an associated response schema)")
 @OpenAPIResponse(
      responseCode = 500,
      description = "Some other Error (Will have this error class as the response class reference)",
      type = ErrorResponse.class)
 ResponseModel endpoint() {}
</pre>

<h3 id=validation>Validation Annotations - @NotNull, @Size, @Email etc</h3>
<p>
  The javax bean validation annotations <code>@NotNull</code>, <code>@Size</code>
  and <code>@Email</code> are read as well as detecting Kotlin non-nullable
  types as required properties.
</p>
<p>
  These are used to specify required properties, min max lengths and property format.
</p>

<h3 id=swag>Swagger annotations</h3>
<p>
  Add a dependency on <code>io.swagger.core.v3:swagger-annotations:2.0.8</code>
  and add swagger annotations.
</p>

<h4>@OpenAPIDefinition</h4>
<p>
  Use <em>@OpenAPIDefinition</em> to define a title and description for the api.
  This annotation would often go on the Main method class or on package-info.java
  in the controllers package.
</p>
<p>
  Example <a target="_blank" href="https://github.com/dinject/examples/blob/master/javalin-maven-java-basic/src/main/java/org/example/myapp/Main.java#L18">@OpenAPIDefinition</a>
</p>
<pre content="java">
@OpenAPIDefinition(
  info = @Info(
    title = "Example service",
    description = "Example Javalin controllers with Java and Maven"))

</pre>
<h4>@Hidden</h4>
<p>
  Put <code>@Hidden</code> on controller methods to exclude
  from the OpenAPI documentation.
</p>

<h4>@Tags</h4>
<p>
  Put <code>@Tags</code> on controller methods to add tags to the OpenAPI Operation documentation.
</p>

<h4>@SecurityScheme and @SecurityRequirement</h4>

<p>
  Put <code>@SecurityScheme or @SecurityRequirement</code> on controller methods to add to the OpenAPI Operation documentation.
</p>

<h3>Gradle plugin</h3>
<p>
  The gradle plugin by default puts the generated openapi.json file into
  <em>src/main/resource/public</em>
</p>
<p>
  To add the plugin:
</p>
<pre content="groovy">
plugins {
  ...
  id('io.avaje.openapi') version('1.0')
}
</pre>
<p>
  To configure the openapi.json file to go to another location add a
  <em>openapi</em> configuration section in build.gradle like:
</p>
<pre content="groovy">
openapi {
  destination = 'other/my-api.json'
}
</pre>


<h3 id=plug>Maven Plugin</h3>
<p>
  The maven plugin by default puts the generated openapi.json file into
  <em>src/main/resource/public</em>
</p>
<p>
  To add the plugin into <em>build / plugins</em> section:
</p>
<pre content="xml">
  <plugin>
    <groupId>io.avaje</groupId>
    <artifactId>openapi-maven-plugin</artifactId>
    <version>1.0</version>
    <executions>
      <execution>
        <id>main</id>
        <phase>process-classes</phase>
        <goals>
          <goal>openapi</goal>
        </goals>
      </execution>
    </executions>
  </plugin>

</pre>
<p>
  To configure the openapi.json file to go to another location add a
  <em>configuration section</em> element like:
</p>
<pre content="xml">
  <plugin>
    <groupId>io.avaje</groupId>
    <artifactId>openapi-maven-plugin</artifactId>
    <version>1.0</version>
    <configuration>
      <destination>other/my-api.json</destination>
    </configuration>
    <executions>
      <execution>
        <id>main</id>
        <phase>process-classes</phase>
        <goals>
          <goal>openapi</goal>
        </goals>
      </execution>
    </executions>
  </plugin>
</pre>

<h3 id=serve>Serving openapi.json</h3>
<p>
  When the openapi.json file is in src/main/resources/public it can be served by
  using <code>addStaticFiles</code> on the JavalinConfig like:
</p>
<pre content="java">
Javalin app = Javalin.create(config -> {
  ...
  config.addStaticFiles("public", Location.CLASSPATH);
});
</pre>

