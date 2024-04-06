<h2 id="injection">Injection</h2>

<h3 id="singleton">@Singleton</h3>
<p>
  Put <code>@Singleton</code> on beans that we want dependency injection on.
  These are beans that are created ("wired") by dependency injection and put into the scope.
  They are then available to be injected into other beans.
</p>
<pre content="java">
@Singleton
public class CoffeeMaker {
  ...
</pre>

<h3 id="component">@Component</h3>
<p>
  <code>@Component</code> is similar to JSR-330 <code>@Singleton</code> except it is <em>avaje-inject</em>
  specific. In general, we prefer to use the JSR-330 standard annotations but there are a couple of cases
  where would choose to use the avaje-inject specific <code>@Component</code> instead.
</p>
<ul>
  <li>A project is using another DI library (for example, Guice) to process the standard
    <code>@Singleton</code> and we want avaje-inject to co-exist but ignore anything annotated with
    <code>@Singleton</code>.
  </li>
  <li>
    A project wants to work with <em>both</em> <code>javax.inject</code> and <code>jakarta.inject</code>
  </li>
</ul>
<p>
  In these cases we may choose to use the <em>avaje-inject</em> specific <code>@Component</code> rather than
  JSR-330 <code>@Singleton</code>.
</p>
<pre content="java">
@Component
public class CoffeeMaker {
  ...
</pre>

<h4>Ignoring <code>@Singleton</code></h4>
<p>
  To get avaje-inject to ignore any classes annotated with <code>@Singleton</code> use:
</p>

<pre content="java">
@InjectModule(ignoreSingleton = true)
</pre>
<p>
  With <code>ignoreSingleton = true</code> avaje-inject will ignore <code>@Singleton</code> with the
  view that some other DI library is also being used and is handling those components.
</p>

<h3 id="import">@Component.Import</h3>
<p>
  Put <code>@Component.Import</code> on a class/package-info to create dependency injection on external classes (e.g. mvn dependencies).
  It has the same effect as if the bean was directly annotated by <code>@Component</code>.
</p>
<pre content="java">
@Component.Import(TeaMaker.class)
@Singleton
public class CoffeeMaker {
  ...
</pre>

<h3 id="inject">@Inject</h3>
<p>
  Put <code>@Inject</code> on the constructor that should be used for constructor dependency injection.
</p>
<p>
  If we want to use field injection put the <code>@Inject</code> on the field. The field must not
  be <code>private</code> and must not be <code>final</code> for field injection.
</p>

<h3 id="constructor">Constructor Injection</h3>
<pre content="java">
@Singleton
public class CoffeeMaker {

  private final Pump pump;

  private final Grinder grinder;

  @Inject
  public CoffeeMaker(Pump pump, Grinder grinder) {
    this.pump = pump;
    this.grinder = grinder;
  }
  ...
</pre>
<p>
  The above CoffeeMaker is using constructor injection. Both a Pump and Ginder will be injected into the
  constructor when the DI creates (or "wires") the CoffeeMaker.
</p>

<h4>Single Constructors</h4>
<p>
  If there is only one constructor, <b>we don't need
  to specify <code>@Inject</code></b>. This includes records and kotlin data classes.
</p>

<pre content="java">
@Singleton
public class CoffeeMaker {

  private final Pump pump;
  private final Grinder grinder;

  public CoffeeMaker(Pump pump, Grinder grinder) {
    this.pump = pump;
    this.grinder = grinder;
  }
}
</pre>
<pre content="java">
@Singleton
public record CoffeeMaker(Pump pump, Grinder grinder) {}
</pre>
<pre content="kotlin">
@Singleton
class CoffeeMaker(private val pump: Pump, private val grinder: Grinder) {}
</pre>

<h3 id="field">Field Injection</h3>
<pre content="java">
@Singleton
public class CoffeeMaker {

  @Inject
  Pump pump;

  @Inject
  Grinder grinder;
  ...
</pre>
<p>
  With field injection the <code>@Inject</code> is placed on the field. The field cannot be <code>private</code>
  or <code>final</code>.
</p>
<h4>Constructor injection preferred</h4>
<p>
  Generally there is a preference to use constructor injection over field injection as constructor
  injection:
</p>
<ul>
  <li>Promotes immutability / use of final fields / proper initialisation</li>
  <li>Communicates required dependencies at compile time. Helps when dependencies
    change to keep test code in line.</li>
  <li>Helps identify when there are too many dependencies. Too many constructor
    arguments is a more obvious code smell compared to field injection.
    Promotes single responsibility principal.</li>
</ul>

<h4>Circular dependencies</h4>
<p>
  We use field injection or method injection to handle <a href="#circular">circular dependencies</a>.
  See <a href="#circular">below</a> for more details.
</p>

<h4>Kotlin field injection</h4>
<p>
  For Kotlin we can consider using <em>lateinit</em> on the property with field injection.
</p>
<pre content="kotlin">
@Singleton
class Grinder {

