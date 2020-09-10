
<h2 id="modules">Modules</h2>

<h3 id="single-module">Single module apps</h3>
<p>
  When we are wiring dependencies that are all part of a single jar/module then we don't
  really care about modules. All the dependencies that are being injected are known and
  provided by the same jar/module.
</p>
<p>
  In a single module app there is only 1 BeanContext.
</p>

<h3 id="multi-module">Multi-module apps</h3>
<p>
  When we are wiring dependencies that span multiple jars/modules then we to provide more
  control over the order in which each modules dependencies are wired. We provide this control
  by using <code>@ContextModule</code>.
</p>
<p>
  In a multi-module app there is 1 BeanContext per module and <em>avaje-inject</em> needs to
  determine the order in which the modules are wired. It does this using the module <em>provides</em>
  and <em>dependsOn</em>.
</p>

<h3 id="unnamed-module">Unnamed modules</h3>
<p>
  When we don't specify <em>@ContextModule</em> on a module it is an <em>unnamed module</em>.
  In effect a module name is derived from the top most package and that module has no
  <em>provides</em> or <em>dependsOn</em> specified.
</p>

<h3 id="context-module">@ContextModule</h3>
<p>
  Use <code>@ContextModule</code> to explicitly name a module and define the features it <em>provides</em>
  and the features it <em>dependsOn</em>. The <em>provides</em> and <em>dependsOn</em> effectively control
  the order in which modules are wired.
</p>
<pre content="java">
@ContextModule(name = "feature-toggle")
</pre>
<p>
  We use the <code>@ContextModule</code> annotation to give a module an explicit name.
</p>

<h3 id="module-dependsOn">Module dependsOn</h3>
<p>
  Modules that depend on functionality / beans from other modules specify in <code>dependsOn</code>
  the modules that should provide beans they want to inject.
</p>
<pre content="java">
@ContextModule(name = "job-system", dependsOn = {"feature-toggle"})
</pre>
<p>
  With the above example the "job-system" module expects bean(s) from the "feature-toggle" module to be
  available for injecting into it's bean graph.
</p>
<p>
  For <em>avaje-inject</em> internally this defines the order in which the bean contexts in each of the modules are created.
  <em>avaje-inject</em> finds all the modules in the classpath (via Service loader) and then orders the modules based on the
  dependsOn values. In the example above the "feature-toggle" bean context must be built first, and then the
  beans it contains are available when building the "job-system" bean context.
</p>

