
<h1 id="overview">Avaje Inject</h1>
<p>
  Fast and light dependency injection library for Java and Kotlin developers.
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
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject/blob/master/LICENSE">Apache2</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject">Github</a></td>
    <td><a target="_blank" href="/apidocs/avaje-inject">Javadoc</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject/issues">Github</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject/releases">Latest 2.0</a></td>
  </tr>
</table>
<p>&nbsp;</p>

<p>
  Uses Java annotation processing generating source code for dependency injection.
  That puts the work of performing dependency injection to build time rather than
  runtime increasing the speed of application start. There is no use of reflection
  or classpath scanning.
</p>
<p>
  DI is generated source code allowing developers to see how it works and we can use
  existing IDE tools to search where code is called such as constructors and lifecycle
  methods. We can add debug breakpoints into the DI code as desired and step through
  it just like it was manually written code.
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
  In addition to the JSR-330 standard we use <a href="#factory">@Factory</a> + <a href="#bean">@Bean</a>
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
  <em>@Primary @Secondary</em>. These provide injection priority in the case of injecting
  when multiple injection candidates are available.
</p>
