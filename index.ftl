<html>
<head>
  <meta name="layout" content="_layout/xbase.html"/>
  <meta name="bread0" content="config" href="/config/"/>
  <#assign home = "active">
  <title>avaje jvm libraries and utilities</title>
</head>
<body>
<div class="container-col1">
  <div class="hero">
    <h1>avaje jvm libraries</h1>
  </div>


  <p>&nbsp;</p>
  <@headSection "Config" "/config">
    Provides external configuration for applications. Loads <em>yaml</em> and <em>properties</em> files,
    supports dynamic configuration
  </@headSection>

  <@headSection "Metrics" "https://avaje-metrics.github.io">
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

