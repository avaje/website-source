<h2 id="dependency">Dependencies</h2>

<h3 id="maven">Maven</h3>
<p>
  See the basic example at:
  <a href="https://github.com/dinject/examples/blob/master/basic-di/pom.xml">examples/basic-di/pom.xml</a>
</p>
<p>
  Add <em>dinject</em> as a dependency.
</p>
<pre content="xml">
<dependency>
  <groupId>io.dinject</groupId>
  <artifactId>dinject</artifactId>
  <version>2.2</version>
</dependency>
</pre>

<h4>Java APT - dinject-generator</h4>
<p>
  Add <em>dinject-generator</em> as a dependency with <em>provided scope</em>.
</p>

<pre content="xml">
<!-- Annotation processor -->
<dependency>
  <groupId>io.dinject</groupId>
  <artifactId>dinject-generator</artifactId>
  <version>2.2</version>
  <scope>provided</scope>
</dependency>
</pre>

<h4>Kotlin KAPT - dinject-generator</h4>
<p>
  See example at:
  <a href="https://github.com/dinject/examples/blob/master/basic-di-kotlin-maven/pom.xml">examples/basic-di-kotlin-maven/pom.xml</a>
</p>
<p>
  For use with Kotlin we register <em>dinject-generator</em> as a KAPT processor
  to the Kotlin compiler.
</p>
<p>
  The easiest way to do this is to add the <code>io.avaje.kapt</code>
  maven tiles for <em>compile</em> and <em>dinject-generator</em>
  in <em>build / plugins</em> like:
</p>
<pre content="xml">
<build>
  <plugins>

    <plugin>
      <groupId>io.repaint.maven</groupId>
      <artifactId>tiles-maven-plugin</artifactId>
      <version>2.17</version>
      <extensions>true</extensions>
      <configuration>
        <tiles>
          <!-- kotlin compile with kapt support -->
          <tile>io.avaje.kapt:compile:1.1</tile>
          <tile>io.avaje.kapt:dinject-generator:1.1</tile>

          <!-- other annotation processors ... -->
          <!-- <tile>io.avaje.kapt:javalin-generator:1.1</tile> -->
          <!-- <tile>io.avaje.kapt:querybean-generator:1.1</tile> -->

          <!-- other tiles -->
          <!-- <tile>org.avaje.tile:lib-classpath:1.1</tile> -->
          <!-- <tile>io.ebean.tile:enhancement:12.1.3</tile> -->

        </tiles>
      </configuration>
    </plugin>

  </plugins>
</build>
</pre>
<p>
  The above includes the <em>dinject-generator</em> annotation processor only. For use with <code>Javalin</code>
  we instead include the <code>io.dinject.kapt:javalin:1.12</code> tile.
</p>

<p>
  With Kotlin KAPT the source code isn't generated automatically on compile (as it is with Java)
  but instead we can specify the source code to be re-generated via:
</p>
<p>
  <em>Maven</em> - <em>Project</em> - <em>Right mouse</em> - <em>Generate Sources and update folders</em>
</p>

<p>
  <img src="/images/maven-generate-source.png" width="600px">
</p>
<p>&nbsp;</p>


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
  Add <em>dinject</em> as a compile dependency and <em>dinject-generator</em> as an annotation processor.
</p>

<pre content="groovy">
dependencies {
  ...
  compile('io.dinject:dinject:2.2')

  annotationProcessor('io.dinject:dinject-generator:2.2')
  ...
}
</pre>

<h4>Kotlin KAPT</h4>
<p>
  See example at: https://github.com/dinject/examples/blob/master/basic-di-kotlin-maven/pom.xml
</p>
<p>
  For use with Kotlin we register <em>dinject-generator</em> as a <code>kapt</code> processor
  to the Kotlin compiler rather than <em>annotationProcessor</em>.
</p>
<pre content="groovy">
dependencies {
    ...
    kapt('io.dinject:dinject-generator:2.2')
    ...
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

