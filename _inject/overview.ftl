<h1 id="overview">Avaje Inject</h1>
<p>
  Fast and light dependency injection library for Java and Kotlin developers.
</p>
<table style="width: 100%;">
  <tr>
    <th>Discord</th>
    <th>Source</th>
    <th>API Docs</th>
    <th>Issues</th>
    <th>Releases</th>
  </tr>
  <tr>
    <td><a href="https://discord.gg/Qcqf9R27BR">Discord</td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject">Github</a></td>
    <td><a target="_blank" href="/apidocs/avaje-inject">Javadoc</a></td>
    <td><a target="_blank" href="https://github.com/avaje/avaje-inject/issues">Github</a></td>
    <td><a href="https://github.com/avaje/avaje-inject/releases"><img src="https://img.shields.io/maven-central/v/io.avaje/avaje-inject.svg?label=Maven%20Central"></a></td>
  </tr>
</table>
<p>&nbsp;</p>

<p>
  Inject leverages Java annotation processing to generate source code for efficient dependency injection.
  By shifting the responsibility of dependency injection from runtime to build time, it significantly enhances the speed of application startup.
  This approach eliminates the need for intensive reflection or classpath scanning, further optimizing performance.
</p>
<p>
  The dependency injection classes are generated source code.
  This allows us to seamlessly incorporate debug breakpoints into the DI code, enabling us to step through the code as if it were manually written.
  We can use existing IDE tools to search where code is called (e.g. Constructors and lifecycle
  methods.)
</p>
<p>
  For a <a href="#why">background on why</a> <em>avaje inject</em> exists and a
  <a href="#why-comparison">quick comparison</a> with other DI libraries such as
  Dagger2, Micronaut, Quarkus and Spring go to - <a href="#why">Why</a>.
</p>

<h3 id="size">DI Library Size</h3>
<table class="basic">
  <tr>
    <td>
      <p>
        Do we care about the size of a DI library? Why is dagger and avaje-inject so much
        smaller?
      </p>
      <p>
        <em>avaje-inject</em> exists with the view that it should be <em>really</em> small and
        provide JSR-330 dependency injection using source code generation.
      </p>
      <p>
        avaje-inject includes:
      </p>
      <ul>
        <li><a href="#jsr-330">JSR-330</a> dependency injection</li>
        <li><a href="#lifecycle">Lifecycle</a> support</li>
        <li><a href="#factory">@Factory + @Bean</a></li>
        <li><a href="#primary">@Primary + @Secondary</a></li>
        <li><a href="#conditional">Conditional Beans</a></li>
        <li><a href="#test-scope">Test scope</a> and component testing</li>
        <li><a href="#aspect">Aspect Oriented Programming</a> around method advice</li>
      </ul>
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

<h4>Want to use jakarta.inject?</h4>
<p>
  Use <a href="https://github.com/avaje/avaje-inject/releases">version 9.x</a> of
  avaje-inject with the dependency on <code>jakarta.inject</code>
</p>

<h4>Want to use javax.inject?</h4>
<p>
  Use <a href="https://github.com/avaje/avaje-inject/releases">version 9.x-javax</a> of
  avaje-inject with the dependency on <code>javax.inject</code>.
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
  These were in JDK 8, but from JDK 9 onwards are part of JDK module <em>javax.annotation-api</em>.
</p>
<p>
  Currently, neither Dagger2 or Guice support or plan to support <code>@PostConstruct</code>
  and <code>@PreDestroy</code> lifecycle annotations.
</p>

<h3 id="extensions">DI extensions to JSR-330</h3>

<h4>Component Testing</h4>
<p>
  We use <code><a href="#inject-test">@InjectTest</a></code> for <a href="#component-testing">component testing</a>, similar
  to Spring's <code>@SpringBootTest</code>.
</p>
<p>
  This is where we get avaje-inject to wire the test class using <code>@Inject, @Mock, @Spy</code>.
</p>

<h4>@Factory + @Bean</h4>
<p>
  In addition to the JSR-330 standard, we use <a href="#factory">@Factory</a> + <a href="#bean">@Bean</a>
  which have a similar function as Spring DI's <em>@Configuration + @Bean</em> and also Micronaut's
  <em>@Factory + @Bean</em>. This is also similar to a Guice module with <em>@Provides</em> methods.
</p>
<p>
  Teams will often use <em>@Factory + @Bean</em> to provide dependencies that
  are best created programmatically. Typically, these depend on external configuration,
  environment settings, etc.
</p>
<p>
  Factory provides a more convenient alternative to the JSR-330
  <a href="#provider">javax.inject.Provider&lt;T&gt;</a> interface and is also more natural
  for people who are familiar with Spring DI or Micronaut DI.
</p>

<h4>@Primary + @Secondary</h4>
<p>
  Additionally we use <a href="#primary">@Primary</a> <a href="#secondary">@Secondary</a> annotations
  which work the same as Spring DI's <em>@Primary + @Secondary</em> and also Micronaut DI's
  <em>@Primary + @Secondary</em>. These provide injection priority in the case when multiple injection
  candidates are available.
</p>
