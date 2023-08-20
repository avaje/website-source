
<h2 id="why">Why avaje inject exists</h2>

<h3 id="why-history">Short History of DI on the JVM</h3>
<p>
  For a short history of DI on the JVM see below and refer to
  <a target="_blank" href="http://picocontainer.com/inversion-of-control-history.html">PicoContainer - inversion of control history</a>
</p>
<ul>
  <li>1998 - Avalon</li>
  <li>2003 - Spring and PicoContainer</li>
  <li>2005 - Guice</li>
  <li>2009 - JSR 330 javax.inject</li>
  <li>2013 - Dagger1</li>
  <li>2015 - Dagger2</li>
  <li>2018 - Micronaut</li>
  <li>2018 - Avaje-Inject (dinject)</li>
  <li>2019 - Quarkus</li>
</ul>
<p>
  Stefano Mazzocchi popularises the term Inversion of Control and the Apache
  <a target="_blank" href="http://picocontainer.com/inversion-of-control-history.html#avalon">Avalon</a>
  project starts.
</p>
<p>
  Spring and PicoContainer lead the initial adoption of DI. Java 5 came out with
  new language features which included annotations and generics which lead to the
  creation of Guice.
</p>
<p>
  In 2009 developers from Spring, Guice, Redhat and some others got together to
  define JSR-330 - dependency injection for Java.
</p>
<p>
  Some Guice developers went on to develop Dagger which was one of the first
  dependency injection libraries that used Java annotation processing to generate code
  for DI. This moved work that was previously done at runtime to build time, which made
  Dagger significantly faster and lighter than Guice. Dagger becomes heavily
  adopted for Android applications.
</p>
<p>
  <em>
  Using Java annotation processing to move dependency injection work from run time
  to build time is common approach by Dagger, Micronaut, avaje-inject and Quarkus.
  </em>
</p>
<p>
  Around 2018, the pain points of using Spring DI with Kubernetes and resource limited
  containers becomes more obvious. Spring heavily relies on classpath scanning, reflection and
  defining dynamic proxies. This makes it relatively slow and hungry for both CPU and
  memory resources. In cloud deployment where we pay for CPU and memory, some developers
  started looking for another approach to DI which moved more (or virtually all) of that
  work to build time using Java annotation processing [as Dagger2 had been doing in the
  Android space for some years].
</p>
<p>
  In 2018, Micronaut and <em>avaje-inject</em> (this library) are released which use
  Java annotation processing to perform most of DI at build time rather than runtime.
  <br>
  In 2019 Quarkus is released which similarly uses Java annotation processing but
  based on CDI.
</p>

<h3 id="why-comparison">Quick comparison to other DI libraries</h3>
<h5>Why not use Dagger2?</h5>
<p>
  Dagger2 is not particularly orientated for server side developers. It has no lifecycle
  support (@PostConstruct + @PreDestroy) and does not have some features that we like from
  Spring DI (@Factory + @Bean, @Primary + @Secondary).
</p>
<h5>Why not use Quarkus?</h5>
<p>
  Quarkus comes with a DI implementation based on CDI. If CDI is your thing you'd look
  at Quarkus. Even so, avaje-Inject is a much smaller library that's focused entirely on DI.
</p>
<h5>Why not Micronaut?</h5>
<p>
  Micronaut DI and <em>avaje-inject</em> are both heavily influenced by Spring DI and
  to some extent look pretty similar. avaje-inject has taken a source code generation
  approach for readability and excluded <code>@Value</code> with a preference instead to
  use a simple <a href="/config">avaje-config</a> style approach to external configuration.

  In addition, avaje determines wiring order at compile-time, hence it doesn't need to take time to figure out all the dependency relationships at runtime.
</p>
<p>
  Ultimately, <em>avaje-inject</em> is a relatively tiny library in comparison to Micronaut or Quarkus
  DI and focused on DI alone.
</p>
