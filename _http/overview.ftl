<h1 id="overview">Avaje HTTP Server & Client</h1>
<p>
Library that generates extremely fast adapter code
for Javalin and Helidon SE/Nima APIs via Annotation Processing.
</p>
<table width="100%">
  <tr>
    <th>Discord</th>
    <th>Source</th>
    <th>API Docs</th>
    <th>Issues</th>
    <th>Releases</th>
  </tr>
  <tr>
    <td><a href="https://discord.gg/Qcqf9R27BR">Discord</td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http">Github</a></td>
    <td><a target="_blank" href="https://javadoc.io/doc/io.avaje/avaje-http-api">Javadoc</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http/issues">Github</a></td>
    <td><a href="https://github.com/avaje/avaje-http/releases"><img src="https://img.shields.io/maven-central/v/io.avaje/avaje-http-api.svg?label=Maven%20Central"></a></td>
  </tr>
</table>
<p>&nbsp;</p>
<p>
 This library enables your service to be fast and light at runtime by using source code generation
  (java annotation processors) to adapt annotated rest controllers with (<code>@Path, @Get, @Post etc</code>)
  to <a target="_blank" href="https://javalin.io">Javalin</a>, <a target="_blank" href="https://helidon.io">Helidon SE</a>
  and similar web routing http servers.
</p>
<p>
  Effectively we are replacing Jersey or RestEasy with source code generation and the capabilities
  of <a target="_blank" href="https://javalin.io">Javalin</a> or <a target="_blank" href="https://helidon.io">Helidon SE</a>
  (web routing).
</p>
<p>
 The generated source code is very simple and readable, so developers can navigate to it and add break points and debug just as if we wrote it all
  manually ourselves.
</p>
<p>
  What we <b>lose</b> in doing this is automatic
  <a target="_blank" href="https://en.wikipedia.org/wiki/Content_negotiation">Content negotiation</a>. For example, if
  we need endpoints that serve response content as <i>either</i> JSON or XML content based on request headers
  then we would need to handle this ourselves.
</p>

<h4>Summary</h4>
<ul>
  <li>Provides a similar programming style to JAX-RS and Spring MVC</li>
  <li>Light weight by using code generation - no reflection, no extra overhead</li>
  <li>Automatically generates <a href="#openapi">Swagger/OpenAPI</a> documentation</li>
  <li>Allows use of underlying Javalin/Helidon request/response constructs as needed</li>
  <li>Supports request scope injection of Javalin Context, Helidon request and response</li>
  <li>Supports using <a href="#bean-validation">Bean validation</a> on request payloads</li>
  <li>Requires Fewer annotations than typical JAX-RS - avoid annotation overload</li>
</ul>

<h4>JAX-RS Annotations</h4>
<p>
  As we are using Java annotation processing our generators are exposed to more information
  than is obtained via reflection at runtime. This means we can reduce annotation verbosity
  making nicer cleaner API's.
</p>
<p>
  A design decision has been to not use JAX-RS annotations. This is because
  the JAX-RS annotations are a lot more verbose than we desire and because they are not provided
  as a nice clean separate dependency. The JAX-RS API has a lot of extra weight that we do not need.
</p>

<h2>HTTP Client</h2>
<p>
  Avaje <a href="/http-client/">http client</a> is a lightweight wrapper of JDK HttpClient
  that also supports Client API with annotation processing to generate source code that implements
  the API.
</p>
