<h2 id="dependency">Dependencies</h2>

<h3 id="maven">Maven</h3>
<p>
  See the basic example at:
  <a href="https://github.com/dinject/examples/blob/master/basic-di/pom.xml">examples/basic-di/pom.xml</a>
</p>
<p>
  Add <em>avaje-inject</em> as a dependency.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject</artifactId>
  <version>8.1</version>
</dependency>
</pre>
<p>
  Add <em>avaje-inject-generator</em> annotation processor as a dependency with
  <em>provided scope</em>.
</p>

<pre content="xml">
<!-- Annotation processor -->
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject-generator</artifactId>
  <version>8.1</version>
  <scope>provided</scope>
</dependency>
</pre>
<p>
  Note that if there are other annotation processors and they are specified via
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
          <version>8.1</version>
      </path>
      <path>
          ... other annotation processor ...
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
</pre>


<h3 id="gradle">Gradle</h3>
<p>
  See the example at:
  <a href="https://github.com/dinject/examples/blob/master/javalin-gradle-java-basic/build.gradle">examples/javalin-gradle-java-basic/build.gradle</a>
</p>

<h4>Gradle 5.2+</h4>
<p>
  Use Gradle version 5.2 or greater which has better support for annotation processing.
</p>
<p>
  Also review the IntelliJ IDEA Gradle settings - see below.
</p>

<h4>Dependencies</h4>
<p>
  Add <em>avaje-inject</em> as a compile dependency and <em>avaje-inject-generator</em> as
  an annotation processor.
</p>

<pre content="groovy">
dependencies {
  ...
  compile('io.avaje:avaje-inject:8.1')
  annotationProcessor('io.avaje:avaje-inject-generator:8.1')
}
</pre>

<h4>Kotlin KAPT</h4>
<p>
  See example at: https://github.com/dinject/examples/blob/master/basic-di-kotlin-maven/pom.xml
</p>
<p>
  For use with Kotlin we register <em>avaje-inject-generator</em> as a <code>kapt</code> processor
  to the Kotlin compiler rather than <em>annotationProcessor</em>.
</p>
<pre content="groovy">
dependencies {
  ...
  compile('io.avaje:avaje-inject:8.1')
  kapt('io.avaje:avaje-inject-generator:8.1')
}
</pre>

<h3 id="idea">IntelliJ IDEA with Gradle</h3>
<p>
  We want to delegate the <code>build</code> to Gradle (to properly include the annotation processing)
  so check our IDEA settings.
</p>

<h4>Settings / Build / Compiler / Annotation processors</h4>
<p>
  Ensure that <code>Enable annotation processing</code> is disabled so
  that the build is delegated to Gradle (including the annotation processing):
</p>

<img src="/images/gradle-idea-disable-apt.png" width="100%">

<h5>Settings / Build / Build tools / Gradle</h5>
<p>
  Make sure <code>Build and run</code> is delegated to Gradle.
</p>
<p>
  Optionally set <em>Run tests using</em> to <code>Gradle</code> but leaving it to IntelliJ IDEA should be ok.
</p>

<img src="/images/gradle-idea-build.png" width="100%">


<h3 id="jpms">JPMS - Java module system</h3>
<p>
  <em>avaje-inject</em> supports the java module system. Add a <em>requires</em> clause and
  <em>provides</em> clause like the following:
</p>

<pre content="java">
module org.example {
  requires io.avaje.inject;
  provides io.avaje.inject.spi.Module with org.example.ExampleModule;
}
</pre>
<p>
  With JPMS we need to explicitly specify the generated <code>Module</code> in a <code>provides</code> clause.
</p>
