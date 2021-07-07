
<h2 id="dependencies">Dependencies</h2>

<h3 id="maven">Maven</h3>
<p>
  Add <em>avaje-inject</em> and <em>avaje-http-api</em> dependencies.
</p>
<pre content="xml">
<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject</artifactId>
  <version>6.1</version>
</dependency>

<dependency>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-http-api</artifactId>
  <version>1.9</version>
</dependency>
</pre>

<h4>Annotation processors</h4>
<p>
  Add the annotation processors <em>avaje-inject-generator</em> and either
  <em>avaje-http-javalin-generator</em> to target <a href="https://javalin.io">Javalin</a>
  or <em>avaje-http-helidon-generator</em> to target <a href="https://helidon.io">Helidon SE</a>.
</p>
<p>
  We typically use <em>provided</em> scope for annotation processors.
</p>
<pre content="xml">
  <!-- Annotation processors -->
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-inject-generator</artifactId>
    <version>6.1</version>
    <scope>provided</scope>
  </dependency>
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-http-javalin-generator</artifactId>
    <version>1.9</version>
    <scope>provided</scope>
  </dependency>
</pre>

<p>
  Note that if there are other annotation processors and they are specified via
  <em>maven-compiler-plugin</em> <em>annotationProcessorPaths</em>
  then we add <em>avaje-http-javalin-generator</em> there instead.
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
        <version>6.1</version>
      </path>
      <path>
        <groupId>io.avaje</groupId>
        <artifactId>avaje-http-javalin-generator</artifactId>
        <version>1.9</version>
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
<p>
  Use Gradle version 5.2 or greater which has better support for annotation processing.
</p>
<p>
  Also review the IntelliJ IDEA Gradle settings - see below.
</p>

<h3>Optional: OpenAPI plugin</h3>
<p>
  Optionally add the <code>io.dinject.openapi</code> plugin to have the openapi.json
  (swagger) to be generated into <em>src/main/resources/public</em>.
</p>

<pre content="groovy">
plugins {
  ...
  id('io.dinject.openapi') version('1.2')
}
</pre>

<h3>Dependencies</h3>
<p>
  Add <em>avaje-inject</em> and <em>avaje-http-api</em> as compile dependencies.<br/>
  Add <em>avaje-http-javalin-generator</em> and <em>javalin-generator</em> as annotation processors.
</p>

<pre content="groovy">
dependencies {
  ...
  compile('io.avaje:avaje-inject:6.1')
  compile('io.avaje:avaje-http-api:1.9')

  annotationProcessor('io.avaje:avaje-inject-generator:6.1')
  annotationProcessor('io.avaje:avaje-http-javalin-generator:1.9')
}
</pre>


<h4>Kotlin KAPT</h4>
<p>
  For use with Kotlin we change the <em>annotationProcessor</em> to be <code>kapt</code> for the Kotlin compiler.
</p>
<pre content="groovy">
dependencies {
  ...
  kapt('io.avaje:avaje-inject-generator:6.1')
  kapt('io.avaje:avaje-http-javalin-generator:1.9')
}
</pre>

<h3>OpenAPI Plugin configuration</h3>
<p>
  We can change the location of the generated openapi file by adding an <code>openapi</code> configuration
  section in build.gradle.
</p>
<pre content="groovy">
openapi {
  destination = 'other/my-api.json'
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

<h4>Settings / Build / Build tools / Gradle</h4>
<p>
  Make sure <code>Build and run</code> is delegated to Gradle.
</p>
<p>
  Optionally set <em>Run tests using</em> to <code>Gradle</code> but leaving it to IntelliJ IDEA should be ok.
</p>

<img src="/images/gradle-idea-build.png" width="100%">

