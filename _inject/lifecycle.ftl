<h2 id="lifecycle">Lifecycle</h2><hr/>

<h3 id="post-construct">@PostConstruct</h3>
<p>
  Put <code>@PostConstruct</code> on a method to run it on startup just after all the
  beans have been wired.
</p>
<p>
  Typically we open a resource like network connections to a remote resource (cache, queue, database etc).
</p>
<pre content="java">
@Singleton
public class CoffeeMaker {

  @PostConstruct
  void onStartup() {
    // connect to remote resource ...
    ...
  }
  ...
</pre>

<h4>@PostConstruct with BeanScope</h3>
<p>
  Since post construct methods execute after all the beans have been wired, the completed BeanScope can be a parameter.
</p>

<pre content="java">
@Singleton
public class CoffeeMaker {
  Beans beans;

  @PostConstruct
  void onStartup(BeanScope scope) {
   beans = scope.get(Beans.class);
  }
  ...
</pre>

<h3 id="pre-destroy">@PreDestroy</h3>
<p>
  Put <code>@PreDestroy</code> on a method to run on shutdown. (Typically to close resources)
</p>
<pre content="java">
@Singleton
public class CoffeeMaker {

  @PreDestroy
  void onShutdown() {
    // close resources
    ...
  }

  @PreDestroy(priority=20) //default value is 1000
  void onShutdownPriority() {
    // close resources in a specific order
    ...
  }
  ...
</pre>

<h3 id="auto-closeable">AutoCloseable and Closeable</h3>
<p>
  Both <code>java.lang.AutoCloseable</code> and <code>java.io.Closeable</code> are treated as <em>PreDestroy</em>
  lifecycle methods. Types that implement these interfaces do not need to annotate the <code>close()</code> method,
  it will automatically be treated as if it had a <code>@PreDestroy</code> and executed when the bean scope is closed.
</p>

<pre content="java">
@Singleton
public class CoffeeQueue implements AutoCloseable {

  /**
   * Automatically treated as a PreDestroy method.
   */
  @Override
  public void close() {
    // close resources
    ...
  }
  ...
</pre>

<h3 id="shutdownHook">Shutdown hook</h3>
<p>
  When <code>BeanScope</code> is created, you can specify if it should register a JVM shutdown hook.
  This is fired when the JVM is shutdown to invoke the PreDestroy methods. Otherwise,
  <code>PreDestroy</code> methods are closed when the BeanScope is closed.
</p>
<pre content="java">
BeanScope beanScope =
  BeanScope.builder()
      .shutdownHook(true) // create with JVM shutdown hook
      .build()
</pre>