  @Inject
  lateinit var pump: Pump

  fun grind(): String {
    ...
  }
}
</pre>

<h3 id="method">Method Injection</h3>
<p>
  For method injection annotate a method with <code>@Inject</code>.
</p>
<pre content="java">
@Singleton
public class CoffeeMaker {

  Grinder grinder;

  @Inject
  void setGrinder(Grinder grinder) {
    this.grinder = grinder;
  }
  ...
</pre>


<h3 id="mixed">Mixed constructor, field and method injection</h3>
<p>
  We are allowed to mix constructor, field and method injection. In the below example the Grinder
  is injected into the constructor and the Pump is injected by field injection.
</p>

<pre content="java">
@Singleton
public class CoffeeMaker {

  @Inject
  Pump pump;

  private final Grinder grinder;

  public CoffeeMaker(Grinder grinder) {
    this.grinder = grinder;
  }
</pre>

<h3 id="circular">Circular Dependencies</h3>
<p>
  When we have a circular dependency then we need to use either <a href="#field">field injection</a>
  or <a href="#method">method injection</a> on one of the dependencies.
</p>
<p>
  For example, lets say we have A and B where A depends on B and B depends on A. In this case
  we can't use constructor injection for both A and B like:
</p>
<pre content="java">
// circular dependency with constructor injection, this will not work!!

@Singleton
class A {
  B b;
  A(B b) {       // constructor for A depends on B
    this.b = b;
  }
}

@Singleton
class B {
  A a;
  B(A a) {       // constructor for B depends on A
    this.a = a;
  }
}
</pre>
<p>
  With the above circular dependencies for A and B constructor injection, <em>avaje-inject</em>
  cannot determine the order in which to construct the beans. <em>avaje-inject</em> will
  detect this and product a compilation error outlining the beans involved and ask us
  to change to use field injection for one of the dependencies.
</p>
<p>
  We cannot use constructor injection for both A and B, instead we must use
  either field/method injection on either A or B like:
</p>
<pre content="java">
@Singleton
class A {
  @Inject   // use field injection
  B b;
}

@Singleton
class B {
  A a;
  B(A a) {
    this.a = a;
  }
}
</pre>
<p>
  The reason this works is that field/method injection occur after all the
  dependencies are constructed. <em>avaje-inject</em> uses 3 phases to construct a bean scope:
</p>
<ul>
  <li>Phase 1: Construct all the beans in order based on constructor dependencies</li>
  <li>Phase 2: Apply field injection and method injection on all beans</li>
  <li>Phase 3: Execute all <code>@PostConstruct</code> lifecycle methods</li>
</ul>
<p>
  Circular dependencies more commonly occur with more than 2 beans. For example,
  lets say we have A, B and C where:
</p>
<ul>
  <li>A depends on B</li>
  <li>B depends on C</li>
  <li>C depends on A</li>
</ul>
<p>
  With A, B, C above they combine to create a circular dependency. To handle this
  we need to use <a href="#field">field injection</a> or <a href="#method">method injection</a>
  on one of the dependencies.
</p>

<h3 id="optional">Optional</h3>
<p>
  We can use <code>java.util.Optional&lt;T&gt;</code> to inject optional dependencies.
  These are dependencies that might not be provided / might not have an available implementation
  / might only be provided based on configuration (a bit like a feature toggle).
</p>
<pre content="java">
@Singleton
class Pump {

  private final Heater heater;

  private final Optional<|Widget> widget;

  @Inject
  Pump(Heater heater, Optional<|Widget> widget) {
    this.heater = heater;
    this.widget = widget;
  }

  public void pump() {
    if (widget.isPresent()) {
      widget.get().doStuff();
    }
    ...
  }
}
</pre>
<h5>Spring DI Note</h5>
<p>
  Spring users will be familiar with the use of <code>@Autowired(required=false)</code>
  for wiring optional dependencies. With <em>avaje-inject</em> we instead use <code>Optional</code>
  or <code>@Nullable</code> to inject optional dependencies.
</p>

<h3 id="nullable">@Nullable</h3>
<p>
  As an alternative to Optional we can use <code>@Nullable</code> to indicate that a dependency
  is optional / can be null. Any <code>@Nullable</code> annotation can be used, it does not
  matter which package the annotation is in.
</p>
<pre content="java">
@Singleton
class Pump {

  private final Heater heater;

  private final Widget widget;

  @Inject
  Pump(Heater heater, @Nullable Widget widget) {
    this.heater = heater;
    this.widget = widget;
  }

