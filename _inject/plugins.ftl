<h2 id="plugins">Plugins</h3>

<P>If you want to execute code when creating a bean scope, you can implement the <code>InjectPlugin</code> SPI.
  Typically, a plugin might provide a default dependency via <code>BeanScopeBuilder.provideDefault()</code>.
</p>

<P>Plugins implement the <code>io.avaje.inject.spi.InjectPlugin</code> interface, which extends the
      <code>io.avaje.inject.spi.InjectSPI</code> interface, found and registered via <code>ServiceLoader</code>.
      This means they have a file at <code>src/main/resources/META-INF/services/io.avaje.inject.spi.InjectSPI</code>
      which contains the fully qualified class name of the implementation.</P>

<p>Below is an example plugin that provides a default ExampleBean instance. </p>
<pre content="java">
 //this is read at compile-time to tell the avaje generator what bean classes are provided
@PluginProvides({ExampleBean.class})
public final class DefaultBeanProvider implements io.avaje.inject.spi.InjectPlugin {

  //this is called at runtime to tell avaje beanscope what bean classes this plugin provides
  @Override
  public Type[] provides() {
    return new Type[]{ExampleBean.class};
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
