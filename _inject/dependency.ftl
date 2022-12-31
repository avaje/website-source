<h2 id="dependency">Dependencies</h2>

<h3 id="maven">Maven</h3>
<p>
  See the <a href="#quick-start">quick start example </a>
</p>

<h3 id="gradle">Gradle</h3>
<p>
  See the example at:
  <a href="https://github.com/dinject/examples/blob/master/javalin-gradle-java-basic/build.gradle">examples/javalin-gradle-java-basic/build.gradle</a>
</p>

<h4>Gradle 5.2+</h4>
<p>
  Use Gradle version 5.2 or greater which has better support for annotation processing.
</p>

<h4>Dependencies</h4>
<p>
  Add <em>avaje-inject</em> as an implementation dependency, <em>avaje-inject-generator</em> as
  an annotation processor, and <em>avaje-inject-test</em> as a test dependency.
</p>

<pre content="groovy">
dependencies {
  ...
  implementation('io.avaje:avaje-inject:8.10')
  annotationProcessor('io.avaje:avaje-inject-generator:8.10')

  testImplementation('io.avaje:avaje-inject-test:8.10')
  testAnnotationProcessor('io.avaje:avaje-inject-generator:8.10')
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
  implementation('io.avaje:avaje-inject:8.10')
  kapt('io.avaje:avaje-inject-generator:8.10')

  testImplementation('io.avaje:avaje-inject-test:8.10')
}
</pre>


<h2 id="jpms">Java modules - module-info</h2>
<p>
  If using java modules, in the <code>module-info.java</code> we need to:
</p>
<ol>
  <li>Add a <em>requires</em> clause for <em>io.avaje.inject</em></li>
  <li>Add a <em>provides</em> clause for <em>io.avaje.inject.spi.Module</em></li>
</ol>

<h5>Example module-info</h5>
<pre content="java">
module org.example {
  requires io.avaje.inject;
  provides io.avaje.inject.spi.Module with org.example.ExampleModule;
}
</pre>
<p>
 In the example above, <code>org.example.ExampleModule</code> is generated code typically found in
  <code>target/generated-sources/annotations</code>.
</p>
