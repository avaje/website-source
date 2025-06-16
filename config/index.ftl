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
        <li><a href="#quick">Quick Start</a></li>
        <li><a href="#eval">Expression evaluation</a></li>
        <li><a href="#startup">Startup</a></li>
        <li><a href="#loading">Loading configuration</a>
          <ul>
            <li><a href="#load-main">Running app</a></li>
            <li><a href="#load-test">Running tests</a></li>
            <li><a href="#load-local">Running locally</a></li>
          </ul>
        </li>
        <li><a href="#file-watch">File watching</a></li>
        <li><a href="#config">Config</a>
          <ul>
            <li><a href="#get-property">Get Property</a></li>
            <li><a href="#setProperty">Set Property</a></li>
            <li><a href="#eventbuild">Event Publishing</a></li>
            <li><a href="#onChange">On Change</a></li>
            <li><a href="#asProperties">asProperties</a></li>
            <li><a href="#asConfiguration">asConfiguration</a></li>
            <li><a href="#forPath">forPath</a></li>

          </ul>
        </li>
        <li><a href="#plugins">ConfigurationSource</a></li>
        <li><a href="#aws-appconfig">AWS AppConfig</a></li>
        <li><a href="#logging">Event Logging</a></li>
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
          <li><a href="https://discord.gg/Qcqf9R27BR" title="discord server"><i class="fab fa-discord"></i></a></li>
          <li><a href="https://github.com/avaje" title="github source"><i class="fab fa-github"></i></a></li>
          <li><a onclick="toggleTheme();" title="switch dark light theme"><i class="fas fa-adjust"></i></a></li>
        </ul>
      </nav>
    </header>

    <h1 id="overview">
      <span class="logo">Avaje</span>&thinsp;Config
    </h1>
    <p>
      <em>avaje-config</em> provides external configuration for JVM apps. We can provide configuration
      via <em>YAML</em>, <em>TOML</em> &amp; <em>properties</em> files, specifying which files to load using
      command line arguments and resources.
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
        <td><a target="_blank" href="https://github.com/avaje/avaje-config">GitHub</a></td>
        <td><a target="_blank" href="https://javadoc.io/doc/io.avaje/avaje-config/latest/io.avaje.config/io/avaje/config/package-summary.html">Javadoc</a></td>
        <td><a target="_blank" href="https://github.com/avaje/avaje-config/issues">GitHub</a>
        </td> <td><a href="https://github.com/avaje/avaje-config/releases"><img src="https://img.shields.io/maven-central/v/io.avaje/avaje-config.svg?label=Maven%20Central"></a></td>
      </tr>
    </table>

    <p>&nbsp;</p>
    <h3 id="quick">Quick Start</h3><hr/>
    <h4>Add Dependency</h4>
    <pre content="xml">
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-config</artifactId>
    <version>${config-version}</version>
  </dependency>

  <!--
  add for optional TOML support
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-config-toml</artifactId>
    <version>${config-version}</version>
  </dependency>
  -->
    </pre>

    <h4>Add a <em>src/main/resources/application.properties</em> file (or yml)</h4>
    <pre content="java">
    database.example.username=notSecretUsername
    database.example.password=secretPassword
    </pre>

    <h4>Retrieve properties with <em>Config.get</em></h4>

    <pre content="java">
      String username = Config.get("database.example.username");
      String password = Config.get("database.example.password");
    </pre>

    <h2 id="eval">Expression evaluation</h2><hr/>
    <p>
      Expressions start with <code>&dollar;{</code> end with <code>}</code>. They can optionally
      define a default value using a <code>:</code> as we see in the example below for the
      <em>username</em> and <em>password</em> which have default values of <em>mydb</em>
      and <em>notSecure</em> respectively.
    </p>
    <p>
      Expressions are evaluated using <em>environment variables</em>,
      <em>system properties</em> as well as other property files.
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

    <h2 id="startup">Startup</h2><hr/>
    <p>
      <em>avaje-config</em> will initialize and load configuration when it is first used.
    </p>
    <h4>initialization</h4>
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
      If we set <code>config.load.systemProperties</code> to true, all loaded properties are then set into the system properties.
      You can provide an additional property <code>system.excluded.properties</code> to provide a list of configuration properties you want to exclude from being loaded into System Properties.
    </p>

    <h2 id="loading">Loading configuration</h2><hr/>
    <p>
      <em>avaje-config</em> provides ways to load external configuration for running
      an application and running tests. It also provides a simple mechanism to make it
      easy to run the application locally (typically in order to run integration tests locally).
    </p>

    <h3 id="load-main">Running app</h3>
    <p>
      There are five main ways to provide configuration used for the purpose of running
      the application.
    </p>
    <ul>
      <li>1. Default values via <code>src/main/resources</code></li>
      <li>2. Command line arguments</li>
      <li>3. <em>avaje.profiles</em></li>
      <li>4. <em>load.properties</em></li>
      <li>5. ConfigurationSource plugins</li>
    </ul>
    <h4 id="main-resources">1. Default values via main resources</h4>
    <p>
      We can provide "default" configuration values by putting into <code>src/main/resources</code>
      a <code>application.yaml</code> or <code>application.properties</code> file.
    </p>
    <p>
      These values act as default values and can be overwritten by configuration
      provided by other sources such as files specified by command line arguments/profiles/<code>load.properties</code>.
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
      In the example above two external files are configuration files that are loaded
      providing configuration values for the application.
    </p>

    <h4 id="profiles">3. avaje.profiles</h4>
    <p>
      Setting a <code>avaje.profiles</code> property or <code>AVAJE_PROFILES</code> environment variable will cause avaje config to load the property files in the form <code>application-&ltprofile&gt.properties</code> (will also work for yml/yaml files).
      For example, if you set the </code>avaje.profiles</code> property (perhaps via command line) to <code>dev,docker</code> it will attempt to load <code>application-dev.properties</code> and <code>application-docker.properties</code>.
    </p>

    <h4 id="load-properties">4. load.properties</h4>
    <p>
      We can specify a <code>load.properties</code> property to define additional configuration
      files to load.
    </p>

    <h5>example in application.yaml</h5>
    <pre content="yml">
      ## we don't need to specify path if it's in src/main/resources
      ## can be combined with eval to have something like feature flags
      load.properties: ${ENV:local}.properties /etc/other.yaml
    </pre>
    <p>
      After default configuration files are loaded, the <em>load.properties</em> property is
      read and if specified these configuration files are loaded.
    </p>
    <p>
      <code>load.properties</code> is pretty versatile and can even be chained.
      For example, in using the above properties, you can load based on the <code>ENV</code> environment variable/<code>-Dprofile</code> JVM arg, and in the loaded property file you can add <code>load.properties</code> to load even more properties and so on.
    </p>


    <h4>5. ConfigurationSource</h4>
    <p>
      We can also use plugins that implement ConfigurationSource to load configuration from
      other sources. Refer to the <a href="#plugins">ConfigurationSource</a> section for more details.
    </p>

    <h3 id="load-test">Running Tests</h3>
    <p>
      To provide configuration for running tests, add into <code>src/test/resources</code> either
      <code>application-test.yaml</code> or <code>application-test.properties</code>.
    </p>
    <p>
      The configuration from these files will be loaded and used when running tests. This configuration
      will override any configuration supplied by files in <code>src/main/resources</code>.
    </p>

    <h3 id="load-local">Running locally</h3>
    <p>
      When we run our application locally, we can provide configuration for this
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
      Then in <code>~/.localdev</code>, put a yaml or properties configuration file
      using the <em>app.name</em>. For example, given <code>app.name=myapp</code> have
      either <code>~/.localdev/myapp.yaml</code> or <code>~/.localdev/myapp.properties</code>
      define the configuration we want to use when running locally.
    </p>

    <h2 id="file-watch">File watching</h2><hr/>
    <p>
      If <code>config.watch.enabled</code> is set to true, then <em>avaje-config</em> will
      watch the config files and reload configuration when the files change.
    </p>
    <p>
      By default, it will check the config files every 10 seconds. We can change this by setting
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

    <h2 id="config">Config</h2><hr/>
    <p>
      We use <code>Config</code> to access the application configuration. <em>Config</em> can be used
      anywhere in application code - static initializers, enums, constructors etc. There is no limitation
      on where we can use Config.
    </p>
    <p>
      <code>Config</code> has convenient static methods to access the underlying configuration. It also has
      <a href="#asConfiguration">asConfiguration()</a> to return the underlying configuration
      and <a href="#asProperties">asProperties()</a> to return the loaded configuration as standard
      properties.
    </p>

    <h3 id="get-property">Get Property</h3>
    <p>
      <code>Config</code> provides method to get property values as String, int, long, boolean,
      BigDecimal, Enum, URI and Duration.
    </p>
    <h5>Examples</h5>
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
      URI val = Config.getURI("other.url");
      URI val = Config.getURI("other.url", "https://other:8090");
    </pre>
    <h5>List and Set</h5>
    <p>
      We can also return configuration values as a List/Set of String, int, long.
    </p>
    <pre content="java">
        List<|Integer> codes = Config.list().ofInt("my.codes", 42, 54);

        Set<|String> operations = Config.set().of("my.operations", "put", "delete");
    </pre>

    <h5>Function</h5>
    <p>
      We can also provide a function to map a config to a type.
    </p>
    <pre content="java">
        CustomObj codes = Config.getAs("my.codes", s -> new CustomObj(s));

        Optional<|CustomObj> operations = Config.getAsOptional("my.codes", s -> new CustomObj(s));

        List<|CustomObj> operations = Config.list().ofType("my.codes", s -> new CustomObj(s));
    </pre>


    <h3 id="setProperty">Set Property</h3>
    <p>
      Use <code>setProperty()</code> to set configuration values.
    </p>
    <p>
      When we set values, this will fire any configuration callback listeners that
      are registered for the key.
    </p>
    <pre content="java">
      Config.setProperty("other.url", "https://bazz");

      Config.setProperty("feature.cleanup", "false");
    </pre>

    <h3 id="eventbuild">Event Publishing</h3>
    <p>
      Use <code>eventBuilder()</code> to publish multiple changes at once.
    </p>
    <pre content="java">
      Config.eventBuilder("EventName")
         .put("someKey", "val0")
         .put("someOther.key", "42")
         .remove("foo")
         .publish();
    </pre>

    <h3 id="onChange">On Change</h3>
    <p>
      We can register callbacks that execute when a configuration key
      has it's value changed.
    </p>

    <h5>Single property onChange</h5>
    <pre content="java">

      Config.onChange("other.url", newUrl -> {
        // do something interesting with the changed
        // config value
        ...
      });
    </pre>

    <h5>Multi property onChange</h5>
    <pre content="java">
      Config.onChange(event -> {

            Set<String> changedKeys = event.modifiedKeys();

            Configuration updatedConfig = event.configuration();

            // do something with the changed values.
          });

      // Filter events for specific properties
      Config.onChange(event -> {

            Set<String> changedKeys = event.modifiedKeys();

            Configuration updatedConfig = event.configuration();

            // do something with the changed values.
          }, "someKey", "someOther.key");
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
      Config provides a static singleton scope for the underlying Configuration.
      Generally there should not be much need to access the underlying configuration, as the static access is much more convenient.
    </p>
    <pre content="java">
      Configuration configuration = Config.asConfiguration();
    </pre>

    <h3 id="forPath">forPath()</h3>
    <p>
      Obtain a filtered configuration via <code>Config.forpath()</code>.
    </p>
    <pre content="java">
      //given properties like the below in application.properties
      database.example.password=secretPassword
      database.example.username=notSecretUsername

      Configuration dbConfiguration = Config.forPath("database");
      Configuration dbExampleConfiguration = dbConfiguration.forPath("example");
      // or more simply
      Configuration dbExampleConfiguration = Config.forPath("database.example");
      // will return secretPassword
      dbExampleConfiguration.get("password");
      // will return secretPassword
      dbExampleConfiguration.get("username");
    </pre>

    <h2 id="plugins">ConfigurationSource Plugins</h2><hr/>
    <p>
      Plugins implement the <code>ConfigurationSource</code> interface and are found
      and registered via <code>ServiceLoader</code>. This means they have a
      file at <code>src/main/resources/META-INF/services/io.avaje.config.ConfigExtension</code>
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
      Plugins typically read the configuration after all files have loaded, and then use <code>setProperty(key, value)</code>
      to add/modify properties. The values can contain expressions and will have
      their expressions evaluated as part of <em>setProperty</em>.
    </p>
    <p>
      Refer to the example plugin - <a href="https://github.com/avaje/avaje-config/blob/master/avaje-config/src/test/java/org/example/MyExternalLoader.java">MyExternalLoader.java</a>
    </p>


    <h2 id="aws-appconfig">AWS AppConfig</h2><hr/>
    <p>
      If using AWS AppConfig as a configuration source (refer: <a href="https://docs.aws.amazon.com/appconfig/">https://docs.aws.amazon.com/appconfig</a>),
      then we can use the <em>avaje-aws-appconfig</em> component.
    </p>

    <h4>Step 1: Add dependency</h4>
    <pre content="xml">
      <dependency>
        <groupId>io.avaje</groupId>
        <artifactId>avaje-aws-appconfig</artifactId>
        <version>1.2</version>
      </dependency>
    </pre>

    <h4>Step 2: Add configuration</h4>
    <p>
      In src/main/resources add configuration like below to specify for <em>aws.appconfig</em> the <em>application, environment, configuration</em>.
    </p>
    <pre content="yml">
    # In src/main/resources
    aws.appconfig:
        application: ${ENVIRONMENT_NAME:dev}-my-application
        environment: ${ENVIRONMENT_NAME:dev}
        configuration: default
    </pre>

    <p>
      In src/test/resources add <em>aws.appconfig.enabled: false</em> to disable loading the AWS App Configuration when running tests.
    </p>
    <pre content="yml">
      # In src/test/resources
      aws.appconfig.enabled: false
    </pre>

    <h4>Logging</h4>
    <p>
      When Config starts up we show see <em>ConfigurationSource:AppConfigPlugin</em> included in the <em>Loaded properties from ...</em> log message like:
    </p>
    <pre content="json">
     {"level":"INFO",
      "logger":"io.avaje.config",
      "message":"Loaded properties from [resource:application.yaml, ConfigurationSource:AppConfigPlugin] "}
    </pre>
    <p>
      To increase the logging we can set the log level of <em>io.avaje.config.appconfig</em> to DEBUG or TRACE.
    </p>
    <pre content="xml">
      <logger name="io.avaje.config.appconfig" level="TRACE"/>
    </pre>


    <h2 id="logging">Event Logging</h2><hr/>
    <p>
      By default, <code>avaje-config</code> will immediately log initialization events to it's own configured system logger. If you want to use your own configured logger, you can extend the <code>ConfigurationLog</code> interface and
      register via <code>ServiceLoader</code>. This means you have a
      file at <code>src/main/resources/META-INF/services/io.avaje.config.ConfigExtension</code>
      which contains the class name of the implementation.
    </p>
    <p>
      Custom Event loggers implement the methods:
    </p>
    <pre content="java">

  /**
   * Log an event with the given level, message, and thrown exception.
   */
  void log(Level level, String message, Throwable thrown);

  /**
   * Log an event with the given level, formatted message, and arguments.
   * <p>
   * The message format is as per {@link java.text.MessageFormat#format(String, Object...)}.
   */
  void log(Level level, String message, Object... args);
    </pre>
    <p>
      Additionally, you can implement the two default methods and provide behavior before and after the configs are loaded.
    </p>
    <pre content="java">
  /**
   * Invoked when the configuration is being initialized.
   */
  default void preInitialisation() {
  }

  /**
   * Invoked when the initialisation of configuration has been completed.
   */
  default void postInitialisation() {
  }
    </pre>

<p><br><br><br><br><br><br></p>
</div>
</body>
</html>
