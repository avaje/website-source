<html>
<head>
  <meta name="layout" content="_layout/base-home.html"/>
  <#assign home = "active">
  <title>avaje jvm libraries and utilities</title>
</head>
<body>
<div id="hero">
  <h1>avaje jvm libraries</h1>
</div>
<div class="c-narrow">

  <table class="index-toc">
    <tr>
      <th width="25%"><a href="/config">configuration</a></th>
      <td>
        <p>
          Provides external configuration for applications. Loads <em>yaml</em> and
          <em>properties</em> files, supports dynamic configuration and plugins.
        </p>
      </td>
    </tr>
    <tr>
      <th><a href="/inject">dependency injection</a></th>
      <td>
        <p>
          Cloud native and kubernetes friendly <a href="/inject">dependency injection</a>
          by generating source code using java annotation processing.
        </p>
        <p>
          Similar to Dagger2 it uses java annotation processing to perform dependency injection
          using source code generation. Unlike Dagger2 it includes lifecycle support plus support
          for component testing.
        </p>
      </td>
    </tr>
    <tr>
      <th><a href="/http-client">http client</a></th>
      <td>
        <p>
          An http client based on JDK 11+ HttpClient. Includes support for defining client API's
          similar to JAX-RS, Retrofit and Feign. Uses java annotation processing to generate
          client API implementations.
        </p>
      </td>
    </tr>
    <tr>
      <th><a href="/http">http server</a></th>
      <td>
        <p>
          Lightweight JAX-RS style http servers using <a href="https://javalin.io">Javalin</a>
          and <a href="https://helidon.io">Helidon SE</a>. Use annotations
          like <code>@Path</code>, <code>@Get</code> etc to define a rest api.
        </p>
        <p>
          Uses java annotation processing generating source code for adapting rest API's
          to servers making it much lighter and simpler than JAX-RS.
        </p>
      </td>
    </tr>
    <tr>
      <th></th>
      <td></td>
    </tr>
  </table>


</div>
</body>
</html>

