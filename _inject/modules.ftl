
<h2 id="modules">Modules</h2><hr/>
<p>
  To wire all the beans into a scope, <i>avaje-inject</i> generates module classes that run all the constructors/factory methods and adds all beans to the <i>scope</i>.
</p>
<h3 id="single-module">Single Module Apps</h3>
<p>
  When we are wiring dependencies that are all part of a single jar/module then we don't
  really care about <em>module ordering</em>. All the dependencies that are being injected are known and
  provided by the same jar/module or provided externally.
</p>

<h4>requires - external dependency</h4>
<p>
  <code>@InjectModule(requires = ...)</code> can specify an external dependency that will
  be programmatically provided. This prevents compilation errors when the processor cannot find the dependency at compile-time. See also <a href="#external">@External</a>.
</p>
<pre content="java">
// at compile time, allow injection of MyExternalDependency
// ... even though it doesn't exist in this module
@InjectModule(requires = MyExternalDependency.class)
</pre>
<p>
  When creating the BeanScope we provide the externally created dependencies using
  <code>bean()</code>. These external dependencies are then injected where needed.
</p>
<pre content="java">

  MyExternalDependency myExternal = ...;

  // create with an externally provided dependency
  final BeanScope scope = BeanScope.builder()
    .bean(MyExternalDependency.class, myExternal)
    .build();
</pre>


<h4>ignoreSingleton</h4>
<p>
  We use <code>@InjectModule(ignoreSingleton = true)</code> in order to specify that we want
  avaje-inject to ignore standard JSR-330 <code>@Singleton</code> - with the expectation
  that another DI library (like Guice) is being used and we want avaje-inject to co-exist
  and ignore anything annotated with <code>@Singleton</code>.
</p>
<pre content="java">
@InjectModule(ignoreSingleton = true)
</pre>
<p>
  When using <code>ignoreSingleton = true</code> we use <a href="#component">@Component</a> instead of
  using <code>@Singleton</code>.
</p>

<h3 id="multi-module">Multi-module Apps</h3>
<p>
  When wiring dependencies that span multiple jars/modules, avaje provides control over the order in which the modules are wired.
  The processor provides this control with <code>@InjectModule</code> and the use of <code>provides</code>, and <code>requires</code>
  or <code>requiresPackages</code>.
</p>

<h4>Example - modular coffee app</h4>
<p>
  See example source at <a href="https://github.com/avaje/avaje-inject-examples/tree/main/modular-coffee-app">avaje-inject-examples / modular-coffee-app</a>
</p>

<h5>module 1 - coffee-heater</h5>
<pre content="java">
  @InjectModule(name="coffee-heater", provides = Heater.class)
</pre>

<h5>module 2 - coffee-pump</h5>
<pre content="java">
  @InjectModule(name = "coffee-pump", requires = Heater.class, provides = Pump.class)
</pre>
<p>
  This module expects <code>Heater</code> to be provided by another module. In effect, the
  coffee-heater module must be wired <em>before</em> this module, and it provides the Heater
  that is required when we wire the coffee-pump module.
</p>

<h5>module 3 - coffee-main</h5>
<pre content="java">
  @InjectModule(name = "coffee-main", requires = {Heater.class, Pump.class})
</pre>
<p>
  This module expects <code>Heater</code> and <code>Pump</code> to be provided by other module(s).
  It needs other modules to be wired before and for those modules to provide the Heater and Pump.
</p>
<p>
  avaje-inject determines the order in which to wire the modules based on <code>provides, requires</code>. In this example
  it needs to wire the modules in order of: <em>coffee-heater, coffee-pump and then coffee-main</em>. As the modules are wired, the beans from any previously wired modules are
  available to the module being wired.
</p>

<h3>requires vs requiresPackages</h3>
<p>
  We use either <code>requires</code> OR <code>requiresPackages</code>. Using requires is nice in that
  we explicitly list each external dependency that the module requires BUT this can get onerous when this
  is a really large list. In this case we can use <code>requiresPackages</code> instead and that makes
  the assumption that any dependency under those packages will be provided. So using requiresPackages
  is less strict but more practical when there is a lot of module dependencies.
</p>
<p>
  When we use <code>requiresPackages</code> that means that <code>provides</code> can similarly specify
  a class at the top level, and we don't need to list ALL the provided dependencies.
</p>

