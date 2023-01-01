<h2 id="quick-start">Quick Start</h2>
<h4>1. Add <em>avaje-inject</em> as a dependency.</h4>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject</artifactId>
  <version>${avaje.inject.version}</version>
</dependency>
</pre>
<h4>2. Add <em>avaje-inject-generator</em> annotation processor as a dependency with <em>provided scope</em>.</h4>

<pre content="xml">
<!-- Annotation processor -->
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject-generator</artifactId>
  <version>${avaje.inject.version}</version>
  <scope>provided</scope>
</dependency>
</pre>
<p>
  If there are other annotation processors and they are specified via
  <em>maven-compiler-plugin</em> <em>annotationProcessorPaths</em>
  then we add <em>avaje-inject-generator</em> there instead.
</p>
<pre content="xml">
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <annotationProcessorPaths> <!-- All annotation processors specified here -->
      <path>
          <groupId>io.avaje</groupId>
          <artifactId>avaje-inject-generator</artifactId>
          <version>${avaje.inject.version}</version>
      </path>
      <path>
          ... other annotation processor ...
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
</pre>

<h4>3. Create a Class annotated with <code>@Singleton</code></h4>

<pre content="java">
@Singleton
public class Example {

  DependencyClass d;
  // dependencyClass must be annotated with singleton,
  // or else be provided from another class annotated with @Factory
  public Example(DependencyClass d) {
    this.d = d;
  }
}
</pre>

<h4>4. Retrieve the bean and use however you wish.</h4>

<pre content="java">
 BeanScope beanScope = BeanScope.builder().build()
 Example ex = beanScope.get(Example.class);
</pre>