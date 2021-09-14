<html>
<head>
  <title>avaje config</title>
  <meta name="layout" content="_layout/base-config.html"/>
  <meta name="bread1" content="config" href="/config/"/>
  <var id="gitsource">https://github.com/avaje/config</var>
  <#assign config = "active">
</head>
<body>
<div class="container">
  <aside id="sidenav">
    <p>&nbsp;</p>
    <nav class="side scroll">
      <ul>
        <li><a href="#about">Avaje Config</a>
          <ul>
            <li><a href="#dependency">Dependency</a></li>
          </ul>
        </li>
        <li><a href="#eval">Expression evaluation</a></li>
        <li><a href="#loading">Loading configuration</a>
          <ul>
            <li><a href="#load-main">Running app</a></li>
            <li><a href="#load-test">Running tests</a></li>
            <li><a href="#load-local">Running locally</a></li>
          </ul>
        </li>
        <li><a href="#startup">Startup</a></li>
        <li><a href="#file-watch">File watching</a></li>
        <li><a href="#config">Config</a>
          <ul>
            <li><a href="#get-property">get property</a></li>
            <li><a href="#setProperty">set property</a></li>
            <li><a href="#onChange">on change</a></li>
            <li><a href="#asProperties">asProperties</a></li>
            <li><a href="#asConfiguration">asConfiguration</a></li>

          </ul>
        </li>
        <li><a href="#plugins">Plugins</a></li>
      </ul>
    </nav>
  </aside>

  <article id="main-content">
    <header>
      <nav id="top">
        <div class="breadcrumb">
          <a href="/" title="home">avaje</a> &nbsp;&nbsp;/&nbsp;&nbsp;config
        </div>
        <ul>
          <li><a href="/" title="home"><i class="fas fa-home"></i></a></li>
          <li><a href="https://github.com/avaje" title="github source"><i class="fab fa-github"></i></a></li>
          <li><a onclick="toggleTheme();" title="switch dark light theme"><i class="fas fa-adjust"></i></a></li>
        </ul>
      </nav>
    </header>

    <h1 id="about">Avaje Config</h1>
    <p>
      <em>avaje-config</em> provides external configuration for JVM apps. We can provide configuration
      via <em>yaml</em> or <em>properties</em> files and specify which files to load using
      command line argument and resources.
    </p>

    <table width="100%">
      <tr>
        <th>License</th>
        <th>Source</th>
        <th>API Docs</th>
        <th>Issues</th>
        <th>Releases</th>
      </tr>
      <tr>
        <td><a target="_blank" href="https://github.com/avaje/avaje-config/blob/master/LICENSE">Apache2</a></td>
        <td><a target="_blank" href="https://github.com/avaje/avaje-config">Github</a></td>
        <td><a target="_blank" href="/apidocs/avaje-config">Javadoc</a></td>
        <td><a target="_blank" href="https://github.com/avaje/avaje-config/issues">Github</a></td>
        <td><a target="_blank" href="https://github.com/avaje/avaje-config/releases">Latest 1.4</a></td>
      </tr>
    </table>

    <p>&nbsp;</p>
    <h3 id="dependency">Dependency</h3>
    <#include "/_common/dependency.html">


    <p>&nbsp;</p>
    <h2 id="eval">Expression evaluation</h2>
    <p>
      Expressions start with <code>&dollar;{</code> end with <code>}</code>. They can optionally
      define a default value using a <code>:</code> as we see in the example below for the
      <em>username</em> and <em>password</em> which have default values of <em>mydb</em>
      and <em>notSecure</em> respectively.
    </p>
    <p>
      Expressions are evaluated using <em>environment variables</em>,
      <em>system properties</em> as well as other properties.
    </p>

    <h5>example</h5>
    <pre content="yml">
      app.name: myapp
      images.home: ${user.home}/myapp/images

      datasource:
        db:
          username: ${DB_USER:mydb}
          password: ${DB_PASS:notSecure}
          url: ${DB_URL}
    </pre>

    <h2 id="loading">Loading configuration</h2>
    <p>
      <em>avaje-config</em> provides ways to load external configuration for running
      an application and running tests. It also provides a simple mechanism to make it
      easy to run the application locally (typically in order to run integration tests locally).
    </p>

    <h3 id="load-main">Running app</h3>
    <p>
      There are four main ways to provide configuration used for the purpose of running
      the application.
    </p>
    <ul>
      <li>1. Default values via <code>src/main/resources</code></li>
      <li>2. Command line arguments</li>
      <li>3. <em>load.properties</em></li>
      <li>4. Plugins</li>
    </ul>
    <h4 id="main-resources">1. Default values via main resources</h4>
    <p>
      We can provide "default" configuration values by putting into <code>src/main/resources</code>
      either <code>application.yaml</code> or <code>application.properties</code>.
    </p>
    <p>
      These values act as default values and can be overwritten by configuration
      provided by other sources such as files specified by command line arguments.
    </p>

    <h4 id="command-line">2. Command line arguments</h4>
    <p>
      We can specify external configuration files to use via command line arguments.
      Arguments proceeded by <code>-P</code> are considered possible configuration files
      and <em>avaje-config</em> will try to load them. If they are not valid files that exist
      then they are ignored.
    </p>

    <h5>example</h5>
    <pre content="sh">
      java -jar myapp.jar -P/etc/config/myapp.properties -P/etc/other.yaml
    </pre>
    <p>
      In the example above 2 external files are configuration files that are loaded
      providing configuration values for the application.
    </p>

    <h4 id="load-properties">3. load.properties</h4>
    <p>
      Optionally we specify a <code>load.properties</code> property to define configuration
      files to load.
    </p>

    <h5>example</h5>
    <pre content="yml">
      ## in application.yaml
      load.properties: /etc/config/myapp.properties /etc/other.yaml
    </pre>
    <p>
      After default configuration files are loaded the <em>load.properties</em> property is
      read and if specified these configuration files are loaded.
    </p>

    <h4>4. Plugins</h4>
    <p>
      We can also use plugins that implement ConfigurationSource to load configuration from
      other sources. Refer to the <a href="#plugins">Plugins</a> section for more details.
    </p>

    <h3 id="load-test">Running Tests</h3>
    <p>
      To provide configuration for running tests add into <code>src/test/resources</code> either
      <code>application-test.yaml</code> or <code>application-test.properties</code>.
    </p>
    <p>
      The configuration from these files is loaded and used when running tests. This configuration
      will override any configuration supplied by files in <code>src/main/resources</code>.
    </p>

    <h3 id="load-local">Running locally</h3>
    <p>
      When we run our application locally we can provide configuration for this
      via properties or yaml files in a <code>~/.localdev</code> directory.
    </p>
    <p>
      For example, when running locally we want to provide configuration that configures
      our application to use a local database. We want to do this when we run integration
      tests locally running application(s).
    </p>
    <h4 id="specify-app-name">app.name</h4>
    <p>
      We must specify a <em>app.name</em> property to do this.
    </p>

    <h5>example</h5>
    <pre content="properties">
      app.name=myapp
    </pre>
    <p>
      Then in <code>~/.localdev</code> put a yaml or properties configuration file
      using the <em>app.name</em>. For example, given <code>app.name=myapp</code> have
      either <code>~/.localdev/myapp.yaml</code> or <code>~/.localdev/myapp.properties</code>
      define the configuration we want to use when running locally.
    </p>

    <h2 id="startup">Startup</h2>
    <p>
      <em>avaje-config</em> will initialise and load configuration when it is first used.
    </p>
    <h4>Initialisation</h4>
    <ul>
      <li>Loads all the configuration files</li>
      <li>Performs expression evaluation on all the values</li>
      <li>Using ServiceLoader finds and loads all ConfigurationSource plugins</li>
      <li>Checks <code>config.load.systemProperties</code> and loads into system properties if set</li>
      <li>Checks <code>config.watch.enabled</code> and starts file watching if set</li>
    </ul>

    <p>&nbsp;</p>
    <h3><em>config.load.systemProperties</em></h3>
    <p>
      If we set <code>config.load.systemProperties</code> to true then all the properties that
      have been loaded are then set into system properties.
    </p>

    <h2 id="file-watch">File watching</h2>
    <p>
      If <code>config.watch.enabled</code> is set to true then <em>avaje-config</em> will
      watch the config files and reload configuration when the files change.
    </p>
    <p>
      By default it will check the config files every 10 seconds. We can change this by setting
      <code>config.watch.period</code>
    </p>

    <h4>example</h4>
    <pre content="yml">
      config:
        watch:
          enabled: true
          period: 5   ## check every 5 seconds
    </pre>
    <p>
      We can use this as a simple form of feature toggling. For example if we are
      using kubernetes and have configuration file based on a config map, we can
      edit the config map to enable/disable features.
    </p>
    <pre content="yml">
      config.watch.enabled: true

      ## some config values to toggle features on/off
      feature.cleanup.enabled: true
      feature.processEmails.enabled: false
    </pre>
    <pre content="java">
      if (Config.enabled("feature.cleanup.enabled") {
        ...
      }
    </pre>

    <h2 id="config">Config</h2>
    <p>
      We use <code>Config</code> to access the application configuration. <em>Config</em> can be used
      anywhere in application code - static initialisers, constructors etc. There is no limitation
      on where we can use Config.
    </p>
    <p>
      <code>Config</code> has convenient static methods to access the underlying configuration and
      this is how the majority of applications will use it. It also has
      <a href="#asConfiguration">asConfiguration()</a> to return the underlying configuration
      and <a href="#asProperties">asProperties()</a> to return the loaded configuration as standard
      properties.
    </p>

    <h3 id="get-property">Get property</h3>
    <p>
      <code>Config</code> provides method to get property values as String, int, long, boolean,
      BigDecimal, Enum and URL.
    </p>
    <h5>examples</h5>
    <pre content="java">
      // get a String property
      String value = Config.get("myapp.foo");

      // with a default value
      String value = Config.get("myapp.foo", "withDefaultValue");
    </pre>
    <pre content="java">
      int port = Config.getInt("app.port");
      long val = Config.getInt("foo", 42);
    </pre>
    <pre content="java">
      long port = Config.getLong("app.port");
      long val = Config.getLong("foo", 42);
    </pre>
    <pre content="java">
      boolean val = Config.getBool("feature.cleanup");
      boolean val = Config.getBool("feature.cleanup", true);

      // Config.enabled() is an alias for Config.getBool()
      boolean val = Config.enabled("feature.cleanup");
      boolean val = Config.enabled("feature.cleanup", true);
    </pre>
    <pre content="java">
      BigDecimal val = Config.getDecimal("myapp.tax.rate");
      BigDecimal val = Config.getDecimal("myapp.tax.rate", "12.5");
    </pre>
    <pre content="java">
      MyEnum val = Config.getEnum(MyEnum.class, "myapp.code");
      MyEnum val = Config.getEnum(MyEnum.class, "myapp.code", MyEnum.DEFAULT);
    </pre>
    <pre content="java">
      URL val = Config.getURL("other.url");
      URL val = Config.getURL("other.url", "https://other:8090");
    </pre>
    <h5>List and Set</h5>
    <p>
      We can also return configuration values as List or Set of String, int and long.
    </p>
    <pre content="java">
        List<|Integer> codes = Config.getList().ofInt("my.codes", 42, 54);

        Set<|String> operations = Config.getSet().of("my.operations", "put", "delete");
    </pre>


    <h3 id="setProperty">Set property</h3>
    <p>
      Use <code>setProperty()</code> to set configuration values.
    </p>
    <p>
      When we set values this will fire any configuration callback listeners that
      are registered for the key.
    </p>
    <pre content="java">
      Config.setProperty("other.url", "https://bazz");

      Config.setProperty("feature.cleanup", "false");
    </pre>


    <h3 id="onChange">On change</h3>
    <p>
      We can register callbacks that execute when a configuration key
      has it's value changed.
    </p>

    <h5>example</h5>
    <pre content="java">

      Config.onChange("other.url", newUrl -> {
        // do something interesting with the changed
        // config value
        ...
      });

    </pre>

    <h3 id="asProperties">asProperties()</h3>
    <p>
      Obtain all the configuration values as standard properties using <code>Config.asProperties()</code>
    </p>
    <pre content="java">
      Properties properties = Config.asProperties();
    </pre>


    <h3 id="asConfiguration">asConfiguration()</h3>
    <p>
      Obtain the underlying configuration via <code>Config.asConfiguration()</code>.
      Config is providing static singleton scope for the underlying Configuration.
      We generally always use Config because it is convenient and there should not
      be much need to access the underlying configuration.
    </p>
    <pre content="java">
      Configuration configuration = Config.asConfiguration();
    </pre>


    <h2 id="plugins">Plugins</h2>
    <p>
      Plugins implement the <code>ConfigurationSource</code> interface and found
      and registered via <code>ServiceLoader</code>. This means they have a
      file at <code>src/main/resources/META-INF/services/io.avaje.config.ConfigurationSource</code>
      which contains the class name of the implementation.
    </p>
    <p>
      Plugins implement the method
    </p>
    <pre content="java">
      void load(Configuration configuration);
    </pre>
    <p>
      They are able to use configuration to read properties if needed, for example
      read the host name of a redis server to read configuration from.
    </p>
    <p>
      Plugins typically read their configuration source and then use <code>setProperty(key, value)</code>
      to set the properties into configuration. The values can contain expressions and will have
      their expressions evaluated as part of <em>setProperty</em>.
    </p>
    <p>
      Refer to the (silly) example plugin - <a href="https://github.com/avaje/avaje-config/blob/master/src/test/java/org/example/MyExternalLoader.java">MyExternalLoader.java</a>
    </p>

  </article>

</div>
</body>
</html>
