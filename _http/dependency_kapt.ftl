
<h3>Kotlin KAPT</h3>
<p>
  For use with Kotlin we register both <em>javalin-generator</em> and <em>dinject-generator</em>
  as a KAPT processors to the Kotlin compiler.
</p>
<p>
  The easiest way to do this is to add the <code>io.avaje.kapt</code>
  maven tiles for <em>compile, dinject-generator and javalin-generator</em>
  in <em>build / plugins</em> like:
</p>
<pre content="xml>
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

          <!-- annotation processor tiles for DI and Javalin controllers -->
          <tile>io.avaje.kapt:dinject-generator:1.1</tile>
          <tile>io.avaje.kapt:javalin-generator:1.1</tile>

          <!-- other annotation processor tiles -->
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
  With Kotlin KAPT the source code isn't generated automatically on compile (as it is with Java)
  but instead we can specify the source code to be re-generated via:
</p>
<p>
  <em>Maven</em> - <em>Project</em> - <em>Right mouse</em> - <em>Generate Sources and update folders</em>
</p>

<p>
  <img src="/images/maven-generate-source.png" width="600px">
</p>
<p>
  &nbsp;
</p>