  public void pump() {
    if (widget != null) {
      widget.doStuff();
    }
    ...
  }
}
</pre>

<h3 id="list">List</h3>
<p>
  We can inject a <code>java.util.List&lt;T&gt;</code> of beans that implement an interface.
</p>
<pre content="java">
@Singleton
public class CombinedBars {

  private final List<|Bar> bars;

  @Inject
  public CombinedBars(List<|Bar> bars) {
    this.bars = bars;
  }
</pre>

<h3 id="set">Set</h3>
<p>
  We can inject a <code>java.util.Set&lt;T&gt;</code> of beans that implement an interface.
</p>
<pre content="java">
@Singleton
public class CombinedBars {

  private final Set<|Bar> bars;

  @Inject
  public CombinedBars(Set<|Bar> bars) {
    this.bars = bars;
  }
</pre>

<h3 id="provider">Provider</h3>
<p>
  A Singleton bean can implement <code>(javax/jakarta).inject.Provider&lt;T&gt;</code> to create a bean to
  be used in injection.
</p>
<pre content="java">
@Singleton
class FooProvider implements Provider<|Foo> {

  private final Bazz bazz;

  FooProvider(Bazz bazz) {
    this.bazz = bazz;
  }

  @Override
  public Foo get() {
    // maybe do interesting logic, read environment variables ...
    return new BasicFoo(bazz);
  }
}
</pre>
<p>
  We can then have another bean that has <code>Provider&lt;T&gt;</code> injected into it.
  It calls <code>get()</code> to get an instance to then use.
</p>

<pre content="java">
@Singleton
class UseFoo  {

  private final Provider<|Foo> fooProvider;

  UseFoo(Provider<|Foo> fooProvider) {
    this.fooProvider = fooProvider;
  }

  void doStuff() {

    // get a Foo instance and use it
    Foo foo = fooProvider.get();
    ...
  }
}
</pre>

<p>
  When using <code>Provider&lt;T&gt;</code> <code>get()</code> we can get a new instance each time we
  call <code>get()</code>. In the above example, the <code>FooProvider.get()</code> method
  returns a new instance each time <code>get()</code> is called. This is effectively the
  same as <em>Prototype scope</em>.
</p>
<p>
  An alternative to implementing the <code>Provider&lt;T&gt;</code> interface is
  to instead use <code><a href="#factory">@Factory</a></code> and <code><a href="#bean">@Bean</a></code>
  as can be more flexible and convenient.
</p>

<h3 id="factory">@Factory</h3>
<p>
  Factory beans allow us to programmatically creating a bean. Often the logic is based
  on external configuration, environment variables, system properties etc.
</p>
<p>
  We annotate a class with <code>@Factory</code> to tell us that it contains methods
  that create beans. The factory class can itself have dependencies and the methods
  can also have dependencies.
</p>
<p>
  <em>@Factory</em> <em>@Bean</em> are equivalent to Spring DI <em>@Configuration</em> <em>@Bean</em>
  and Micronaut <em>@Factory</em> <em>@Bean</em>. Guice users will see this as similar to Modules with
  <em>@Provides</em> methods.
</p>

<h3 id="bean">@Bean</h3>
<p>
  We annotate methods on the factory class that create a bean with <code>@Bean</code>.
  These methods can have dependencies and will execute in the appropriate order
  depending on the dependencies they require.
</p>

<h4>Example</h4>
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
<h3 id="beanclose">@Bean autocloseable</h3>
<p>
  The avaje annotation processor reads the bean method return types to detect if the bean is an instance of <code>Closeable</code> or <code>AutoCloseable</code>.
  In the case where you are wiring an interface that doesn't implement these types, but the concrete class implements, we can specify <code>autocloseable</code> to inform the processor.
 </p>

<pre content="java">
@Factory
class Configuration {
  ...
  @Bean(autocloseable = true)
  CoffeeMaker buildCoffeeMaker(Pump pump) {
    return new CloseableCoffeeMaker(pump);
  }
}
</pre>

<h3 id="initMethod">@Bean initMethod & destroyMethod</h3>
<p>
  With <code>@Bean</code> we can specify an <code>initMethod</code>
  which will be executed on startup like <code>@PostConstruct</code>.
  Similarly a <code>destroyMethod</code> which execute on shutdown like <code>@PreDestroy</code>.
</p>

<p>
  The CoffeeMaker has the appropriate methods that are executed as part of the lifecycle.
</p>
<pre content="java">
class CoffeeMaker {

  void init() {
    // lifecycle executed on start/PostConstruct
  }
  void close() {
    // lifecycle executed on shutdown/PreDestroy
  }
  ...
}
</pre>
<h3 id="optionalBean">Optional @Bean</h3>
<p>
  We can use <code>Optional&lt;T&gt;</code> to indicate that the method produces
  an optional dependency.
</p>
<p>
  Often the dependency is only provided based on external configuration
  a bit like a feature toggle / config toggle. For example, we might do
  this in a CI/CD environment until such time that the dependency is
  always "ON" in all environments and then we change to make the dependency
  not optional.
</p>

<h4>Example - Optional dependency</h4>
<pre content="java">
@Factory
class Configuration {

