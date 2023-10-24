<h2 id="dependency">Dependencies</h2>

<h3 id="maven">Maven</h3>
<p>
  See the <a href="#quick-start">quick start example </a>
</p>

<h3 id="gradle">Gradle</h3>
<p>
  See the example at:
  <a href="https://github.com/dinject/examples/blob/master/javalin-gradle-java-basic/build.gradle">examples/javalin-gradle-java-basic/build.gradle</a>
</p>

<h4>Gradle 5.2+</h4>
<p>
  Use Gradle version 5.2 or greater which has better support for annotation processing.
</p>

<h4>Dependencies</h4>
<p>
  Add <em>avaje-inject</em> as an implementation dependency, <em>avaje-inject-generator</em> as
  an annotation processor, and <em>avaje-inject-test</em> as a test dependency.
</p>

<pre content="groovy">

dependencies {
  ...
  implementation('io.avaje:avaje-inject:${inject.version}')
  annotationProcessor('io.avaje:avaje-inject-generator:${inject.version}')

  testImplementation('io.avaje:avaje-inject-test:${inject.version}')
  testAnnotationProcessor('io.avaje:avaje-inject-generator:${inject.version}')
}
</pre>

<h4>Kotlin KAPT</h4>
<p>
  See example at: https://github.com/dinject/examples/blob/master/basic-di-kotlin-maven/pom.xml
</p>
<p>
  For use with Kotlin we register <em>avaje-inject-generator</em> as a <code>kapt</code> processor
  to the Kotlin compiler rather than <em>annotationProcessor</em>.
</p>
<pre content="groovy">
dependencies {
  ...
  implementation('io.avaje:avaje-inject:${inject.version}')
  kapt('io.avaje:avaje-inject-generator:${inject.version}')

  testImplementation('io.avaje:avaje-inject-test:${inject.version}')
}
</pre>


<h2 id="jpms">Java Module Setup</h2>
<p>
  If using java modules, in the <code>module-info.java</code> we need to:
</p>
<ol>
  <li>Add a <em>requires</em> clause for <em>io.avaje.inject</em></li>
  <li>Add a <em>provides</em> clause for <em>io.avaje.inject.spi.Module</em></li>
</ol>

<h5>Example module-info</h5>
<pre content="java">
import io.avaje.inject.spi.Module;

module org.example {

  requires io.avaje.inject;
  // you must define the fully qualified class name of the generated classes. if you use an import statement, compilation will fail
  provides Module with org.example.ExampleModule;
}
</pre>
<p>
 In the example above, <code>org.example.ExampleModule</code> is generated code typically found in
  <code>target/generated-sources/annotations</code>.
</p>

<h3>External Avaje Dependencies</h3>
<p>
  If your project uses the module system and imports maven dependencies that provide inject </code>Plugin</code>/</code>Module</code> classes,
  you will need to add the <a href="#autoRequires">maven/gradle inject plugin</a> so that the generated DI classes from the dependencies are discovered.
</p>

<h2 id="generated">Generated Sources</h2>

<h3>DI classes</h3>

<p>
DI classes will be generated to call the constructors for annotated type/factory methods.
</p>
<p>
Below is the class generated for the Example class in the above quickstart.
</p>

<pre content="java">
@Generated("io.avaje.inject.generator")
public final class Example$DI  {

  /**
   * Create and register Example.
   */
  public static void build(Builder builder) {
    if (builder.isAddBeanFor(Example.class)) {
      var bean = new Example(builder.get(DependencyClass.class,"!d1"), builder.get(DependencyClass2.class,"!d2"));
      builder.register(bean);
      // depending on the type of bean, callbacks for field/method injection, and lifecycle support will be generated here as well.
    }
  }
}
</pre>

<h3>Generated Wiring Class</h3>
<p>
The inject annotation processor will determine the dependency wiring order of a project and generate a Module class that will wire the beans.
</p>

<pre content="java">
@Generated("io.avaje.inject.generator")
@InjectModule
public final class ExampleModule implements Module {

  private Builder builder;

  @Override
  public Class<?>[] classes() {
    return new Class<?>[] {
      org.example.DependencyClass.class,
      org.example.DependencyClass2.class,
      org.example.Example.class,
      org.example.ExampleFactory.class,
    };
  }

  /**
   * Creates all the beans in order based on constructor dependencies. The beans are registered
   * into the builder along with callbacks for field/method injection, and lifecycle
   * support.
   */
  @Override
  public void build(Builder builder) {
    this.builder = builder;
    // create beans in order based on constructor dependencies
    // i.e. "provides" followed by "dependsOn"
    build_example_ExampleFactory();
    build_example_DependencyClass();
    build_example_DependencyClass2();
    build_example_Example();
  }

  @DependencyMeta(type = "org.example.ExampleFactory")
  private void build_example_ExampleFactory() {
    ExampleFactory$DI.build(builder);
  }

  @DependencyMeta(type = "org.example.DependencyClass")
  private void build_example_DependencyClass() {
    DependencyClass$DI.build(builder);
  }

  @DependencyMeta(
      type = "org.example.DependencyClass2",
      method = "org.example.ExampleFactory$DI.build_bean", // factory method
      dependsOn = {"org.example.ExampleFactory"}) //factory beans naturally depend on the factory
  private void build_example_DependencyClass2() {
    ExampleFactory$DI.build_bean(builder);
  }

  @DependencyMeta(
      type = "org.example.Example",
      dependsOn = {"org.example.DependencyClass", "org.example.DependencyClass2"})
  private void build_example_Example() {
    Example$DI.build(builder);
  }
}
</pre>
