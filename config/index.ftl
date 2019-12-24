<html>
<head>
  <meta name="layout" content="_layout/_base.html"/>
  <#assign config = "active">
  <title>avaje config</title>
</head>
<body>
<div class="container joe">
  <div class="hero">
    <h1>Avaje Config</h1>
  </div>
  <div class="row">
    <div class="col col-8">

      <h2>About</h2>
      <p>
        External configuration for JVM applications.
      </p>
      <ul>
        <li>Reads <a href="#main">application.yaml</a> & <a href="#main">.properties</a></li>
        <li>Specify properties files via <a href="#command-line">command line</a></li>
        <li>For testing reads <a href="#test">application-test.yaml</a> and <a href="#test">.properties</a></li>
        <li>For <a href="#local-dev">local development</a> reads configuration from <code>~/.localdev</code></li>
        <li><A href="#k8s">Kubernetes</a> Env variables</li>
        <li><a href="#plugin">Plugin API</a> for loading from other sources</li>
      </ul>

      <h2>Getting started</h2>

      <h5>1. Add dependency</h5>
      <#include "/_common/dependency.html">
      <p>
        Add the dependency to your project.
      </p>

      <h5 id="test">2. For <em>Test</em> configuration</h5>
      <p>
        For configuration used when running local tests add into <code>src/test/resources</code> either:
      </p>
      <ul>
        <li><code>application-test.yaml</code> or <code>application-test.properties</code></li>
      </ul>

      <h5>3. For <em>Main</em> configuration</h5>
      <h6 id="main">3a. Resources</h6>
      <p>
        Optionally provide "default" configuration by adding to <code>src/main/resources</code> either:
      </p>
      <ul>
        <li><code>application.yaml</code> or <code>application.properties</code></li>
      </ul>
      <p>
        Configuration specified by these files will be overridden by other configuration sources
        (load.properties, command line args or plugins).
      </p>
      <h6>3b. load.properties</h6>
      <p>
        Optionally specify a <code>load.properties</code> property to define locations to
        load external configuration from. For example:
      </p>
      <pre content="yml">
        ## in application.yaml
        load.properties: /etc/config/myapp.properties /etc/other.yaml
      </pre>
      <p>
        After default configuration files are loaded the <em>load.properties</em> property is read to see
        if it specifies other properties/yaml configuration files to load.
      </p>
      <h6 id="command-line">3c. Command line arguments</h6>
      <p>
        Command line arguments proceeded by <code>-P</code> are considered potential configuration files.
        For example:
      </p>
      <pre content="sh">
        java -jar myapp.jar -P/etc/config/myapp.yaml -P/etc/other.yaml
      </pre>

      <h2>Using Config</h2>
      <p>
        We use <code>Config</code> to access the global configuration. <em>Config</em> can be used
        anywhere in application code - static initialisers, constructors etc. There is no limitation
        on where we can use Config.
      </p>
      <h6>Example reading properties</h6>
      <pre content="java">
        // get a String property
        String value = Config.get("myapp.foo");

        // with a default value
        String value = Config.get("myapp.foo", "withDefaultValue");

        // also int, long and boolean with and without default values
        int intVal = Config.getInt("bar");
        long longVal = Config.getLong("bar", 42);
      </pre>
      <h6>Optional properties</h6>
      <p>
        If a property is not defined then Config will fail fast
        and throw an IllegalStateException unless a default value
        is supplied or getOptional() is used.
      </p>
      <pre content="java">
        // if myapp.foo is not defined
        // ... throws IllegalStateException
        String value = Config.get("myapp.foo");

        // specify a default
        String value = Config.get("myapp.foo", "someDefault");

        // or use optional
        Optional<!String> value = Config.getOptional("myapp.foo");
      </pre>
      <p>
        Config will load configuration and provides API to read, change and listen to changes to configuration.
      </p>

      <h2 id="local-dev">Local development</h2>
      <p>
        Sometimes we want configuration for when we run our application locally (via main).
        For example, we want to provide configuration that points our application to a local database.
      </p>
      <p>
        To do this we need to:
      </p>
      <h6>1. Specify <em>app.name</em> property</h6>
      <p>
        Specify <code>app.name</code> as a configuration property (in application.yaml or similarly loaded
        configuration).
      </p>
      <h6>2. Add <em>~/.localdev/${r"${app.name}"}.yaml</em></h6>
      <p>
        Add a file into <code>~/.localdev</code> called either <em>${r"${app.name}"}.yaml</em> or
        <wm>${r"${app.name}"}.properties</wm>
      </p>
      <p>
        For example, if the app.name was myapp then we have either:
      </p>
      <ul>
        <li><em>~/.localdev/myapp.yaml</em> or <em>~/.localdev/myapp.properties</em></li>
      </ul>
      <p>
        Note that the local development configuration is not loaded if the test configuration is loaded.
      </p>

      <h2 id="k8s">Kubernetes Env variables</h2>
      <p>
        Config will use the following environment variables if they are set.
      </p>
      <ul>
        <li><em>POD_NAME</em> - to set <code>app.name</code> & <code>app.instanceId</code></li>
        <li><em>POD_ENVIRONMENT</em> - to set <code>app.environment</code></li>
      </ul>
      <p>
        Config will check if those environment variables are set and if so translate them into
        <em>app.name</em> and <em>app.environment</em> if those properties have not already
        been set.
      </p>

      <h2 id="plugin">Plugins</h2>
      <p>
        TODO: Plugins to load extra configuration (like URL)
      </p>
    </div>
  </div>

</div>
</body>
</html>
