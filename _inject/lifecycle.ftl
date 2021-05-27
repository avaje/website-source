<h2 id="lifecycle">Lifecycle</h2>

<h3 id="post-construct">@PostConstruct</h3>
<p>
  Put <code>@PostConstruct</code> on a method that we want to run on startup just after all the
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

<h3 id="pre-destroy">@PreDestroy</h3>
<p>
  Put <code>@PreDestroy</code> on a method that we want to run on shutdown.
</p>
<p>
  Typically we want this method to close resources.
</p>
<pre content="java">
@Singleton
public class CoffeeMaker {

  @PreDestroy
  void onShutdown() {
    // close resources
    ...
  }
  ...
</pre>

<h3 id="auto-closeable">AutoCloseable and Closeable</h3>
<p>
  Both <code>java.lang.AutoCloseable</code> and <code>java.io.Closeable</code> are treated as <em>PreDestroy</em>
  lifecycle methods. Types that implement these interfaces do not need to annotate the <code>close()</code> method,
  it will automatically be treated as if it had a <code>@PreDestroy</code>.
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
