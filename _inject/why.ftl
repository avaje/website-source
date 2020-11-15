
<h2 id="why">Why avaje inject exists</h2>

<h3 id="why-history">Short History of DI on the JVM</h3>
<p>
  For a very short history of DI on the JVM:
</p>
<ul>
  <li>2003 - spring and picocontainer</li>
  <li>2005 - guice</li>
  <li>2009 - JSR 330 javax.inject</li>
  <li>2013 - dagger1</li>
  <li>2015 - dagger2</li>
  <li>2018 - micronaut</li>
  <li>2018 - avaje-inject (dinject)</li>
  <li>2019 - quarkus</li>
</ul>
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
  Some Guice developers went on to develop Dagger which I believe was the first
  dependency injection library that used Java annotation processing to generate code
  for DI. This moves work that was previously done at runtime to build time and made
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
  Around 2018 the pain points of using Spring DI with Kubernetes and resource limited
  containers becomes more obvious. The way Spring DI works means that at startup time it
  performs a lot of work that includes classpath scanning, heavy use of reflection and
  defining dynamic proxies.  This makes it relatively slow and hungry for both CPU and
  memory resources. With cloud deployment where we pay for CPU and memory some developers
  start looking for another approach to DI which puts more (or virtually all) of that
  work to build time using Java annotation processing [as Dagger2 had been doing in the
  Android space for some years].
</p>
<p>
  In 2018 Micronaut and <em>avaje-inject</em> (this library) are released which use
  Java annotation processing to perform most of DI at build time rather than runtime.
  In 2019 Quarkus is released which similarly uses Java annotation processing but is
  based on CDI.
</p>

<h3 id="why-comparison">Quick comparison to other DI libraries</h3>
<h5>Why not use Dagger2?</h5>
<p>
  Dagger2 is not particularly orientated for server side developers with no lifecycle
  support (@PostConstruct/@PreDestroy) and does not have some features that we like from
  Spring DI (@Factory/@Bean + @Primary/@Secondary).
</p>
<h5>Why not use Quarkus?</h5>
<p>
  Quarkus comes with a DI implementation based on CDI. If CDI is your thing you'd look
  at Quarkus.
</p>
<h5>Why not Micronaut?</h5>
<p>
  Micronaut DI and <em>avaje-inject</em> are both heavily influenced by Spring ID and
  look very similar in feature set.
</p>
<p>
  Micronaut DI was relatively strongly linked to the rest of the Micronaut framework
  where as <em>avaje-inject</em> is relatively small in comparison and focused on DI alone.
  Micronaut generates bytecode where as <em>avaje-inject</em> generates source code
  making the functionality of DI fully transparent to developers.
</p>