  /**
   * Optionally provide MessageQueue.
   */
  @Bean
  Optional<|MessageQueue> buildQueue() {
    if (...) { // maybe read external config etc
      // Not providing the dependency (kind of like feature toggle)
      return Optional.empty();
    }
    return Optional.of(...);
  }

}
</pre>
<h3 id="useOfFactory">Use of @Factory @Bean</h3>
<p>
  It is good to use <code>@Factory</code> for all the dependencies we want to
  create programmatically. Many teams will have a standard location/package they use to
  put a "configuration factory bean" where all programmatically created dependencies are
  defined as a general approach.
</p>
<p>
  If we see logic in constructors then we typically would try to move that logic to a
  factory bean method and keep the constructors simple. Logic in constructors typically
  makes it harder from a testing perspective.
</p>

<h2 id="primary">@Primary</h2>
<p>
  A bean with <code>@Primary</code> is deemed to be highest priority and will be injected and used
  when it is available. This is functionally the same as Spring and Micronaut <em>@Primary</em>.
</p>
<p>
  There should only ever be <b>one</b> bean implementation marked as <em>@Primary</em> for
  a given dependency.
</p>

<h4>Example</h4>
<pre content="java">
// Highest priority EmailServer
// Used when available (e.g. module in the class path)
@Primary
@Singleton
public class PreferredEmailSender implements EmailServer {
  ...
</pre>

<h2 id="secondary">@Secondary</h2>
<p>
  A bean with <code>@Secondary</code> is deemed to be lowest priority and will only be injected
  if there are no other candidates to inject. We use <code>@Secondary</code> to indicate a
  "default" or "fallback" implementation that will be superseded by any other available implementation.
</p>
<p>
  This is functionally the same as Spring and Micronaut <em>@Secondary</em>.
</p>
<h4>Example</h4>
<pre content="java">
// Lowest priority EmailServer
// Only used if no other EmailServer is available
@Secondary
@Singleton
public class DefaultEmailSender implements EmailServer {
  ...
</pre>

<h3 id="primary-usage">Use of @Primary and @Secondary</h3>
<p>
  <code>@Primary</code> and <code>@Secondary</code> are used when there are
  multiple candidates to inject. They provide a "priority" to determine which dependency to
  inject and use when injecting a single implementation and multiple candidates are available
  to inject.
</p>
<p>
  We typically use <em>@Primary</em> and <em>@Secondary</em> when we are
  building multi-module applications. We have multiple modules (jars) that provide implementations.
  We use <em>@Secondary</em> to indicate a "default" or "fallback" implementation to use
  and we use <em>@Primary</em> to indicate the best implementation to use when it is available.
  <em>avaje-inject</em> DI will then wire depending on which modules (jars) are included in the classpath.
</p>

<h3 id="prototype">@Prototype</h3>
<p>When the <em>@Prototype</em> annotation is added to a class/factory bean method, a new instance of the bean will be created each time it is requested or wired.</p>

<pre content="java">
@Prototype
public class Proto {
  //every time this bean is requested, the constructor is called to provide another instance
  ...
  }
</pre>
<pre content="java">
@Factory
class ProtoFactory {
  //every time this bean is requested, the factory method is called to provide another instance
  @Bean
  @Prototype
  Example proto() {
    return new Example();
  }

}
</pre>

<h3 id="lazy">@Lazy</h3>
<p>
  We can use <code>@Lazy</code> on beans/factory methods to defer bean initialization until the annotated bean is requested.
</p>

<pre content="java">
@Lazy
public class Sloth {

  private final Moss moss;

  @Inject //this will not be called until the bean is requested
  Sloth(Moss moss) {
    this.moss = moss;
  }
}
</pre>
<p>
  There are two ways to lazily load the bean.
</p>
<h4>1. Directly retrieve from the bean scope:</h4>
<pre content="java">
      final var scope = BeanScope.builder().build();
      scope.get(Sloth.class); //Sloth is initialized here
</pre>

<h4>2. Use a <em>Provider</em></h4>

<p>Unlike regular provider beans, the providers for lazy beans will return the same singleton instance.</p>

<pre content="java">
@Singleton
class UseSloth  {

  private final Provider<|Sloth> slothProvider;

  UseFoo(Provider<|Sloth> slothProvider) {
    this.slothProvider = slothProvider;
  }

  void doStuff() {

    // get the singleton Sloth instance and use it
    Sloth sloth = slothProvider.get();
    ...
  }
}
</pre>
