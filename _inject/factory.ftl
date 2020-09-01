
<h2 id="factory">@Factory</h2>
<p>
  Factory beans allow logic to be used when creating a bean. Often this logic is based
  on environment variables or system properties (e.g. programmatically create a bean based on AWS region).
</p>
<p>
  We annotate a class with <code>@Factory</code> to tell us that it contains methods
  that create beans. The factory class can itself have dependencies.
</p>

<h2 id="bean">@Bean</h2>
<p>
  We annotate methods on the factory class that create a bean with <code>@Bean</code>.
  These methods can have dependencies and will execute in the appropriate order
  depending on the dependencies they require.
</p>

<h5>Spring DI Note</h5>
<p>
  This is equivalent to Spring DI <code>@Configuration</code> <code>@Bean</code>
  and Micronaut <em>@Factory</em> <em>@Bean</em>.
</p>

<h3>Example</h3>
<pre content="java">
@Factory
class Configuration {

  private final StartConfig startConfig;

  /**
   * Factory can have dependencies.
   */
  @Inject
  Configuration(StartConfig startConfig) {
    this.startConfig = startConfig;
  }

  @Bean
  Pump buildPump() {
    // maybe read System properties or environment variables
    return new FastPump(...);
  }

  /**
   * Method with dependencies as method parameters.
   */
  @Bean
  CoffeeMaker buildBar(Pump pump, Grinder grinder) {
    // maybe read System properties or environment variables
    return new CoffeeMaker(...);
  }
}
</pre>

<h2 id="initMethod">@Bean initMethod & destroyMethod</h2>
<p>
  With <code>@Bean</code> we can specify an <code>initMethod</code>
  which will be executed on startup like <code>@PostConstruct</code>.
  Similarly a <code>destroyMethod</code> which execute on shutdown like <code>@PreDestroy</code>.
</p>


<h3>Example</h3>
<pre content="java">
@Factory
class Configuration {
  ...
  @Bean(initMethod = "init", destroyMethod = "close")
  CoffeeMaker buildCoffeeMaker(Pump pump) {
    return new CoffeeMaker(pump);
  }
}
</pre>
<p>
  The CoffeeMaker has the appropriate methods that are executed as part of the lifecycle.
</p>
<pre content="java">
class CoffeeMaker {
  public void init() {
    // lifecycle executed on start/PostConstruct
  }
  public void close() {
    // lifecycle executed on shutdown/PreDestroy
  }
  ...
}
</pre>

<h2 id="provider">JSR 330 Provider interface</h2>
<p>
  Note that using <code>@Factory</code> plus <code>@Bean</code> is an <b>alternative</b> to the standard
  JSR 330 <code>javax.inject.Provider</code> interface.
</p>
<p>
  Generally the use of <code>@Factory</code> plus <code>@Bean</code> is expected as it is
  relatively more convenient than using <code>javax.inject.Provider</code>. In Spring DI terms
  the use of @Configuration @Bean is now arguably more common than Spring's FactoryBean interface.
</p>

