<h2 id="scope">@Scope</h2>

<p>
  All beans are instantiated within a <i>scope</i>. A few scopes are provided for you out of the box, but you can also define your own
  by creating an annotation and then meta-annotating it with <code>@Scope</code>. Scopes can depend on each other and also externally
  defined objects, thus allowing a hierarchy of scopes to be modelled. Each scope results in the generation of a module class that
  can be added to a <code>BeanScope</code> using the <code>withModules</code> method. The constructor of the module class takes the
  externally defined dependencies. This makes it easy to partially adopt Avaje Inject: some objects can be built manually by your own code
  and then provided to the DI scope.
</p>

<pre content="java">
@Scope
@InjectModule(requires = {NonDIConstructedObject.class})
public @interface MyCustomScope {
}

@MyCustomScope
public class SomeObject {
  public SomeObject(NonDIConstructedObject obj) { ... }
}

public class App {
  public static void main(String[] args) {
    BeanScope scope = BeanScope.newBuilder().withModules(new MyCustomScopeModule(new NonDIConstructedObject())).build();
    SomeObject obj = scope.get(SomeObject.class);
  }
}
</pre>

<p>
  For simple uses you don't need any custom scopes. You can just annotate classes with `@Singleton` and use the default scope, which
  is used if you don't specify any modules to the <code>BeanScope</code> constructor. It's located using the <code>ServiceLoader</code>
  mechanism.
</p>

<p>
  To make one scope depend on another, just put the depended-on scope's annotation into the <code>@InjectModule(requires = { .. })</code>
  list, then call the <code>withParent</code> method of the <code>BeanScope</code> to chain them together.
</p>
