<html>
<head>
  <title>avaje kotlin kapt maven tiles</title>
  <meta name="layout" content="_layout/base-metrics.html"/>
  <meta name="bread2" content="start" href="/metrics/start"/>
</head>
<body>
<div class="grid">
<article>
  <h2 id="dependency">Add dependency</h2>
  <p>
    Add the following dependency to the project.
  </p>
  <pre content="xml">
    <dependency>
      <groupId>io.avaje.metrics</groupId>
      <artifactId>metrics</artifactId>
      <version>8.3</version>
    </dependency>
  </pre>

  <h2 id="maven">Maven tile</h2>
  <p>
    When using maven add the following maven tile into the <code>build / plugins</code>
    section. This plugin performs build time enhancement of <code>@Timed</code> methods.
  </p>
  <pre content="xml">
    <plugin>
      <groupId>io.repaint.maven</groupId>
      <artifactId>tiles-maven-plugin</artifactId>
      <version>2.16</version>
      <extensions>true</extensions>
      <configuration>
        <tiles>
          <tile>io.avaje.tile:metrics-enhance:8.3</tile>
          <!-- other tiles ... -->
        </tiles>
      </configuration>
    </plugin>
  </pre>

  <h2 id="gradle">Gradle plugin</h2>
  <p>
    When using Gradle add the following plugin (TODO).
  </p>

  <h2 id="jvm-metrics">Register JVM metrics</h2>
  <p>
    Via <code>MetricManager.jvmMetrics()</code> specify if we want:
  </p>
  <ul>
    <li>Standard JVM metrics (GC, Threads, Memory)</li>
    <li>CGroup metrics</li>
    <li>Logback or Log4J counters for errors and warnings</li>
  </ul>
  <p>
    Below is typical configuration code that additionally specifies
    a reporter to report metrics to a local CSV file every 10 seconds.
  </p>
  <div class="code-java">
    <pre content="java">
      @Factory
      class Configuration {

        @Bean
        MetricReportManager metrics() {

          MetricManager.jvmMetrics()
            .registerJvmMetrics()
            .registerCGroupMetrics()
            .registerLogbackMetrics();

          // simple csv reporter
          MetricReportConfig config = new MetricReportConfig();
          config.setFreqInSeconds(10);
          return new MetricReportManager(config);
        }
      }
    </pre>
  </div>

  <h2 id="timed">Add @Timed</h2>
  <p>
    Add <code>@Timed</code> to classes that we want methods to be timed. By default
    all public methods will have timing added to them.
  </p>
  <div>
    <pre content="java">
      @Timed
      @Singleton
      public class IngestQueueConsumer {
        ...
      }
    </pre>
  </div>
  <ul>
    <li>Add <code>@Timed</code> on additional private methods that we want timing on</li>
    <li>Add <code>@NotTimed</code> on public methods that we do not want timing on</li>
  </ul>
  <p>
    Note that DInject controllers automatically have timing added.
  </p>

</article>

<aside class="sidebar-right">
  <nav class="side">
    <ul>
      <li><a href="#a">a</a></li>
      <li><a href="#b">b</a></li>
      <li><a href="#c">c</a></li>
    </ul>
  </nav>
</aside>
</div>
</body>
</html>
