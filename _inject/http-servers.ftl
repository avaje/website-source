<h2 id="http">HTTP Servers</h2>
<p>
  <em>avaje-inject</em> is a lightweight DI library that is especially suited to
  building http based services using <a href="https://javalin.io">Javalin</a>
  and <a href="https://helidon.io">Helidon SE/Nima</a>.
</p>
<p>
  We can build rest controllers and target either Javalin or Helidon SE using
  as little or as much of either Javalin or Helidon as we like.
</p>

<h3 id="javalin">Javalin</h3>
<p>
  Create JAX-RS style controllers targeting <a href="https://javalin.io">Javalin</a>.
  Write controller methods that take the Javalin context as a method argument or
  have it injected as a request scoped bean.
</p>
<p>
  See <a href="/http">here</a> for more details.
</p>

<h3 id="helidon">Helidon SE</h3>
<p>
  Create JAX-RS style controllers targeting <a href="https://helidon.io">Helidon SE</a>.
  Write controller methods that take the Helidon server request and/or response as
  method arguments or have them injected into the controller as request scoped beans.
</p>
<p>
  See <a href="/http">here</a> for more details.
</p>
