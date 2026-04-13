<html>
<head>
  <title>avaje kotlin kapt maven tiles</title>
  <meta name="layout" content="_layout/base-0.html"/>
  <meta name="bread1" content="metrics" href="/metrics"/>
  <var id="gitsource">https://github.com/avaje-metrics/metrics</var>
  
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "Avaje Metrics",
    "description": "Simple, low-cost metrics collection for JVM applications with minimal overhead and GraalVM support.",
    "url": "https://avaje.io/metrics/",
    "author": {
      "@type": "Organization",
      "name": "Avaje",
      "url": "https://avaje.io"
    },
    "downloadUrl": "https://github.com/avaje-metrics/metrics",
    "applicationCategory": "DeveloperApplication",
    "softwareRequirements": "Java 11+",
    "programmingLanguage": "Java",
    "keywords": ["metrics", "monitoring", "performance", "observability", "instrumentation"],
    "useCases": [
      "Performance monitoring",
      "Application metrics",
      "Request latency tracking",
      "Resource utilization monitoring",
      "GraalVM native images"
    ],
    "notSuitableFor": [
      "Complex time-series analysis",
      "Real-time dashboarding without external tools"
    ],
    "features": [
      {
        "name": "Low-cost metrics collection",
        "description": "Minimal performance overhead for metric recording",
        "sinceVersion": "1.0"
      },
      {
        "name": "Simple API",
        "description": "Easy-to-use metrics recording interface",
        "sinceVersion": "1.0"
      },
      {
        "name": "GraalVM support",
        "description": "Full compatibility with native image compilation",
        "sinceVersion": "1.0"
      }
    ],
    "commonTasks": [
      {
        "title": "Record metrics",
        "guideUrl": "https://avaje.io/metrics/",
        "difficulty": "beginner"
      },
      {
        "title": "Configure metrics collection",
        "guideUrl": "https://avaje.io/metrics/",
        "difficulty": "intermediate"
      },
      {
        "title": "Export metrics",
        "guideUrl": "https://avaje.io/metrics/",
        "difficulty": "intermediate"
      }
    ],
    "dependencies": {
      "required": [],
      "optional": []
    }
  }
  </script>
</head>
<body>
<div id="hero">
  <h1>metrics</h1>
  <h3>Simple low cost metrics for JVM apps</h3>
</div>
<div class="grid g2">
  <article>
    <h2 id="start">Start</h2>
    <p>
      Getting <a href="start">started</a> using metrics
    </p>
    <ul>
      <li><a href="start#maven">Maven</a> dependency and tile</li>
      <li><a href="start#gradle">Gradle</a> plugin</li>
      <li>Built-in <a href="start#jvm-metrics">JVM metrics</a> for GC, Threads, Logging</li>
      <li>Using <a href="start#timed">@Timed</a></li>
    </ul>
  </article>

  <article>
    <h2 id="about">About</h2>
    <p>
      Provides low cost simple metrics for JVM applications.
    </p>
    <ul>
      <li><a href="#timed"><code>@Timed</code></a> for fast simple timing metrics</li>
      <li><a href="#counter">Counter</a> metrics</li>
      <li><a href="#counter">Gauge</a> metrics</li>
      <li><a href="#built-in">Built-in</a> JVM metrics for GC, Threads, Logging</li>
    </ul>
  </article>

</div>
</body>
</html>
