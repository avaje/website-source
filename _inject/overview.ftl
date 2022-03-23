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
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject/releases">Latest 8.0</a></td>
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

<h3 id="size">DI Library size</h3>
<table class="basic">
  <tr>
    <td>
      <p>
        Do we care about the size of a DI library? Why is dagger and avaje-inject so much
        smaller?
      </p>
      <p>
        <em>avaje-inject</em> exists with the view that it can be <em>really</em> small and
        provide JSR-330 dependency injection using source code generation. It does not include
        AOP (which can be done separately), it does not include external configuration / properties
        (we can use avaje-config or something else). It just does DI.
      </p>
    </td>
    <td>
      <img src="/images/di-lib-size.png" alt="DI library size comparison">
    </td>
  </tr>
</table>

<h3 id="releases">Releases for javax and jakarta</h3>
<p>
  The move of JEE to the eclipse foundation meant a change in package from <code>javax</code>
  to <code>jakarta</code> for various APIs including JSR-330 dependency injection API.
</p>
<p>
  Today we have the choice of using the <code>javax.inject</code> dependency or using the new
  <code>jakarta.inject</code> dependency.
</p>

<h4>Want to use javax.inject?</h4>
<p>
  Use <a href="https://github.com/avaje/avaje-inject/releases/tag/avaje-inject-parent-7.0">version 7.0</a> of
  avaje-inject with the dependency on <code>javax.inject</code> (maintained on javax.main branch).
</p>
<h4>Want to use jakarta.inject?</h4>
<p>
  Use <a href="https://github.com/avaje/avaje-inject/releases/tag/avaje-inject-8.0">version 8.0</a> of
  avaje-inject with the dependency on <code>jakarta.inject</code> (maintained on master branch).
</p>
<p>
  Both version 8.x and 7.x require Java 11. For Java 8 support use versions 6.22 (for jakarta.inject) or 5.22 (for javax.inject).
</p>

<h3 id="jsr-330">Based on JSR-330</h3>
<p>
  avaje inject is based on <a href="http://javax-inject.github.io/javax-inject/api/index.html">JSR-330: Dependency
    Injection for Java</a> - <em>javax.inject / jakarta.inject</em> with some extensions similar to Spring DI.
</p>
<p>
  JSR-330 provides:
</p>
<ul>
  <li><code><a href="#singleton">@Singleton</a></code></li>
  <li><code><a href="#inject">@Inject</a></code></li>
  <li><code><a href="#named">@Named</a> and <a href="#named">@Qualifier</a></code></li>
  <li><code><a href="#scope">@Scope</a></code></li>
</ul>
<p>
  JSR 250 - Common Annotations for the Java provides:
</p>
<ul>
  <li><code><a href="#post-construct">@PostConstruct</a></code></li>
  <li><code><a href="#pre-destroy">@PreDestroy</a></code></li>
</ul>
<p>
  <code>@PostConstruct</code> and <code>@PreDestroy</code> are part of <em>Common Annotations API</em>.
  These where in JDK 8 but from JDK 9 onwards are part of JDK module <em>javax.annotation-api</em>.
</p>
<p>
  Noting that at this point neither Dagger2 or Guice support <code>@PostConstruct</code>
  and <code>@PreDestroy</code> lifecycle annotations.
</p>

<h3 id="extensions">Spring DI like extensions to JSR-330</h3>
<h4>@Factory + @Bean</h4>
<p>
  In addition to the JSR-330 standard we use <a href="#factory">@Factory</a> + <a href="#bean">@Bean</a>
  which work the same as Spring DI's <em>@Configuration + @Bean</em> and also Micronaut's
  <em>@Factory + @Bean</em>. This is also similar to a Guice module with <em>@Provides</em> methods.
</p>
<p>
  Teams will often use <em>@Factory@Bean</em> to provide dependencies that
  are best created programmatically. Typically these depend on external configuration,
  environment settings etc.
</p>
<p>
  Factory provides a more convenient alternative to the JSR-330
  <a href="#provider">javax.inject.Provider&lt;T&gt;</a> interface and is also more natural
  for people who familiar with Spring DI or Micronaut DI.
</p>

<h4>@Primary @Secondary</h4>
<p>
  Additionally we use <a href="#primary">@Primary</a> <a href="#secondary">@Secondary</a> annotations
  which work the same as Spring DI's <em>@Primary @Secondary</em> and also Micronaut DI's
  <em>@Primary @Secondary</em>. These provide injection priority in the case when multiple injection
  candidates are available.
</p>
