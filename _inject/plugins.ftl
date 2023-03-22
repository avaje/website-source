<h2 id="plugins">Plugins</h3>

<P>If you want to execute code when creating a bean scope, you can implement the <code>Plugin</code> SPI.
  Typically, a plugin might provide a default dependency via <code>BeanScopeBuilder.provideDefault()</code>.
</p>

<P>Plugins implement the <code>io.avaje.inject.spi.Plugin</code> interface and are found
      and registered via <code>ServiceLoader</code>. This means they have a
      file at <code>src/main/resources/META-INF/services/io.avaje.inject.spi.Plugin</code>
      which contains the fully qualified class name of the implementation.</P>

<p>Below is an example plugin that provides a default ExampleBean instance. </p>
<pre content="java">
public final class DefaultBeanProvider implements io.avaje.inject.spi.Plugin {

  //this is called at compile time to tell avaje what bean classes (if any) this plugin provides
  @Override
  public Class<?>[] provides() {
    return new Class<?>[]{ExampleBean.class};
  }

  // this is called at runtime before any beans are wired
  @Override
  public void apply(BeanScopeBuilder builder) {
    //you can access the scope's wiring properties to help configure your plugin
    var props = builder.propertyPlugin();

    //provide a default bean
    builder.provideDefault(ExampleBean.class, ExampleBean::new);
  }
}
</pre>
