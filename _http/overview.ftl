<h1 id="overview">
  <span class="logo">Avaje</span>&thinsp;Http&thinsp;Generator
</h1>
<p>
Library that generates adapter code
for Jex, Javalin and Helidon SE APIs via Annotation Processing.
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
    <td><a target="_blank" href="https://github.com/avaje/avaje-http">GitHub</a></td>
    <td><a target="_blank" href="https://javadoc.io/doc/io.avaje/avaje-http-api">Javadoc</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http/issues">GitHub</a></td>
    <td><a href="https://github.com/avaje/avaje-http/releases"><img src="https://img.shields.io/maven-central/v/io.avaje/avaje-http-api.svg?label=Maven%20Central"></a></td>
  </tr>
</table>
<p>&nbsp;</p>
<p>
 This library enables your service to be fast and light at runtime by using source code generation
  (java annotation processors) to adapt annotated rest controllers with (<code>@Path, @Get, @Post etc</code>)
  to <a target="_blank" href="https://avaje.io/jex/">Jex</a>, <a target="_blank" href="https://javalin.io">Javalin</a>, <a target="_blank" href="https://helidon.io">Helidon SE</a>
  and similar web routing http servers.
</p>
<p>
  Effectively we are replacing Jersey or RestEasy with source code generation and the capabilities
  of <a target="_blank" href="https://avaje.io/jex/">Jex</a>, <a target="_blank" href="https://javalin.io">Javalin</a> or <a target="_blank" href="https://helidon.io">Helidon SE</a>
  (web routing).
</p>
<p>
 The generated source code is very simple and readable, so developers can navigate to it and add breakpoints and debug as if they wrote it all
  manually ourselves.
</p>
<p>
  What is <b>lost</b> in doing this is automatic
  <a target="_blank" href="https://en.wikipedia.org/wiki/Content_negotiation">Content negotiation</a>.
  For example, endpoints that serve response content as <i>either</i> JSON or XML content based on request headers need to handle manually.
</p>

<h4>Summary</h4>
<ul>
  <li>Provides a similar programming style to JAX-RS and Spring MVC</li>
  <li>Lightweight by using code generation - no reflection, no extra overhead</li>
  <li>Automatically generates <a href="#openapi">Swagger/OpenAPI</a> documentation</li>
  <li>Allows use of underlying server request/response constructs as needed</li>
  <li>Supports request scope injection of server request and response</li>
  <li>Supports using <a href="#bean-validation">Bean validation</a> on request payloads</li>
  <li>Requires fewer annotations than typical JAX-RS - avoid annotation overload</li>
</ul>

<h2><a href="/http-client/">HTTP Client</a></h2><hr/>
<p>
  Avaje <a href="/http-client/">http client</a> is a lightweight wrapper over the JDK's own HttpClient
  that also supports client interfaces with annotation processing to generate source code that implements
  the API.
</p>
