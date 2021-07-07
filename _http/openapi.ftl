
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
  Example <a target="_blank" href="https://github.com/dinject/examples/blob/master/javalin-maven-java-basic/src/main/resources/public/openapi.json">javalin-maven-java-basic</a>
</p>

<h3>Javadoc</h3>
<p>
  The annotation processor reads the javadoc (and Kotlin documentation)
  for the controller methods and the description, @param and @return
  documentation is all used in the OpenAPI definition. The processor
  reads all the request and response types as OpenAPI component schema.
</p>

<h3>Validation annotations - @NotNull, @Size, @Email etc</h3>
<p>
  The javax bean validation annotations <code>@NotNull</code>, <code>@Size</code>
  and <code>@Email</code> are read as well as detecting Kotlin non-nullable
  types as required properties.
</p>
<p>
  These are used to specify required properties, min max lengths and property format.
</p>

<h3>Swagger annotations</h3>
<p>
  We can add a dependency on <code>io.swagger.core.v3:swagger-annotations:2.0.8</code>
  and add swagger annotations.
</p>

<h4>@OpenAPIDefinition</h4>
<p>
  We use <em>@OpenAPIDefinition</em> to define a title and description for the api.
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
  Put <code>@Hidden</code> on controller methods that we want to exclude
  from the OpenAPI documentation.
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
  id('io.dinject.openapi') version('1.2')
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


<h3>Maven plugin</h3>
<p>
  The maven plugin by default puts the generated openapi.json file into
  <em>src/main/resource/public</em>
</p>
<p>
  To add the plugin into <em>build / plugins</em> section:
</p>
<pre content="xml">
  <plugin>
    <groupId>io.dinject</groupId>
    <artifactId>openapi-maven-plugin</artifactId>
    <version>1.2</version>
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
    <groupId>io.dinject</groupId>
    <artifactId>openapi-maven-plugin</artifactId>
    <version>1.2</version>
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

<h3>Serving openapi.json</h3>
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

