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
  <section>
    <div class="col">
      <h3><a href="/config">Config</a></h3>
    </div>
    <div class="col">
      <p>
        Provides external configuration for applications. Loads <em>yaml</em> and <em>properties</em> files,
        supports dynamic configuration
      </p>
    </div>
  </section>

  <@headSection "Metrics" "/metrics/">
    APM style metrics for JVM with fast and light timing metrics with <code>@Timed</code>, gauges,
    counters with built in JVM and CGroup metrics.
  </@headSection>

  <@headSection "DInject" "https://dinject.io">
    <a href="https://dinject.io">Dependency injection</a> via code generation for server side developers. Similar feature set to
    Spring DI but uses APT code generation (like Dagger2).
  </@headSection>

  <@headSection "Javalin<br/>controllers" "https://dinject.io/docs/javalin/">
    Code generation for Javalin controllers such that we can have JAX-RS style controllers with
    <code>@Path, @Get etc</code> but extremely light and fast.
  </@headSection>

  <@headSection "Kotlin KAPT" "/kotlin-kapt">
    Maven tiles to make it easier to use Kotlin KAPT with maven.
  </@headSection>

  <@headSection "Maven tiles" "/maven-tiles">
    Useful maven tiles to drive reuse in maven build definitions.
  </@headSection>

</div>
</body>
</html>

