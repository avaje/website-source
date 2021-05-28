<h2 id="qualifiers">Qualifiers</h2>

<h3 id="named">@Named</h3>
<p>
  When we have multiple beans that implement a common interface and we can qualify
  which instance is used by specifying <code>@Named</code> on the beans and where
  they are injected.
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
