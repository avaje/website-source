<html>

<head>
  <meta name="layout" content="_layout/base-home.html" />
  <#assign home="active">
    <title>Avaje jvm libraries and utilities</title>
</head>

<body>
  <div id="hero">
    <h1>Avaje JVM Libraries</h1>
  </div>
  <div class="c-narrow">
    <table class="index-toc">
      <tr>
        <th width="25%"><a href="/config">Configuration</a></th>
        <td>
          <p>
            Provides external configuration for applications. Loads <em>yaml</em> and
            <em>properties</em> files, supports dynamic configuration and plugins.
          </p>
        </td>
      </tr>
      <tr>
        <th><a href="/inject">Dependency Injection</a></th>
        <td>
          <p>
            Cloud Native/Kubernetes friendly <a href="/inject">dependency injection</a>
            by generating source code using java annotation processing.
          </p>
          <p>
            Similar to Dagger2, it uses annotation processing to perform dependency injection
            using source code generation. Unlike Dagger2, it includes lifecycle support and support
            for component testing.
          </p>
        </td>
      </tr>
      <tr>
        <th><a href="/jsonb">Jsonb</a></th>
        <td>
          <p>
            Flexible and reflection-free JSON library that uses Java annotation processing to generate JSON adapters. One of the <a href="https://github.com/fabienrenaud/java-json-benchmark#users-model">Top 3 fastest</a> Java Json libraries
          </p>
        </td>
      </tr>
      <tr>
        <th><a href="/validator">Validator</a></th>
        <td>
          <p>
           Reflection-free Pojo validation library that uses annotation processing to generate validation adapters to run constraints.
          </p>
        </td>
      </tr>
      <tr>
        <th><a href="/http-client">HTTP Client</a></th>
        <td>
          <p>
            A wrapper on JDK 11's HttpClient. Includes support for defining client API's
            similar to JAX-RS, Retrofit and Feign. Uses java annotation processing to generate
            client API implementations.
          </p>
        </td>
      </tr>
      <tr>
        <th><a href="/http">HTTP Server</a></th>
        <td>
          <p>
            Lightweight JAX-RS style http servers using <a href="https://javalin.io">Javalin</a>
            or <a href="https://helidon.io">Helidon SE</a>. Use annotations
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
