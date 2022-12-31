<h2 id="qualifiers">Qualifiers</h2>

<h3 id="named">@Named</h3>
<p>
  When we have multiple beans that implement a common interface we can qualify
  which instance to use by specifying <code>@Named</code> on the beans and where
  they are injected. This is a standard part of most Java DI frameworks.
</p>
<p>
  Note that qualifier names are treated as case insensitive.
</p>
<p>
  Lets say we have a Store interface with multiple implementations. We can have
  multiple implementations with <em>@Named</em> qualifier like the example below.
</p>
<pre content="java">
@Named("blue")
@Singleton
public class BlueStore implements Store {
  ...
}


@Named("red")
@Singleton
public class RedStore implements Store {
  ...
}
</pre>

<p>
  Alternatively if we are creating the instances using <em>@Factory</em> <em>@Bean</em> methods
  we can similarly put <em>@Named</em> on the <em>@Bean</em> methods.
</p>

<pre content="java">
@Factory
public class StoreFactory {

  @Bean @Named("red")
  public Store createRedStore() {
    return new RedStore(...);
  }

  @Bean @Named("blue")
  public Store createBlueStore() {
    return new BlueStore(...);
  }
}
</pre>

<p>
  Finally, we can specify the name when explicitly registering a bean with a <code>BeanScope</code>.
</p>

<p>
  We can then specify which <em>@Named</em> instance to inject by specifying the qualifier.
</p>

<pre content="java">
@Singleton
public class OrderProcessor {
  private final Store store;

  public OrderProcessor(@Named("red") Store store) {
    this.store = store;
  }
  ...
</pre>
<pre content="java">
@Singleton
public class OrderProcessor {

  @Inject @Named("red")  // field injection
  Store store;

  ...
</pre>

<p>
  <code>@Named</code> is a standard part of Java dependency injection frameworks. Avaje Inject goes further and eliminates the need for
  writing out the annotation at all. All injectable parameters or fields that don't specify <code>@Named</code> explicitly are implicitly
  given a name of <code>!name</code>. So the above can be more cleanly written by relying on this implicit rule, like this:
</p>

<pre content="java">
@Singleton
public class OrderProcessor {
  private final Store store;

  public OrderProcessor(Store red) {
    this.store = store;
  }
  ...
</pre>

<p>
  This type of implicit naming is useful if you want to inject things with a relatively widely used type, for example,
  a <code>java.nio.file.Path</code> object.
</p>

<h3 id="qualifier">@Qualifier</h3>
<p>
  Instead of using <em>@Named</em> we can create our own annotations using <code>@Qualifier</code>.
  This gives a strongly typed approach to qualifying the beans rather than using string literals in
  <em>@Named</em> so could be better when there is a lot of named/qualified beans.
</p>
<h5>example</h5>
<pre content="java">
import javax.inject.Qualifier;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Qualifier
@Retention(RetentionPolicy.RUNTIME)
public @interface Blue {}
</pre>
<p>
  Then we can use our <em>@Blue</em> annotation.
</p>
<pre content="java">
@Blue
@Singleton
public class BlueStore implements Store {
  ...
</pre>
<pre content="java">
@Singleton
public class StoreManager {

  private final Store store;

  public StoreManager(@Blue Store store) {
    this.store = store;
  }
  ...
</pre>