<h3 id="autorequires" >autoRequires</h3>
<p>
 <em>avaje-inject</em> can also automatically read the classpath/maven dependencies at compile-time to find all the modules and automatically determine the <code>requires</code> dependencies.
 This works fine in most cases, but when you are using the annotation processor with a java 9+ modular project or defined as an annotationProcessorPath in the <code>maven-compiler-plugin</code>, you will need to add the <code>avaje-inject-maven-plugin</code>. (For Gradle, use the <code>avaje-inject-gradle-plugin</code>)
</p>

<pre content="xml">
<plugin>
  <groupId>io.avaje</groupId>
  <artifactId>avaje-inject-maven-plugin</artifactId>
  <version>${avaje.inject.version}</version>
  <executions>
    <execution>
      <phase>process-sources</phase>
      <goals>
        <goal>provides</goal>
      </goals>
    </execution>
  </executions>
</plugin>
</pre>

<p>
This generates 2 files in the target folder before the code is compiled: <code>target/avaje-module-dependencies.csv</code> and <code>target/avaje-plugin-provides.txt</code>.

These files contain all the metadata for all the modules and plugins provided by all external modules on the classpath/maven dependencies. The annotation processor then reads the files at compile time and will not throw a compilation error if these components are required dependencies.

<h3 id="shading">Shading Note</h3>

<p> As avaje uses the <code>ServiceLoader</code> to load <code>AvajeModule</code> instances, be sure to have the following configuration set when using the maven shade plugin on multi-module projects.
<pre content="xml">
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-shade-plugin</artifactId>
  <configuration>
    <transformers>
      <transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer" />
    </transformers>
  </configuration>
</plugin>
</pre>

<p> This ensures that the <code>META-INF/services</code> files in the shaded dependencies are merged into the UberJar. With all service entries merged, avaje can discover and load all available modules.

<h3 id="inject-module">@InjectModule</h3>

<h4 id="module-name">name</h4>
<p>
  Give the module an explicit name. Otherwise, it is derived from the top level package.
</p>

<h4 id="module-ignoreSingleton">ignoreSingleton</h4>
<p>
  Set this to true in order to specify that we want
  avaje-inject to ignore standard JSR-330 <code>@Singleton</code> with the expectation
  that another DI library (like Guice) is being used and we want avaje-inject to co-exist
  and ignore anything annotated with <code>@Singleton</code>.
</p>

<h4 id="module-provides">provides</h4>
<p>
  List the classes that this module provides, this is usually determined automatically, but it can be manually overridden to change wiring order.
</p>
<pre content="java">
@InjectModule(name = "feature-toggle", provides = FeatureToggle.class)
</pre>

<h4 id="module-requires">requires</h4>
<p>
  Defines dependencies that the modules depends on that are provided by another module or manually.
</p>
<pre content="java">
@InjectModule(name = "job-system", requires = FeatureToggle.class)
</pre>
<p>
  In effect this allows the job system components to depend on <code>FeatureToggle</code> with the expectation that
  it will be supplied by another module or supplied manually.
</p>

<h4 id="module-requiresPackages">requiresPackages</h4>
<p>
  If we have a LOT of dependencies provided by another module specifying each of these explicitly in <code>requires</code>
  can get verbose. Instead of doing that we can use <code>requiresPackages</code> to define top level packages, any
  dependency required under top level packages will be expected to be provided by another module.
</p>
<pre content="java">
  // anything at or below the package of Feature is provided externally
  @InjectModule(name = "job-system", requiresPackages=Feature.class)
</pre>

<h4 id="strict-wiring">strictWiring</h4>
<p>
   Optimizes multi-module wiring by enforcing wiring checks at compile-time and generating a preset wiring plan. Will cause the generator to throw a descriptive
   compilation error if all inter-module <code>InjectModule#requires</code> dependencies are not satisfied at compile time.
</p>

<p>Set true if your project:</p>

<ol>
  <li>Is not itself consumed by another project/library
  <li>Does not dynamically provide beans at runtime
 </ol>
</p>
<pre content="java">
@InjectModule(strictWiring =true)
</pre>

<p>
  <em>avaje-inject</em> uses provides, requires and requiresPackages to determine the order in which the modules should be created
  and wired. <em>avaje-inject</em> finds all the modules in the classpath/modulepath (via Service loader) and then orders the modules
  based on provides, requires, requiresPackages. In the example above the "feature-toggle" module are wired first,
  and then the beans it contains are then available when wiring the "job-system".
</p>
