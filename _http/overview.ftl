<h1 id="overview">Avaje Http servers & client</h1>
<p>
  The goal is to be better than JAX-RS by using source code generation (via Java annotation processing).
</p>
<table width="100%">
  <tr>
    <th>License</th>
    <th>Source</th>
    <th>API Docs</th>
    <th>Issues</th>
    <th>Releases</th>
  </tr>
  <tr>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http/blob/master/LICENSE">Apache2</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http">Github</a></td>
    <td><a target="_blank" href="/apidocs/avaje-http">Javadoc</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http/issues">Github</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-http/releases">Latest 1.0</a></td>
  </tr>
</table>
<p>&nbsp;</p>
<p>
  Better in terms of being much lighter and faster at runtime by using source code generation
  (java annotation processors) to adapt annotated rest controllers with (<code>@Path, @Get, @Post etc</code>)
  to <a href="https://javalin.io">Javalin</a>, <a href="https://helidon.io">Helidon SE</a>
  and similar http servers.
</p>
<p>
  Effectively we are replacing Jersey or RestEasy with source code generation and the capabilities
  of <a href="https://javalin.io">Javalin</a> and <a href="https://helidon.io">Helidon SE</a>.
</p>
<p>
  Better also in terms of being simpler when compared with the internals of Jersey or RestEasy. It turns
  out we don't need to generate much code at all and that the generated code is very simple, readable
  and of course developers can navigate to it, add break points and debug just as if we wrote it all
  manually ourselves.
</p>
<p>
  What we <b>lose</b> in doing this is built in
  <a href="https://en.wikipedia.org/wiki/Content_negotiation">Content negotiation</a>. For example, if
  we need endpoints that serve response content as <i>either</i> JSON or XML content based on request headers
  then we would to handle this ourselves.
</p>

<h4>Summary</h4>
<ul>
  <li>Provide a similar programming style to JAX-RS and Spring MVC</li>
  <li>Light weight by using code generation - no reflection, no extra overhead</li>
  <li>Automatically generate <a href="#openapi">Swagger/OpenAPI</a> documentation</li>
  <li>Use Javalin Context, Helidon request and response as needed</li>
  <li>Support request scope injection of Javalin Context, Helidon request and response</li>
  <li>Support using <a href="#bean-validation">Bean validation</a> on request payloads</li>
  <li>Controllers should be nice and readable - avoid annotation overload</li>
</ul>

<h4>JAX-RS Annotations</h4>
<p>
  As we are using Java annotation processing we our generators are exposed to more information
  than is obtained via reflection at runtime. This means we can reduce annotation verbosity
  making nicer cleaner API's.
</p>
<p>
  For a comparison with JAX-RS goto here.
</p>
<p>
  A design decision has been to not use JAX-RS annotations at this stage. This is because
  the JAX-RS annotations are a lot more verbose than we desire and because they are not provided
  as a nice clean separate dependency. The JAX-RS API has a lot of stuff that we do not need.
</p>
