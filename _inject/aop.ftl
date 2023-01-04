<h2 id="aop">Aspect Oriented Programming</h3>
This library has several contructs that support Aspect Oriented Programmming

<h3 id="aspect">@Aspect</h3>
<p>
  We can create an annotation and annotate with <code>@Aspect</code> to define an aspect annotation.
   Aspect.target() specifies the associated type that implements <code>AspectProvider</code>.
</p>

<pre content="java">
@Aspect(target = MyAroundAspect.class)
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAround {

  String name() default "";
}
</pre>

<p>The AspectProvider should be a <code>@Singleton</code> that provides a <code>MethodInterceptor</code>. (Which will intercept the method call).</p>

<pre content="java">
@Singleton
public class MyAroundAspect implements AspectProvider<MyAround>, MethodInterceptor {
  @Override
  public MethodInterceptor interceptor(Method method, MyAround around) {
    //For the sake of brevity we have made this class also implement MethodInterceptor
    return this;
  }

  @Override
  public void invoke(Invocation invoke) throws Throwable {
    System.out.println("before args: " + Arrays.toString(invoke.arguments()) + " method: " + invoke.method());
    try {
      invoke.invoke();
    } finally {
      System.out.println("after");
    }
  }
}
</pre>

<p>
With the provider set, we can use our newly created aspect annotation on a class/method to intercept calls.
</p>

<pre content="java">
@Singleton
public class ExampleService {

  @MyAround
  public String other(
      String param0, int param1) {
    return "other " + param0 + " " + param1;
  }
}
</pre>

<p>
  Avaje will generate a proxy class that will run the aspects for every annotated method.
</p>
<pre content="java">
@Proxy
@Generated("io.avaje.inject.generator")
public class ExampleService$Proxy extends ExampleService {

  private final MyAroundAspect myAroundAspect;

  private Method other0;
  private MethodInterceptor other0MyAround;

  public ExampleService$Proxy(MyAroundAspect myAroundAspect) {
    super();
    this.myAroundAspect = myAroundAspect;
    try {
      other0 = ExampleService.class.getDeclaredMethod("other", String.class, int.class);
      other0MyAround = myAroundAspect.interceptor(other0, other0.getAnnotation(MyAround.class));
    } catch (Exception e) {
      throw new IllegalStateException(e);
    }
  }

  @Override
  public java.lang.String other(String param0, int param1) {
    var call = new Invocation.Call<>(() -> super.other(param0, param1))
      .with(this, other0, param0, param1);
    try {
      other0MyAround.invoke(call);
      return call.finalResult();
    } catch (InvocationException e) {
      throw e;
    } catch (Throwable e) {
      throw new InvocationException(e);
    }
  }
}
</pre>
