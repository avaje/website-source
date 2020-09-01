<h2 id="overview">Overview</h2>
<p>
  <em>avaje inject</em> is a cloud native kubernetes friendly dependency injection library for
  server-side Java and Kotlin developers.
</p>
<p>
  It uses Java annotation processing generating source code for the dependency injection.
  That means there is no use of reflection or classpath scanning.
</p>
<p>
  For a <a href="#why">background on why</a> <em>avaje inject</em> exists and a
  <a href="#why-comparison">quick comparison</a> with other DI libraries such as
  Dagger2, Micronaut, Quarkus and Spring goto - <a href="#why">Why</a>.
</p>

<h3 id="jsr-330">Based on JSR-330</h3>
<p>
  avaje inject is based on <a href="http://javax-inject.github.io/javax-inject/api/index.html">JSR-330: Dependency Injection for Java</a>
  - <em>javax.inject</em> with some extensions similar to Spring DI.
</p>
<p>
  JSR-330 provides:
</p>
<ul>
  <li><code><a href="#singleton">@Singleton</a></code></li>
  <li><code><a href="#inject">@Inject</a></code></li>
  <li><code><a href="#named">@Named</a> and <a href="#named">@Qualifier</a></code></li>
  <li><code><a href="#post-construct">@PostConstruct</a></code></li>
  <li><code><a href="#pre-destroy">@PreDestroy</a></code></li>
</ul>

<h3 id="extensions">Spring DI like extensions to JSR-330</h3>
<h4>@Factory + @Bean</h4>
<p>
  In addition to the standard we use <a href="#factory">@Factory</a> + <a href="#bean">@Bean</a>
  which work the same as Spring DI's <em>@Configuration + @Bean</em> and also Micronaut's
  <em>@Factory + @Bean</em>.
</p>
<p>
  This provides a more convenient alternative to the JSR-330
  <a href="#provider">javax.inject.Provider&lt;T&gt;</a> interface and is also more natural
  for people who familiar with Spring DI or Micronaut DI.
</p>

<h4>@Primary @Secondary</h4>
<p>
  Additionally we use <a href="#primary">@Primary</a> <a href="#secondary">@Secondary</a> annotations
  which work the same as Spring DI's <em>@Primary @Secondary</em> and also Micronaut DI's
  <em>@Primary @Secondary</em>. These provide injection precedence in the case of injecting an
  implementation when multiple injection candidates are available.
</p>
